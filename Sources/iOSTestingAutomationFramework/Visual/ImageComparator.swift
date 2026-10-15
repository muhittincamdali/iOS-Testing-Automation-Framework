/// Compares two bitmaps pixel by pixel and draws an image of the differences.
///
/// Two settings decide what counts as "the same":
///
/// - ``pixelTolerance``: how far a color channel may move before a pixel counts as changed,
///   from 0 (exact) to 1. A small value such as `0.02` absorbs anti-aliasing and color
///   management differences between machines.
/// - ``maximumDifferentPixelFraction``: what share of pixels may change before the images count
///   as different, from 0 (none) to 1.
///
/// Out-of-range values are clamped to 0...1 and NaN becomes 0, the strictest setting.
///
/// ```swift
/// let comparison = ImageComparator(pixelTolerance: 0.02).compare(baseline, actual)
/// if !comparison.matches {
///     try comparison.differenceImage?.writePNG(to: diffURL)
/// }
/// ```
public struct ImageComparator: Sendable, Hashable {
    public let pixelTolerance: Double
    public let maximumDifferentPixelFraction: Double
    /// Regions to skip, in pixels, such as a clock or an animated banner.
    public var ignoredRegions: [PixelRect]
    /// The color that marks changed pixels in the difference image.
    public var highlight: Bitmap.Pixel

    public init(
        pixelTolerance: Double = 0,
        maximumDifferentPixelFraction: Double = 0,
        ignoredRegions: [PixelRect] = [],
        highlight: Bitmap.Pixel = Bitmap.Pixel(red: 0, green: 113, blue: 227)
    ) {
        self.pixelTolerance = Self.unit(pixelTolerance)
        self.maximumDifferentPixelFraction = Self.unit(maximumDifferentPixelFraction)
        self.ignoredRegions = ignoredRegions
        self.highlight = highlight
    }

    /// Compares `actual` with `baseline`.
    ///
    /// Images of different sizes never match; the comparison then reports the sizes and has no
    /// difference image.
    public func compare(_ baseline: Bitmap, _ actual: Bitmap) -> ImageComparison {
        guard baseline.width == actual.width, baseline.height == actual.height else {
            return ImageComparison(
                outcome: .sizeMismatch,
                baselineSize: (baseline.width, baseline.height),
                actualSize: (actual.width, actual.height),
                differentPixelCount: 0,
                comparedPixelCount: 0,
                maximumChannelDifference: 0,
                differenceBounds: nil,
                differenceImage: nil
            )
        }
        let width = baseline.width
        let height = baseline.height
        let threshold = Int((pixelTolerance * 255).rounded())
        var skipped: [Bool] = []
        for region in ignoredRegions.compactMap({ $0.clipped(toWidth: width, height: height) }) {
            if skipped.isEmpty { skipped = [Bool](repeating: false, count: width * height) }
            for y in region.y..<(region.y + region.height) {
                for x in region.x..<(region.x + region.width) { skipped[y * width + x] = true }
            }
        }

        var mask = [Bool](repeating: false, count: width * height)
        var different = 0
        var compared = 0
        var maximumDifference = 0
        var bounds: (minX: Int, minY: Int, maxX: Int, maxY: Int)?

        baseline.bytes.withUnsafeBufferPointer { lhs in
            actual.bytes.withUnsafeBufferPointer { rhs in
                for y in 0..<height {
                    for x in 0..<width {
                        if !skipped.isEmpty, skipped[y * width + x] { continue }
                        compared += 1
                        let offset = (y * width + x) * 4
                        var pixelDifference = 0
                        for channel in 0..<4 {
                            pixelDifference = max(pixelDifference, abs(Int(lhs[offset + channel]) - Int(rhs[offset + channel])))
                        }
                        maximumDifference = max(maximumDifference, pixelDifference)
                        guard pixelDifference > threshold else { continue }
                        different += 1
                        mask[y * width + x] = true
                        if let current = bounds {
                            bounds = (min(current.minX, x), min(current.minY, y), max(current.maxX, x), max(current.maxY, y))
                        } else {
                            bounds = (x, y, x, y)
                        }
                    }
                }
            }
        }

        let fraction = compared == 0 ? 0 : Double(different) / Double(compared)
        let matches = different == 0 || fraction <= maximumDifferentPixelFraction
        return ImageComparison(
            outcome: matches ? .match : .different,
            baselineSize: (width, height),
            actualSize: (width, height),
            differentPixelCount: different,
            comparedPixelCount: compared,
            maximumChannelDifference: maximumDifference,
            differenceBounds: bounds.map { PixelRect(x: $0.minX, y: $0.minY, width: $0.maxX - $0.minX + 1, height: $0.maxY - $0.minY + 1) },
            differenceImage: different == 0 ? nil : differenceImage(of: actual, mask: mask)
        )
    }

