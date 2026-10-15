import Foundation

/// Finds the element a ``Locator`` means when its accessibility identifier no longer matches,
/// and says how it found it, so the test can keep running and the identifier can be fixed.
///
/// The healer tries these strategies in order and stops at the first one that gives an answer:
///
/// 1. **Identifier**: an element with exactly the locator's identifier.
/// 2. **Label**: the one element showing one of the locator's labels (ignoring case and
///    surrounding spaces). If several elements show it and exactly one of them is interactive,
///    that one is used.
/// 3. **Placeholder**: the one text field with the locator's placeholder.
/// 4. **Similar identifier**: the element whose identifier is closest to the expected one,
///    ignoring case and punctuation (`loginButton`, `login_button` and `auth.loginButton` are
///    close), if the similarity reaches ``minimumSimilarity``.
///
/// A strategy that finds two equally good elements reports ``Resolution/ambiguous(_:strategy:)``
/// instead of guessing: a test that taps the wrong element is worse than a test that fails.
public struct LocatorHealer: Sendable, Equatable {
    /// How an element was found.
    public enum Strategy: String, Sendable, Codable {
        case identifier
        case label
        case placeholder
        case similarIdentifier
    }

    /// An element the healer settled on.
    public struct Match: Sendable, Hashable {
        /// The element's position in the array passed to ``LocatorHealer/resolve(_:in:)``.
        public let index: Int
        public let element: ElementDescriptor
        public let strategy: Strategy
        /// 1 for exact matches; the similarity for ``Strategy/similarIdentifier``.
        public let score: Double

        /// True when the element was found by anything other than its exact identifier.
        public var isHealed: Bool { strategy != .identifier }
    }

    /// The healer's answer.
    public enum Resolution: Sendable, Hashable {
        case found(Match)
        /// Several elements matched equally well with `strategy`.
        case ambiguous([ElementDescriptor], strategy: Strategy)
        case notFound

        /// The match, if one was found.
        public var match: Match? {
            if case .found(let match) = self { return match }
            return nil
        }
    }

    /// Identifiers longer than this (after normalizing) are only compared exactly, which keeps
    /// the edit-distance work bounded on large element trees.
    public static let maximumComparedLength = 128

    /// The similarity, from 0 to 1, that a different identifier needs to count as the same
    /// element. Values outside 0.5...1 (and NaN) are clamped; the default is 0.8.
    public let minimumSimilarity: Double

    public init(minimumSimilarity: Double = 0.8) {
        self.minimumSimilarity = minimumSimilarity.isNaN ? 0.8 : min(max(minimumSimilarity, 0.5), 1)
    }

    /// Resolves `locator` against a flat list of elements, such as the descendants of a screen.
    public func resolve(_ locator: Locator, in elements: [ElementDescriptor]) -> Resolution {
        let candidates = elements.indices.filter { index in
            guard let kind = locator.kind, kind != .any else { return true }
            return elements[index].kind == kind
        }
        if !locator.identifier.isEmpty,
           let index = candidates.first(where: { elements[$0].identifier == locator.identifier }) {
            return .found(Match(index: index, element: elements[index], strategy: .identifier, score: 1))
        }
        for label in locator.labels {
            let matches = candidates.filter { Self.sameText(elements[$0].label, label) }
            if let resolution = Self.pick(matches, in: elements, strategy: .label) { return resolution }
        }
        if let placeholder = locator.placeholder {
            let matches = candidates.filter { Self.sameText(elements[$0].placeholder ?? "", placeholder) }
            if let resolution = Self.pick(matches, in: elements, strategy: .placeholder) { return resolution }
        }
        return similarIdentifier(locator.identifier, candidates: candidates, in: elements)
    }

    // MARK: - Strategies

    private static func sameText(_ text: String, _ expected: String) -> Bool {
        let expected = expected.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !expected.isEmpty else { return false }
        let text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return text.compare(expected, options: [.caseInsensitive]) == .orderedSame
    }

