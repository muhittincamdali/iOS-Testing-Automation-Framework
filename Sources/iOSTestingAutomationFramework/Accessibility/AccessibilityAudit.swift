import CoreGraphics
import Foundation

/// Checks a screen's elements against accessibility rules that can be decided from the element
/// tree alone.
///
/// The XCUITest layer runs it on a live screen (`XCUIElement.accessibilityIssues()`); you can
/// also run it on ``ElementDescriptor`` values you build yourself. It complements Apple's
/// `XCUIApplication.performAccessibilityAudit()`, which also checks contrast, Dynamic Type and
/// clipped text but cannot be run outside a UI test.
///
/// ```swift
/// let issues = AccessibilityAudit().run(on: elements)
/// #expect(issues.isEmpty, "\(issues.map(\.message))")
/// ```
public struct AccessibilityAudit: Sendable, Equatable {
    /// A rule the audit can check.
    public enum Rule: String, CaseIterable, Sendable, Codable {
        /// An interactive element without an accessibility label. VoiceOver can only read its
        /// type ("button"), so the person cannot tell what it does.
        case missingLabel
        /// An image without a label that is not hidden from accessibility.
        case imageWithoutLabel
        /// An enabled interactive element smaller than ``AccessibilityAudit/minimumTouchTarget``
        /// (44 × 44 points by default, Apple's Human Interface Guidelines minimum). Controls
        /// inside navigation bars, tab bars and toolbars are skipped: the system gives them a
        /// larger hit area than their drawn frame.
        case smallTouchTarget
        /// A label that repeats the element's kind, such as a button labelled "Close button".
        /// VoiceOver already says "button", so the person hears it twice.
        case labelRepeatsKind
        /// Two elements with the same non-empty accessibility identifier, which makes UI tests
        /// pick whichever comes first.
        case duplicateIdentifier
    }

    /// A rule violation.
    public struct Issue: Sendable, Hashable, Codable, CustomStringConvertible {
        public let rule: Rule
        public let element: ElementDescriptor
        public let message: String

        public var description: String { "[\(rule.rawValue)] \(message)" }
    }

    /// The rules to check. All rules are on by default.
    public var rules: Set<Rule>
    /// The smallest acceptable touch target, in points. Negative or non-finite values are
    /// treated as zero, which turns the size check off.
    public var minimumTouchTarget: CGSize

    public init(rules: Set<Rule> = Set(Rule.allCases), minimumTouchTarget: CGSize = CGSize(width: 44, height: 44)) {
        self.rules = rules
        self.minimumTouchTarget = minimumTouchTarget
    }

    /// Returns every violation, in element order. Elements with an empty or non-finite frame
    /// are skipped for the size rule only.
    ///
    /// The elements are expected parents first with their ``ElementDescriptor/depth``, as
    /// `XCUIElement.descriptors()` returns them. The depth tells the audit which elements sit
    /// inside a control (they are part of it and are not checked on their own) and which sit in
    /// a system bar.
    public func run(on elements: [ElementDescriptor]) -> [Issue] {
        var issues: [Issue] = []
        var standalone: [ElementDescriptor] = []
        // The kinds of the current element's ancestors, one entry per depth.
        var ancestors: [ElementKind] = []
        for element in elements {
            let depth = max(element.depth, 0)
            if ancestors.count > depth { ancestors.removeSubrange(depth...) }
            // An element inside a control (the switch inside a SwiftUI Toggle, the chevron of a
            // NavigationLink) is part of it: VoiceOver reads the control as one element.
            if !ancestors.contains(where: \.isInteractive) {
                let inSystemBar = ancestors.contains { Self.systemBarKinds.contains($0) }
                issues += check(element, inSystemBar: inSystemBar)
                standalone.append(element)
            }
            // Pad missing levels so the stack stays aligned with the depth.
            while ancestors.count < depth { ancestors.append(.other) }
            ancestors.append(element.kind)
        }
        if rules.contains(.duplicateIdentifier) {
            issues += duplicateIdentifiers(in: standalone)
        }
        return issues
    }

    /// Bars whose controls get a larger hit area from the system than their drawn frame.
    public static let systemBarKinds: Set<ElementKind> = [.navigationBar, .tabBar, .toolbar]