    /// The actual image faded to light gray, with changed pixels in ``highlight``.
    private func differenceImage(of actual: Bitmap, mask: [Bool]) -> Bitmap? {
        var bytes = actual.bytes
        for index in mask.indices {
            let offset = index * 4
            if mask[index] {
                bytes[offset] = highlight.red
                bytes[offset + 1] = highlight.green
                bytes[offset + 2] = highlight.blue
                bytes[offset + 3] = 255
            } else {
                let gray = (Int(bytes[offset]) * 30 + Int(bytes[offset + 1]) * 59 + Int(bytes[offset + 2]) * 11) / 100
                // Blend 75 % toward white so the highlighted pixels stand out.
                let faded = UInt8((gray + 3 * 255) / 4)
                bytes[offset] = faded
                bytes[offset + 1] = faded
                bytes[offset + 2] = faded
                bytes[offset + 3] = 255
            }
        }
        return try? Bitmap(width: actual.width, height: actual.height, bytes: bytes)
    }

    private static func unit(_ value: Double) -> Double {
        value.isNaN ? 0 : min(max(value, 0), 1)
    }
}

/// The result of ``ImageComparator/compare(_:_:)``.
public struct ImageComparison: Sendable {
    public enum Outcome: String, Sendable {
        case match
        case different
        case sizeMismatch
    }

    public let outcome: Outcome
    public let baselineSize: (width: Int, height: Int)
    public let actualSize: (width: Int, height: Int)
    /// Pixels whose largest channel change is above the tolerance.
    public let differentPixelCount: Int
    /// Pixels compared, which excludes ignored regions.
    public let comparedPixelCount: Int
    /// The largest change of any channel, from 0 to 255.
    public let maximumChannelDifference: Int
    /// The smallest rectangle that holds every changed pixel.
    public let differenceBounds: PixelRect?
    /// The actual image faded, with changed pixels highlighted; `nil` when nothing changed or
    /// the sizes differ.
    public let differenceImage: Bitmap?

    /// True when the images count as the same under the comparator's settings.
    public var matches: Bool { outcome == .match }

    /// Changed pixels divided by compared pixels.
    public var differentPixelFraction: Double {
        comparedPixelCount == 0 ? 0 : Double(differentPixelCount) / Double(comparedPixelCount)
    }

    /// A one-line explanation for test failure messages.
    public var summary: String {
        switch outcome {
        case .match:
            return "Images match"
        case .sizeMismatch:
            return "Image size changed from \(baselineSize.width) × \(baselineSize.height) to \(actualSize.width) × \(actualSize.height)"
        case .different:
            let percent = String(format: "%.2f", differentPixelFraction * 100)
            var text = "\(differentPixelCount) of \(comparedPixelCount) pixels differ (\(percent) %), largest channel change \(maximumChannelDifference)"
            if let bounds = differenceBounds {
                text += ", within x \(bounds.x)–\(bounds.x + bounds.width - 1), y \(bounds.y)–\(bounds.y + bounds.height - 1)"
            }
            return text
        }
    }
}
