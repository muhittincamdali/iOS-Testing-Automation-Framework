import XCTest
import iOSTestingAutomationFramework

final class VisualRegressionTests: ShowcaseTestCase {
    /// Set (through TEST_RUNNER_SCREENSHOT_DIR) by scripts/generate-screenshots.sh to save the
    /// README images.
    private var screenshotDirectory: URL? {
        ProcessInfo.processInfo.environment["SCREENSHOT_DIR"].map { URL(fileURLWithPath: $0, isDirectory: true) }
    }

    @MainActor
    func testScreenshotComparisonCatchesAHiddenPriceColumn() throws {
        for scheme in ["light", "dark"] {
            try XCTContext.runActivity(named: "\(scheme) appearance") { _ in
                try compareCatalog(colorScheme: scheme)
            }
        }
    }

    @MainActor
    private func compareCatalog(colorScheme: String) throws {
        app.terminate()
        app.launchArguments = ["-frozenClock", "-colorScheme", colorScheme]
        app.launch()
        let catalog = signIn()
        catalog.assertExists(catalog.product("filters"))

        let directory = FileManager.default.temporaryDirectory.appendingPathComponent("showcase-baselines-\(UUID().uuidString)")
        defer { try? FileManager.default.removeItem(at: directory) }
        let store = SnapshotStore(directory: directory, recordMode: .missing, environment: [:])

        // The status bar clock changes between screenshots and the "Updated" time is dynamic in
        // real use, so both are left out of the comparison.
        let (baseline, ignored) = try catalog.screenshot(of: app, ignoring: [catalog.lastUpdated])
        let statusBar = statusBarRegion(imageWidth: baseline.width)
        let comparator = ImageComparator(pixelTolerance: 0.02, ignoredRegions: ignored + [statusBar])

        guard case .recorded = try store.verify(baseline, named: "catalog", comparator: comparator) else {
            return XCTFail("The first screenshot should be recorded as the baseline")
        }
        // Unchanged screen: the assertion passes.
        catalog.assertScreenshot(named: "catalog", ignoring: [catalog.lastUpdated], comparator: comparator, store: store)

        // Hide the prices: the comparison must fail, and only in the price column.
        catalog.togglePrices()
        let (changed, _) = try catalog.screenshot(of: app)
        let verification = try store.verify(changed, named: "catalog", comparator: comparator)
        guard case .mismatch(let comparison, _, _, _) = verification else {
            return XCTFail("Hiding the prices should change the screenshot")
        }
        let bounds = try XCTUnwrap(comparison.differenceBounds)
        XCTAssertGreaterThan(comparison.differentPixelCount, 500)
        XCTAssertGreaterThan(bounds.x, baseline.width / 2, "Only the right-hand price column should change")

        if let output = screenshotDirectory {
            // The catalog ends well above the bottom of the screen; keep the top 1.6 widths.
            let height = baseline.width * 16 / 10
            try top(of: baseline, height: height).writePNG(to: output.appendingPathComponent("catalog-\(colorScheme).png"))
            let difference = try XCTUnwrap(comparison.differenceImage)
            let images = try [baseline, changed, difference].map { try top(of: $0, height: height) }
            try sideBySide(images, gap: 48, colorScheme: colorScheme)
                .writePNG(to: output.appendingPathComponent("visual-diff-\(colorScheme).png"))
        }
    }

    /// The band above the navigation bar, in pixels.
    @MainActor
    private func statusBarRegion(imageWidth: Int) -> PixelRect {
        let scale = CGFloat(imageWidth) / app.frame.width
        let top = app.navigationBars.firstMatch.frame.minY
        return PixelRect(CGRect(x: 0, y: 0, width: app.frame.width, height: max(top, 0)), scale: scale)
            ?? PixelRect(x: 0, y: 0, width: imageWidth, height: 0)
    }

    /// The top `height` rows of `image`.
    private func top(of image: Bitmap, height: Int) throws -> Bitmap {
        let rows = min(height, image.height)
        return try Bitmap(width: image.width, height: rows, bytes: Array(image.bytes.prefix(image.width * rows * 4)))
    }

    /// Places images next to each other on the app's background color.
    private func sideBySide(_ images: [Bitmap], gap: Int, colorScheme: String) throws -> Bitmap {
        let height = images.map(\.height).max() ?? 1
        let width = images.map(\.width).reduce(0, +) + gap * (images.count - 1)
        let background = colorScheme == "dark" ? Bitmap.Pixel(red: 4, green: 17, blue: 31) : Bitmap.Pixel(red: 234, green: 244, blue: 255)
        var canvas = try Bitmap(width: width, height: height, filledWith: background)
        var originX = 0
        for image in images {
            for y in 0..<image.height {
                for x in 0..<image.width {
                    if let pixel = image[x: x, y: y] { canvas.setPixel(pixel, x: originX + x, y: y) }
                }
            }
            originX += image.width + gap
        }
        return canvas
    }
}

extension CatalogRobot {
    /// Flips the "Show prices" switch. A SwiftUI toggle in a list only reacts to taps on the
    /// switch itself, at the right edge of the row.
    @discardableResult
    func togglePrices() -> Self {
        step("Toggle the prices") { robot in
            XCTAssertTrue(robot.showPrices.waitForHittable(timeout: robot.defaultTimeout))
            let expected = (robot.showPrices.value as? String) == "1" ? "0" : "1"
            robot.showPrices.coordinate(withNormalizedOffset: CGVector(dx: 0.93, dy: 0.5)).tap()
            // Wait for the new state before the next screenshot is taken.
            XCTAssertTrue(robot.showPrices.waitForValue(expected, timeout: robot.defaultTimeout))
            XCTAssertTrue(robot.product("kettle").waitForHittable(timeout: robot.defaultTimeout))
        }
    }
}