    private static func pick(_ matches: [Int], in elements: [ElementDescriptor], strategy: Strategy) -> Resolution? {
        switch matches.count {
        case 0:
            return nil
        case 1:
            return .found(Match(index: matches[0], element: elements[matches[0]], strategy: strategy, score: 1))
        default:
            let interactive = matches.filter { elements[$0].kind.isInteractive }
            if interactive.count == 1 {
                let index = interactive[0]
                return .found(Match(index: index, element: elements[index], strategy: strategy, score: 1))
            }
            return .ambiguous(matches.map { elements[$0] }, strategy: strategy)
        }
    }

    private func similarIdentifier(_ identifier: String, candidates: [Int], in elements: [ElementDescriptor]) -> Resolution {
        let target = Self.normalized(identifier)
        guard !target.isEmpty, target.count <= Self.maximumComparedLength else { return .notFound }

        var best: [(index: Int, score: Double)] = []
        for index in candidates {
            let candidate = Self.normalized(elements[index].identifier)
            guard !candidate.isEmpty, candidate.count <= Self.maximumComparedLength else { continue }
            let score = Self.similarity(target, candidate, atLeast: minimumSimilarity)
            guard score >= minimumSimilarity else { continue }
            if let top = best.first?.score {
                if score > top + 1e-9 {
                    best = [(index, score)]
                } else if abs(score - top) <= 1e-9 {
                    best.append((index, score))
                }
            } else {
                best = [(index, score)]
            }
        }
        guard let first = best.first else { return .notFound }
        // Several elements may carry the same identifier (a cell and its content); that is one
        // target, not an ambiguity.
        let distinctIdentifiers = Set(best.map { elements[$0.index].identifier })
        guard distinctIdentifiers.count == 1 else {
            return .ambiguous(best.map { elements[$0.index] }, strategy: .similarIdentifier)
        }
        return .found(Match(index: first.index, element: elements[first.index], strategy: .similarIdentifier, score: first.score))
    }

    // MARK: - Similarity

    /// Lowercased letters and digits only.
    static func normalized(_ identifier: String) -> [Unicode.Scalar] {
        identifier.lowercased().unicodeScalars.filter { CharacterSet.alphanumerics.contains($0) }
    }

    /// A similarity from 0 to 1: the better of the edit-distance similarity and a containment
    /// score for identifiers that only gained or lost a prefix or suffix.
    static func similarity(_ lhs: [Unicode.Scalar], _ rhs: [Unicode.Scalar], atLeast threshold: Double = 0) -> Double {
        if lhs == rhs { return 1 }
        let longer = max(lhs.count, rhs.count)
        let shorter = min(lhs.count, rhs.count)
        guard longer > 0 else { return 1 }

        var score = 0.0
        let (short, long) = lhs.count <= rhs.count ? (lhs, rhs) : (rhs, lhs)
        if shorter >= 4, contains(long, short) {
            score = 0.85 + 0.15 * Double(shorter) / Double(longer)
        }
        // The edit distance is at least the length difference, so skip the work when even that
        // cannot reach the threshold.
        let bestPossible = 1 - Double(longer - shorter) / Double(longer)
        if bestPossible > score, bestPossible >= threshold {
            let distance = editDistance(lhs, rhs)
            score = max(score, 1 - Double(distance) / Double(longer))
        }
        return score
    }

    private static func contains(_ haystack: [Unicode.Scalar], _ needle: [Unicode.Scalar]) -> Bool {
        guard needle.count <= haystack.count else { return false }
        for start in 0...(haystack.count - needle.count) where haystack[start..<(start + needle.count)].elementsEqual(needle) {
            return true
        }
        return false
    }

    /// Levenshtein distance with two rows of memory.
    static func editDistance(_ lhs: [Unicode.Scalar], _ rhs: [Unicode.Scalar]) -> Int {
        if lhs.isEmpty { return rhs.count }
        if rhs.isEmpty { return lhs.count }
        var previous = Array(0...rhs.count)
        var current = [Int](repeating: 0, count: rhs.count + 1)
        for i in 1...lhs.count {
            current[0] = i
            for j in 1...rhs.count {
                let substitution = previous[j - 1] + (lhs[i - 1] == rhs[j - 1] ? 0 : 1)
                current[j] = min(previous[j] + 1, current[j - 1] + 1, substitution)
            }
            swap(&previous, &current)
        }
        return previous[rhs.count]
    }
}
