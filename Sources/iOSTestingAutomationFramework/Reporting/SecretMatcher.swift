import Foundation

/// Finds one secret in text, in every form an encoder may have written it.
///
/// The pattern is built one Unicode scalar at a time, and each scalar may appear as itself,
/// percent-encoded (upper- or lowercase hex) or JSON-escaped. Encoders differ in which
/// characters they leave alone (`URLComponents`, `.urlQueryAllowed`, `.urlPathAllowed` and
/// form encoding each keep a different set), so matching per scalar covers all of them,
/// including text where only some characters were encoded. A space may also be a `+`, as in
/// form encoding. Each character matches in composed and decomposed form.
struct SecretMatcher: Sendable, Hashable {
    let pattern: String
    private let expression: NSRegularExpression

    init?(_ secret: String) {
        let pattern = secret.precomposedStringWithCanonicalMapping.map(Self.alternatives(for:)).joined()
        guard let expression = try? NSRegularExpression(pattern: pattern) else { return nil }
        self.pattern = pattern
        self.expression = expression
    }

    static func == (lhs: SecretMatcher, rhs: SecretMatcher) -> Bool {
        lhs.pattern == rhs.pattern
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(pattern)
    }

    /// Every occurrence in `text`, including overlapping ones.
    func ranges(in text: String) -> [Range<String.Index>] {
        let utf16Count = (text as NSString).length
        var found: [Range<String.Index>] = []
        var start = 0
        while start < utf16Count,
              let match = expression.firstMatch(in: text, range: NSRange(location: start, length: utf16Count - start)) {
            if let range = Range(match.range, in: text), !range.isEmpty {
                found.append(range)
            }
            // Continue one unit after the start of the match to find overlapping copies.
            start = match.range.location + 1
        }
        return found
    }

    // MARK: - Pattern

    /// The forms of one character: its composed and its decomposed scalars, each scalar in
    /// any of its encodings.
    private static func alternatives(for character: Character) -> String {
        let composed = String(character)
        let decomposed = composed.decomposedStringWithCanonicalMapping
        var sequences = [composed.unicodeScalars.map(scalarPattern).joined()]
        // Compare scalars: `String` equality already treats the two forms as equal.
        if !decomposed.unicodeScalars.elementsEqual(composed.unicodeScalars) {
            sequences.append(decomposed.unicodeScalars.map(scalarPattern).joined())
        }
        return sequences.count == 1 ? sequences[0] : "(?:" + sequences.joined(separator: "|") + ")"
    }

    private static func scalarPattern(_ scalar: Unicode.Scalar) -> String {
        let text = String(scalar)
        var forms = [NSRegularExpression.escapedPattern(for: text)]
        forms.append("(?i:" + text.utf8.map { "%" + hex($0, digits: 2) }.joined() + ")")
        if let shortEscape = jsonShortEscapes[scalar] {
            forms.append(NSRegularExpression.escapedPattern(for: shortEscape))
        }
        // `ö`, as ASCII-only JSON encoders write it (a surrogate pair above U+FFFF).
        forms.append("(?i:" + text.utf16.map { #"\\u"# + hex($0, digits: 4) }.joined() + ")")
        if scalar == " " { forms.append(#"\+"#) }
        return "(?:" + forms.joined(separator: "|") + ")"
    }

    private static let jsonShortEscapes: [Unicode.Scalar: String] = [
        "\"": #"\""#, "\\": #"\\"#, "/": #"\/"#, "\n": #"\n"#, "\r": #"\r"#, "\t": #"\t"#,
        "\u{8}": #"\b"#, "\u{C}": #"\f"#
    ]

    private static func hex(_ value: some BinaryInteger, digits: Int) -> String {
        let text = String(value, radix: 16, uppercase: true)
        return String(repeating: "0", count: max(0, digits - text.count)) + text
    }
}
