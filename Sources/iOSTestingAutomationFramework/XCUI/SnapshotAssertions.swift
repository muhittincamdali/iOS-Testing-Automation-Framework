#if canImport(XCTest)
import SwiftUI
import XCTest

/// Renders `view` and compares it with the baseline called `name`.
///
/// Works in Swift Testing and XCTest unit tests, on macOS and on iOS simulators. The first run
/// records the baseline in `__Snapshots__/<test file>/` next to the test and fails, so a
/// missing baseline is never mistaken for a pass; later runs compare against it. Set
/// `TESTING_AUTOMATION_RECORD=all` to re-record every baseline.
///
/// ```swift
/// @Test @MainActor func badge() {
///     assertSnapshot(of: Badge(count: 3), named: "badge-3", size: CGSize(width: 120, height: 44))
/// }
/// ```
///
/// Baselines differ between operating system versions (fonts and controls change), so record
/// them on the same OS version your CI runs.
@MainActor
public func assertSnapshot<Content: View>(
    of view: Content,
    named name: String,
    size: CGSize,
    scale: CGFloat = 2,
    colorScheme: ColorScheme = .light,
    background: Color = .clear,
    comparator: ImageComparator = ImageComparator(pixelTolerance: 0.02),
    store: SnapshotStore? = nil,
    fileID: String = #fileID, filePath: StaticString = #filePath, line: UInt = #line, column: UInt = #column
) {
    let site = CallSite(fileID: fileID, filePath: filePath, line: line, column: column)
    do {
        let image = try ViewRenderer.render(view, size: size, scale: scale, colorScheme: colorScheme, background: background)
        verifySnapshot(image, named: name, comparator: comparator, store: store ?? .besideTestFile(filePath), at: site)
    } catch {
        recordFailure("Could not render \"\(name)\": \(error)", at: site)
    }
}

/// Compares an image you produced yourself with the baseline called `name`.
@MainActor
public func assertSnapshot(
    of image: Bitmap,
    named name: String,
    comparator: ImageComparator = ImageComparator(pixelTolerance: 0.02),
    store: SnapshotStore? = nil,
    fileID: String = #fileID, filePath: StaticString = #filePath, line: UInt = #line, column: UInt = #column
) {
    let site = CallSite(fileID: fileID, filePath: filePath, line: line, column: column)
    verifySnapshot(image, named: name, comparator: comparator, store: store ?? .besideTestFile(filePath), at: site)
}

@MainActor
func verifySnapshot(_ image: Bitmap, named name: String, comparator: ImageComparator, store: SnapshotStore, at site: CallSite) {
    do {
        let verification = try store.verify(image, named: name, comparator: comparator)
        guard let message = verification.failureMessage else { return }
        if case .mismatch(let comparison, let baselineURL, _, _) = verification {
            var images: [(name: String, bitmap: Bitmap)] = [("actual", image)]
            if let baseline = try? Bitmap(contentsOf: baselineURL) { images.insert(("baseline", baseline), at: 0) }
            if let difference = comparison.differenceImage { images.append(("difference", difference)) }
            attachImages(images, activity: "Snapshot \(name)")
        }
        recordFailure(message, at: site)
    } catch {
        recordFailure("Could not verify snapshot \"\(name)\": \(error)", at: site)
    }
}

extension XCUIScreenshot {
    /// The screenshot as a ``Bitmap``.
    public func bitmap() throws -> Bitmap {
        try Bitmap(data: pngRepresentation)
    }
}

extension Robot {
    /// Takes a screenshot of `element` (the whole app by default) and compares it with the
    /// baseline called `name`.
    ///
    /// - Parameters:
    ///   - ignoredElements: Elements to leave out of the comparison, such as a clock or a date.
    ///   - comparator: The default tolerates small color changes (2 %) but no changed pixels.
    ///   - store: Defaults to `__Snapshots__/<test file>/` next to the test file.
    @discardableResult
    public func assertScreenshot(
        named name: String,
        of element: XCUIElement? = nil,
        ignoring ignoredElements: [XCUIElement] = [],
        comparator: ImageComparator = ImageComparator(pixelTolerance: 0.02),
        store: SnapshotStore? = nil,
        fileID: String = #fileID, filePath: StaticString = #filePath, line: UInt = #line, column: UInt = #column
    ) -> Self {
        let site = CallSite(fileID: fileID, filePath: filePath, line: line, column: column)
        XCTContext.runActivity(named: "Compare screenshot \(name)") { _ in
            do {
                let (image, regions) = try screenshot(of: element ?? app, ignoring: ignoredElements)
                var comparator = comparator
                comparator.ignoredRegions += regions
                verifySnapshot(image, named: name, comparator: comparator, store: store ?? .besideTestFile(filePath), at: site)
            } catch {
                recordFailure("Could not capture screenshot \"\(name)\": \(error)", at: site)
            }
        }
        return self
    }

    /// Takes a screenshot of `target` and converts the frames of `ignoredElements` to pixel
    /// rectangles inside it, for ``ImageComparator/ignoredRegions``.
    public func screenshot(of target: XCUIElement, ignoring ignoredElements: [XCUIElement] = []) throws -> (image: Bitmap, ignoredRegions: [PixelRect]) {
        let image = try target.screenshot().bitmap()
        let frame = target.frame
        guard frame.width.isFinite, frame.width > 0 else { return (image, []) }
        let scale = CGFloat(image.width) / frame.width
        let regions = ignoredElements.filter(\.exists).compactMap { element -> PixelRect? in
            PixelRect(element.frame.offsetBy(dx: -frame.minX, dy: -frame.minY), scale: scale)
        }
        return (image, regions)
    }
}
#endif
