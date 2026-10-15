import Foundation

/// WCAG 2 contrast ratios between two colors, for checking text and icon colors in tests.
///
/// ```swift
/// let ratio = ContrastRatio(foreground: "#767676", background: "#FFFFFF")
/// ratio?.value          // 4.54
/// ratio?.passesAA()     // true
/// ```
public struct ContrastRatio: Sendable, Hashable, Comparable, CustomStringConvertible {
    /// The ratio, from 1 (no contrast) to 21 (black on white).
    public let value: Double

    /// An sRGB color with components from 0 to 1.
    public struct Color: Sendable, Hashable {
        public let red: Double
        public let green: Double
        public let blue: Double

        /// Components are clamped to 0...1; NaN becomes 0.
        public init(red: Double, green: Double, blue: Double) {
            self.red = Self.clamped(red)
            self.green = Self.clamped(green)
            self.blue = Self.clamped(blue)
        }

        /// Parses `#RGB`, `#RRGGBB` or `#RRGGBBAA` (the alpha is ignored), with or without `#`.
        /// Returns `nil` for anything else.
        public init?(hex: String) {
            var digits = hex.trimmingCharacters(in: .whitespaces)
            if digits.hasPrefix("#") { digits.removeFirst() }
            guard digits.allSatisfy(\.isHexDigit), digits.allSatisfy(\.isASCII) else { return nil }
            if digits.count == 3 {
                digits = digits.map { "\($0)\($0)" }.joined()
            }
            guard digits.count == 6 || digits.count == 8, let number = UInt32(digits.prefix(6), radix: 16) else { return nil }
            self.init(
                red: Double((number >> 16) & 0xFF) / 255,
                green: Double((number >> 8) & 0xFF) / 255,
                blue: Double(number & 0xFF) / 255
            )
        }

        /// The relative luminance defined by WCAG 2.
        public var relativeLuminance: Double {
            0.2126 * Self.linear(red) + 0.7152 * Self.linear(green) + 0.0722 * Self.linear(blue)
        }

        private static func linear(_ component: Double) -> Double {
            component <= 0.04045 ? component / 12.92 : pow((component + 0.055) / 1.055, 2.4)
        }

        private static func clamped(_ value: Double) -> Double {
            value.isNaN ? 0 : min(max(value, 0), 1)
        }
    }

    public init(foreground: Color, background: Color) {
        let lighter = max(foreground.relativeLuminance, background.relativeLuminance)
        let darker = min(foreground.relativeLuminance, background.relativeLuminance)
        value = (lighter + 0.05) / (darker + 0.05)
    }

    /// Returns `nil` if either hex string cannot be parsed.
    public init?(foreground: String, background: String) {
        guard let foreground = Color(hex: foreground), let background = Color(hex: background) else { return nil }
        self.init(foreground: foreground, background: background)
    }

    /// WCAG level AA: 4.5:1 for normal text, 3:1 for large text (18 pt, or 14 pt bold) and icons.
    public func passesAA(largeText: Bool = false) -> Bool { value >= (largeText ? 3 : 4.5) }

    /// WCAG level AAA: 7:1 for normal text, 4.5:1 for large text.
    public func passesAAA(largeText: Bool = false) -> Bool { value >= (largeText ? 4.5 : 7) }

    public var description: String { String(format: "%.2f:1", value) }

    public static func < (lhs: Self, rhs: Self) -> Bool { lhs.value < rhs.value }
}
