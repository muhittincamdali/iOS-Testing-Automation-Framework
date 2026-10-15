#if canImport(XCTest)
import XCTest

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
    /// On a mismatch the baseline, actual and difference images are attached to the XCTest
    /// activity, where Xcode's test report shows them.
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
        XCTContext.runActivity(named: "Compare screenshot \(name)") { activity in
            do {
                let (image, regions) = try screenshot(of: element ?? app, ignoring: ignoredElements)
                var comparator = comparator
                comparator.ignoredRegions += regions
                let verification = try (store ?? .besideTestFile(filePath)).verify(image, named: name, comparator: comparator)
                guard let message = verification.failureMessage else { return }
                if case .mismatch(let comparison, let baselineURL, _, _) = verification {
                    attach(try? Bitmap(contentsOf: baselineURL), named: "baseline", to: activity)
                    attach(image, named: "actual", to: activity)
                    attach(comparison.differenceImage, named: "difference", to: activity)
                }
                recordFailure(message, at: site)
            } catch {
                recordFailure("Could not compare screenshot \"\(name)\": \(error)", at: site)
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

    private func attach(_ bitmap: Bitmap?, named name: String, to activity: any XCTActivity) {
        guard let data = try? bitmap?.pngData() else { return }
        let attachment = XCTAttachment(data: data, uniformTypeIdentifier: "public.png")
        attachment.name = name
        attachment.lifetime = .keepAlways
        activity.add(attachment)
    }
}
#endif
