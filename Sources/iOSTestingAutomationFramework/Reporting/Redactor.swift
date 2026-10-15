import Foundation

/// Masks passwords, tokens and other secrets before text reaches a report, a log or an
/// XCTest activity name.
///
/// A redactor masks two kinds of text:
///
/// - **Secrets you register**, such as the test account's password. Each secret is also masked
///   in its percent-encoded and JSON-escaped forms, so it does not leak through a logged URL or
///   request body. Matches are found in the original text and overlapping matches are merged
///   before anything is replaced, so two secrets that share characters leave no part of either
///   visible. Unicode text matches in composed and decomposed form.
/// - **Common credential patterns** (unless turned off): the value after `password=`,
///   `token:`, `api_key=`, `secret=` and similar keys, and the token after `Bearer`.
///
/// Empty and whitespace-only secrets are ignored, because masking them would mask every gap
/// between words.
///
/// ```swift
/// let redactor = Redactor(secrets: ["hunter2"])
/// redactor.redact("login failed for password hunter2")
/// // "login failed for password ••••"
/// ```
public struct Redactor: Sendable, Hashable {
    /// The text that replaces each secret. The default is `••••`.
    public var mask: String
    /// The registered secrets.
    public private(set) var secrets: [String]
    /// Whether values after common credential keys and `Bearer` are masked too.
    public var masksCommonPatterns: Bool

    /// Creates a redactor.
    public init(secrets: [String] = [], mask: String = "••••", masksCommonPatterns: Bool = true) {
        self.mask = mask
        self.secrets = []
        self.masksCommonPatterns = masksCommonPatterns
        for secret in secrets { register(secret) }
    }

    /// Adds a secret. Empty and whitespace-only strings are ignored.
    public mutating func register(_ secret: String) {
        guard !secret.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        for variant in Self.variants(of: secret) where !secrets.contains(variant) {
            secrets.append(variant)
        }
    }

    /// Returns `text` with every registered secret and, if enabled, every credential value masked.
    public func redact(_ text: String) -> String {
        guard !text.isEmpty else { return text }
        var ranges = secrets.flatMap { Self.ranges(of: $0, in: text) }
        if masksCommonPatterns {
            ranges += Self.patternRanges(in: text)
        }
        guard !ranges.isEmpty else { return text }
        return Self.replace(Self.merged(ranges), in: text, with: mask)
    }

    // MARK: - Matching

    private static func variants(of secret: String) -> [String] {
        var result = [secret]
        if let encoded = secret.addingPercentEncoding(withAllowedCharacters: .alphanumerics), encoded != secret {
            result.append(encoded)
        }
        let jsonEscaped = jsonEscape(secret)
        if jsonEscaped != secret { result.append(jsonEscaped) }
        return result
    }

    private static func jsonEscape(_ text: String) -> String {
        var escaped = ""
        for scalar in text.unicodeScalars {
            switch scalar {
            case "\"": escaped += "\\\""
            case "\\": escaped += "\\\\"
            case "/": escaped += "\\/"
            case "\n": escaped += "\\n"
            case "\r": escaped += "\\r"
            case "\t": escaped += "\\t"
            default: escaped.unicodeScalars.append(scalar)
            }
        }
        return escaped
    }

    /// Every occurrence of `needle`, including overlapping ones.
    private static func ranges(of needle: String, in text: String) -> [Range<String.Index>] {
        var found: [Range<String.Index>] = []
        var searchStart = text.startIndex
        while searchStart < text.endIndex,
              let match = text.range(of: needle, range: searchStart..<text.endIndex) {
            found.append(match)
            // Continue one character after the start of the match to find overlapping copies.
            searchStart = text.index(after: match.lowerBound)
        }
        return found
    }

    // `key = value`, `key: value`, `"key": "value"` and `Bearer <token>`. The key list is
    // anchored on word boundaries; the value stops at whitespace, quotes and separators. A
    // value that starts with `Bearer ` or `Basic ` is left to the second pattern, which masks
    // the token after the scheme.
    private static let credentialPattern = try? NSRegularExpression(
        pattern: #"(?i)\b(?:password|passwd|pwd|passcode|secret|client_secret|token|access_token|refresh_token|id_token|api[_-]?key|apikey|auth|authorization|session|cookie)\b"?\s*[:=]\s*"?(?!(?:bearer|basic)\s)([^\s"'&,;}]+)"#
    )
    private static let bearerPattern = try? NSRegularExpression(
        pattern: #"(?i)\b(?:bearer|basic)\s+([A-Za-z0-9._~+/-]+=*)"#
    )

    private static func patternRanges(in text: String) -> [Range<String.Index>] {
        let whole = NSRange(text.startIndex..<text.endIndex, in: text)
        var found: [Range<String.Index>] = []
        for pattern in [credentialPattern, bearerPattern].compactMap({ $0 }) {
            for match in pattern.matches(in: text, range: whole) {
                if let range = Range(match.range(at: 1), in: text), !range.isEmpty {
                    found.append(range)
                }
            }
        }
        return found
    }

    private static func merged(_ ranges: [Range<String.Index>]) -> [Range<String.Index>] {
        let sorted = ranges.sorted { $0.lowerBound < $1.lowerBound }
        var result: [Range<String.Index>] = []
        for range in sorted {
            if let last = result.last, range.lowerBound <= last.upperBound {
                result[result.count - 1] = last.lowerBound..<max(last.upperBound, range.upperBound)
            } else {
                result.append(range)
            }
        }
        return result
    }

    private static func replace(_ ranges: [Range<String.Index>], in text: String, with mask: String) -> String {
        var output = ""
        var position = text.startIndex
        for range in ranges {
            output += text[position..<range.lowerBound]
            output += mask
            position = range.upperBound
        }
        output += text[position...]
        return output
    }
}
