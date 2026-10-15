import Foundation

/// Masks passwords, tokens and other secrets before text reaches a report, a log or an
/// XCTest activity name.
///
/// A redactor masks two kinds of text:
///
/// - **Secrets you register**, such as the test account's password. Each secret is also masked
///   where it was percent-encoded (by `URLComponents`, `addingPercentEncoding` with any URL
///   character set, or form encoding with `+` for a space; hex in either case) or JSON-escaped
///   (including `\u00f6` escapes), so it does not leak through a logged URL or request body.
///   Matches are found in the original text and overlapping matches are merged before
///   anything is replaced, so two secrets that share characters leave no part of either
///   visible. Unicode text matches in composed and decomposed form.
/// - **Common credential patterns** (unless turned off): the value after `password=`,
///   `token:`, `api_key=`, `secret=` and similar keys, and the token after `Bearer`. A quoted
///   value is masked up to its closing quote, spaces included.
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
    // One matcher per secret in `secrets`; equal secrets have equal matchers.
    private var matchers: [SecretMatcher] = []

    /// Creates a redactor.
    public init(secrets: [String] = [], mask: String = "••••", masksCommonPatterns: Bool = true) {
        self.mask = mask
        self.secrets = []
        self.masksCommonPatterns = masksCommonPatterns
        for secret in secrets { register(secret) }
    }

    /// Adds a secret. Empty and whitespace-only strings are ignored.
    public mutating func register(_ secret: String) {
        guard !secret.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !secrets.contains(secret),
              let matcher = SecretMatcher(secret) else { return }
        secrets.append(secret)
        matchers.append(matcher)
    }

    /// Returns `text` with every registered secret and, if enabled, every credential value masked.
    public func redact(_ text: String) -> String {
        guard !text.isEmpty else { return text }
        var ranges = matchers.flatMap { $0.ranges(in: text) }
        if masksCommonPatterns {
            ranges += Self.patternRanges(in: text)
        }
        guard !ranges.isEmpty else { return text }
        return Self.replace(Self.merged(ranges), in: text, with: mask)
    }

    // MARK: - Matching

    // `key = value`, `key: value`, `"key": "value"` and `Bearer <token>`. The key list is
    // anchored on word boundaries. A quoted value (`"…"`, `'…'`, or `\"…\"` inside a JSON
    // string) runs to its closing quote, or to the end of the line when the quote is not
    // closed; an unquoted one stops at whitespace, quotes and separators. A value that starts with `Bearer ` or `Basic ` is left to the second
    // pattern, which masks the token after the scheme.
    private static let credentialPattern = try? NSRegularExpression(
        pattern: #"(?i)\b(?:password|passwd|pwd|passcode|secret|client_secret|token|access_token|refresh_token|id_token|api[_-]?key|apikey|auth|authorization|session|cookie)\b\\?["']?\s*[:=]\s*(?:"(?!(?:bearer|basic)\s)((?:[^"\\\r\n]|\\.)+)"?|'(?!(?:bearer|basic)\s)((?:[^'\\\r\n]|\\.)+)'?|\\"(?!(?:bearer|basic)\s)((?:(?!\\")[^\r\n])+)\\"|\\?["']?(?!(?:bearer|basic)\s)([^\s"'&,;}]+))"#
    )
    private static let bearerPattern = try? NSRegularExpression(
        pattern: #"(?i)\b(?:bearer|basic)\s+([A-Za-z0-9._~+/-]+=*)"#
    )

    private static func patternRanges(in text: String) -> [Range<String.Index>] {
        let whole = NSRange(text.startIndex..<text.endIndex, in: text)
        var found: [Range<String.Index>] = []
        for pattern in [credentialPattern, bearerPattern].compactMap({ $0 }) {
            for match in pattern.matches(in: text, range: whole) {
                // The value is in whichever capture group matched.
                let value = (1..<match.numberOfRanges).lazy
                    .map { match.range(at: $0) }
                    .first { $0.location != NSNotFound }
                if let value, let range = Range(value, in: text), !range.isEmpty {
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
