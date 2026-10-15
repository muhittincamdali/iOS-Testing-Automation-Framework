import CoreGraphics
import Foundation
import SwiftUI
import Testing
@testable import iOSTestingAutomationFramework

struct Swatch: View {
    var color: Color
    var body: some View { color }
}

@Suite("ViewRenderer")
@MainActor
struct ViewRendererTests {
    @Test("renders a view at the requested size and scale")
    func renders() throws {
        let image = try ViewRenderer.render(Swatch(color: .black), size: CGSize(width: 20, height: 10), scale: 2)
        #expect(image.width == 40)
        #expect(image.height == 20)
        #expect(image[x: 20, y: 10] == .black)
    }

    @Test("rejects sizes and scales that are not usable")
    func invalidInput() {
        let view = Swatch(color: .red)
        #expect(throws: ViewRenderer.Error.self) { try ViewRenderer.render(view, size: CGSize(width: 0, height: 10)) }
        #expect(throws: ViewRenderer.Error.self) { try ViewRenderer.render(view, size: CGSize(width: CGFloat.nan, height: 10)) }
        #expect(throws: ViewRenderer.Error.self) { try ViewRenderer.render(view, size: CGSize(width: 10, height: 10), scale: .infinity) }
        #expect(throws: ViewRenderer.Error.self) { try ViewRenderer.render(view, size: CGSize(width: 10, height: 10), scale: 0) }
        #expect(throws: Bitmap.Error.self) { try ViewRenderer.render(view, size: CGSize(width: 1e12, height: 1e12)) }
    }
}
