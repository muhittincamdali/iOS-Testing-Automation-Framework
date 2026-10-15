import CoreGraphics
import Foundation
import ImageIO
import UniformTypeIdentifiers

/// An image as 8-bit RGBA pixels in the sRGB color space, the form the image comparison reads.
///
/// Create one from a `CGImage`, from PNG data or from raw pixels. Every initializer checks the
/// size before allocating: images above ``maximumPixelCount`` are rejected, and a PNG's size is
/// read from its header before it is decoded, so a small file that claims a huge size cannot
/// exhaust memory.
public struct Bitmap: Sendable, Hashable {
    /// One pixel. Components are not premultiplied by alpha.
    public struct Pixel: Sendable, Hashable {
        public var red: UInt8
        public var green: UInt8
        public var blue: UInt8
        public var alpha: UInt8

        public init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8 = 255) {
            self.red = red
            self.green = green
            self.blue = blue
            self.alpha = alpha
        }

        public static let clear = Pixel(red: 0, green: 0, blue: 0, alpha: 0)
        public static let white = Pixel(red: 255, green: 255, blue: 255)
        public static let black = Pixel(red: 0, green: 0, blue: 0)
    }

    /// Why a bitmap could not be created.
    public enum Error: Swift.Error, Equatable, CustomStringConvertible {
        case invalidSize(width: Int, height: Int)
        case tooLarge(width: Int, height: Int)
        case pixelCountMismatch(expected: Int, actual: Int)
        case unreadableImage
        case unwritableImage

        public var description: String {
            switch self {
            case .invalidSize(let width, let height): "Invalid image size \(width) × \(height)"
            case .tooLarge(let width, let height):
                "Image size \(width) × \(height) is above the limit of \(Bitmap.maximumPixelCount) pixels"
            case .pixelCountMismatch(let expected, let actual): "Expected \(expected) bytes of RGBA data, got \(actual)"
            case .unreadableImage: "The data is not an image that can be decoded"
            case .unwritableImage: "The image could not be encoded"
            }
        }
    }

    /// The largest image a bitmap holds: 50 million pixels (200 MB of RGBA data), more than an
    /// iPad Pro or a 6K display screenshot.
    public static let maximumPixelCount = 50_000_000

    public let width: Int
    public let height: Int
    /// RGBA bytes, row by row from the top-left corner, without row padding.
    public private(set) var bytes: [UInt8]

    /// Creates a bitmap from RGBA bytes.
    public init(width: Int, height: Int, bytes: [UInt8]) throws {
        let count = try Self.byteCount(width: width, height: height)
        guard bytes.count == count else { throw Error.pixelCountMismatch(expected: count, actual: bytes.count) }
        self.width = width
        self.height = height
        self.bytes = bytes
    }

    /// Creates a bitmap filled with one color.
    public init(width: Int, height: Int, filledWith pixel: Pixel = .clear) throws {
        let count = try Self.byteCount(width: width, height: height)
        var bytes = [UInt8](repeating: 0, count: count)
        for offset in stride(from: 0, to: count, by: 4) {
            bytes[offset] = pixel.red
            bytes[offset + 1] = pixel.green
            bytes[offset + 2] = pixel.blue
            bytes[offset + 3] = pixel.alpha
        }
        self.width = width
        self.height = height
        self.bytes = bytes
    }

    /// Draws `image` into an sRGB RGBA buffer.
    public init(cgImage image: CGImage) throws {
        let width = image.width
        let height = image.height
        let count = try Self.byteCount(width: width, height: height)
        var bytes = [UInt8](repeating: 0, count: count)
        let drawn = bytes.withUnsafeMutableBytes { buffer -> Bool in
            guard let context = Self.context(data: buffer.baseAddress, width: width, height: height) else { return false }
            context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
            return true
        }
        guard drawn else { throw Error.unreadableImage }
        self.width = width
        self.height = height
        self.bytes = Self.unpremultiplied(bytes)
    }

    /// Decodes PNG (or any format ImageIO reads) data.
    public init(data: Data) throws {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil),
              CGImageSourceGetCount(source) > 0,
              let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any],
              let width = (properties[kCGImagePropertyPixelWidth] as? NSNumber)?.intValue,
              let height = (properties[kCGImagePropertyPixelHeight] as? NSNumber)?.intValue
        else { throw Error.unreadableImage }
        // Check the declared size before decoding anything.
        _ = try Self.byteCount(width: width, height: height)
        guard let image = CGImageSourceCreateImageAtIndex(source, 0, nil) else { throw Error.unreadableImage }
        try self.init(cgImage: image)
    }

    /// Reads an image file.
    public init(contentsOf url: URL) throws {
        try self.init(data: Data(contentsOf: url))
    }

    // MARK: - Pixels

    /// The pixel at `x`, `y` (top-left origin), or `nil` outside the image.
    public subscript(x x: Int, y y: Int) -> Pixel? {
        guard let offset = offset(x: x, y: y) else { return nil }
        return Pixel(red: bytes[offset], green: bytes[offset + 1], blue: bytes[offset + 2], alpha: bytes[offset + 3])
    }

    /// Sets the pixel at `x`, `y`; positions outside the image are ignored.
    public mutating func setPixel(_ pixel: Pixel, x: Int, y: Int) {
        guard let offset = offset(x: x, y: y) else { return }
        bytes[offset] = pixel.red
        bytes[offset + 1] = pixel.green
        bytes[offset + 2] = pixel.blue
        bytes[offset + 3] = pixel.alpha
    }

    /// Fills the part of `rect` that lies inside the image.
    public mutating func fill(_ rect: PixelRect, with pixel: Pixel) {
        guard let clipped = rect.clipped(toWidth: width, height: height) else { return }
        for y in clipped.y..<(clipped.y + clipped.height) {
            for x in clipped.x..<(clipped.x + clipped.width) {
                setPixel(pixel, x: x, y: y)
            }
        }
    }

    private func offset(x: Int, y: Int) -> Int? {
        guard x >= 0, y >= 0, x < width, y < height else { return nil }
        return (y * width + x) * 4
    }

    // MARK: - Export

    /// The bitmap as a `CGImage`.
    public func cgImage() -> CGImage? {
        var premultiplied = Self.premultiplied(bytes)
        return premultiplied.withUnsafeMutableBytes { buffer in
            Self.context(data: buffer.baseAddress, width: width, height: height)?.makeImage()
        }
    }

    /// The bitmap as PNG data.
    public func pngData() throws -> Data {
        guard let image = cgImage() else { throw Error.unwritableImage }
        let data = NSMutableData()
        guard let destination = CGImageDestinationCreateWithData(data as CFMutableData, UTType.png.identifier as CFString, 1, nil)
        else { throw Error.unwritableImage }
        CGImageDestinationAddImage(destination, image, nil)
        guard CGImageDestinationFinalize(destination) else { throw Error.unwritableImage }
        return data as Data
    }

    /// Writes the bitmap as a PNG file, creating the folder if needed.
    public func writePNG(to url: URL) throws {
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        try pngData().write(to: url, options: .atomic)
    }

    // MARK: - Helpers

    static func byteCount(width: Int, height: Int) throws -> Int {
        guard width > 0, height > 0 else { throw Error.invalidSize(width: width, height: height) }
        let (pixels, overflow) = width.multipliedReportingOverflow(by: height)
        guard !overflow, pixels <= maximumPixelCount else { throw Error.tooLarge(width: width, height: height) }
        return pixels * 4
    }

    private static func context(data: UnsafeMutableRawPointer?, width: Int, height: Int) -> CGContext? {
        guard let space = CGColorSpace(name: CGColorSpace.sRGB) else { return nil }
        return CGContext(
            data: data,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: space,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        )
    }

    private static func unpremultiplied(_ bytes: [UInt8]) -> [UInt8] {
        var result = bytes
        for offset in stride(from: 0, to: result.count, by: 4) {
            let alpha = Int(result[offset + 3])
            guard alpha > 0, alpha < 255 else { continue }
            for channel in 0..<3 {
                result[offset + channel] = UInt8(min(255, (Int(result[offset + channel]) * 255 + alpha / 2) / alpha))
            }
        }
        return result
    }

    private static func premultiplied(_ bytes: [UInt8]) -> [UInt8] {
        var result = bytes
        for offset in stride(from: 0, to: result.count, by: 4) {
            let alpha = Int(result[offset + 3])
            guard alpha < 255 else { continue }
            for channel in 0..<3 {
                result[offset + channel] = UInt8((Int(result[offset + channel]) * alpha + 127) / 255)
            }
        }
        return result
    }
}

