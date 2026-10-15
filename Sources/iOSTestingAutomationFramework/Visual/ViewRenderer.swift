import SwiftUI

/// Renders SwiftUI views to bitmaps, for snapshot tests that run without a simulator screen.
///
/// Rendering uses `ImageRenderer`, so it works in unit tests on macOS and on an iOS simulator.
/// Views that need a window (sheets, `UIViewRepresentable` content, some `List` styles) do not
/// render this way; test those with a screenshot in a UI test instead.
///
/// ```swift
/// let image = try ViewRenderer.render(Badge(count: 3), size: CGSize(width: 120, height: 44))
/// ```
@MainActor
public enum ViewRenderer {
    /// Why a view could not be rendered.
    public enum Error: Swift.Error, Equatable, CustomStringConvertible {
        case invalidSize(CGSize)
        case invalidScale(CGFloat)
        case renderingFailed

        public var description: String {
            switch self {
            case .invalidSize(let size): "Cannot render at \(size.width) × \(size.height) points"
            case .invalidScale(let scale): "Cannot render at scale \(scale)"
            case .renderingFailed: "ImageRenderer produced no image"
            }
        }
    }

    /// Renders `view` at a fixed size.
    ///
    /// - Parameters:
    ///   - view: The view to draw.
    ///   - size: The size in points. Both sides must be positive and finite, and the rendered
    ///     image must stay within ``Bitmap/maximumPixelCount``.
    ///   - scale: Pixels per point, from 1 to 4. The default, 2, matches most iPhone screens
    ///     closely enough for snapshots while keeping files small.
    ///   - colorScheme: Light or dark appearance.
    ///   - background: Drawn behind the view. `ImageRenderer` leaves the background
    ///     transparent, which hides dark-mode text on a light image viewer, so pass a color
    ///     when you render dark mode.
    public static func render<Content: View>(
        _ view: Content,
        size: CGSize,
        scale: CGFloat = 2,
        colorScheme: ColorScheme = .light,
        background: Color = .clear
    ) throws -> Bitmap {
        guard size.width.isFinite, size.height.isFinite, size.width > 0, size.height > 0 else {
            throw Error.invalidSize(size)
        }
        guard scale.isFinite, scale >= 1, scale <= 4 else { throw Error.invalidScale(scale) }
        let pixels = Double(size.width * scale) * Double(size.height * scale)
        guard pixels <= Double(Bitmap.maximumPixelCount) else {
            throw Bitmap.Error.tooLarge(width: Int(min(size.width * scale, 1e9)), height: Int(min(size.height * scale, 1e9)))
        }

        let content = view
            .frame(width: size.width, height: size.height)
            .background(background)
            .environment(\.colorScheme, colorScheme)
        let renderer = ImageRenderer(content: content)
        renderer.scale = scale
        renderer.proposedSize = ProposedViewSize(size)
        guard let image = renderer.cgImage else { throw Error.renderingFailed }
        return try Bitmap(cgImage: image)
    }
}