    private func check(_ element: ElementDescriptor, inSystemBar: Bool) -> [Issue] {
        var issues: [Issue] = []
        let label = element.label.trimmingCharacters(in: .whitespacesAndNewlines)
        if rules.contains(.missingLabel), element.kind.isInteractive, label.isEmpty, (element.placeholder ?? "").isEmpty {
            issues.append(Issue(rule: .missingLabel, element: element, message: "\(element.summary) has no accessibility label"))
        }
        if rules.contains(.imageWithoutLabel), element.kind == .image, label.isEmpty {
            issues.append(Issue(rule: .imageWithoutLabel, element: element,
                                message: "\(element.summary) has no label; describe it or hide it from accessibility"))
        }
        if rules.contains(.smallTouchTarget), element.kind.isInteractive, element.isEnabled, !inSystemBar,
           isTooSmall(element.frame) {
            let size = "\(Self.points(element.frame.width)) × \(Self.points(element.frame.height)) pt"
            let minimum = "\(Self.points(minimumTouchTarget.width)) × \(Self.points(minimumTouchTarget.height)) pt"
            issues.append(Issue(rule: .smallTouchTarget, element: element,
                                message: "\(element.summary) is \(size), smaller than \(minimum)"))
        }
        if rules.contains(.labelRepeatsKind), let word = repeatedKindWord(in: label, kind: element.kind) {
            issues.append(Issue(rule: .labelRepeatsKind, element: element,
                                message: "\(element.summary) ends with \"\(word)\", which VoiceOver already reads"))
        }
        return issues
    }

    private func isTooSmall(_ frame: CGRect) -> Bool {
        let values = [frame.origin.x, frame.origin.y, frame.width, frame.height]
        guard values.allSatisfy(\.isFinite), frame.width > 0, frame.height > 0 else { return false }
        let minimumWidth = minimumTouchTarget.width.isFinite ? max(minimumTouchTarget.width, 0) : 0
        let minimumHeight = minimumTouchTarget.height.isFinite ? max(minimumTouchTarget.height, 0) : 0
        // Compare with a small tolerance so 43.9999 pt from a scaled layout still passes.
        return frame.width + 0.01 < minimumWidth || frame.height + 0.01 < minimumHeight
    }

    private static let kindWords: [ElementKind: [String]] = [
        .button: ["button"],
        .link: ["link"],
        .image: ["image", "picture", "icon"],
        .toggle: ["toggle", "switch"],
        .switch: ["switch", "toggle"],
        .slider: ["slider"],
        .tab: ["tab"]
    ]

    private func repeatedKindWord(in label: String, kind: ElementKind) -> String? {
        guard let words = Self.kindWords[kind], !label.isEmpty else { return nil }
        let lastWord = label.split(whereSeparator: { $0.isWhitespace || $0.isPunctuation }).last.map { $0.lowercased() }
        guard let lastWord, words.contains(lastWord) else { return nil }
        // A label that is only the word ("Button") is a missing label in disguise; still report it.
        return lastWord
    }

    private func duplicateIdentifiers(in elements: [ElementDescriptor]) -> [Issue] {
        var seen: [String: ElementDescriptor] = [:]
        var reported: Set<String> = []
        var issues: [Issue] = []
        for element in elements where !element.identifier.isEmpty {
            guard let first = seen[element.identifier] else {
                seen[element.identifier] = element
                continue
            }
            // SwiftUI often gives a container and its only child the same identifier; only
            // elements of the same kind are real duplicates.
            guard first.kind == element.kind, reported.insert(element.identifier).inserted else { continue }
            issues.append(Issue(rule: .duplicateIdentifier, element: element,
                                message: "identifier \"\(element.identifier)\" is used by more than one \(element.kind)"))
        }
        return issues
    }

    private static func points(_ value: CGFloat) -> String {
        guard value.isFinite else { return "?" }
        let rounded = (value * 10).rounded() / 10
        // Int(_:) traps outside its range, so only whole numbers well inside it take that path.
        if rounded == rounded.rounded(), abs(rounded) < 1e15 {
            return String(Int(rounded))
        }
        return String(format: "%.1f", Double(rounded))
    }
}