/// A rectangle in whole pixels with a top-left origin.
public struct PixelRect: Sendable, Hashable, Codable {
    public var x: Int
    public var y: Int
    public var width: Int
    public var height: Int

    public init(x: Int, y: Int, width: Int, height: Int) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }

    /// Converts a rectangle in points to the pixels that cover it at `scale`.
    ///
    /// Returns `nil` when a value is NaN or infinite, the scale is not positive, or the result
    /// does not fit in `Int`; converting such values with `Int(_:)` would stop the process.
    public init?(_ rect: CGRect, scale: CGFloat = 1) {
        let values = [rect.minX, rect.minY, rect.maxX, rect.maxY, scale]
        guard values.allSatisfy(\.isFinite), scale > 0 else { return nil }
        let limit = CGFloat(Int32.max)
        let minX = (rect.minX * scale).rounded(.down)
        let minY = (rect.minY * scale).rounded(.down)
        let maxX = (rect.maxX * scale).rounded(.up)
        let maxY = (rect.maxY * scale).rounded(.up)
        guard [minX, minY, maxX, maxY].allSatisfy({ abs($0) <= limit }) else { return nil }
        self.init(x: Int(minX), y: Int(minY), width: Int(maxX - minX), height: Int(maxY - minY))
    }

    /// The part of the rectangle inside an image of the given size, or `nil` if none is.
    public func clipped(toWidth imageWidth: Int, height imageHeight: Int) -> PixelRect? {
        guard width > 0, height > 0 else { return nil }
        // Saturating arithmetic: x + width may not fit in Int for extreme inputs.
        let right = x.addingReportingOverflow(width)
        let bottom = y.addingReportingOverflow(height)
        let maxX = min(right.overflow ? Int.max : right.partialValue, imageWidth)
        let maxY = min(bottom.overflow ? Int.max : bottom.partialValue, imageHeight)
        let minX = max(x, 0)
        let minY = max(y, 0)
        guard maxX > minX, maxY > minY else { return nil }
        return PixelRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }

    /// Whether the pixel at `px`, `py` lies inside the rectangle.
    public func contains(x px: Int, y py: Int) -> Bool {
        guard width > 0, height > 0, px >= x, py >= y else { return false }
        // px - x can exceed Int.max when x is very negative; such a distance is never inside.
        let dx = px.subtractingReportingOverflow(x)
        let dy = py.subtractingReportingOverflow(y)
        return !dx.overflow && !dy.overflow && dx.partialValue < width && dy.partialValue < height
    }
}
