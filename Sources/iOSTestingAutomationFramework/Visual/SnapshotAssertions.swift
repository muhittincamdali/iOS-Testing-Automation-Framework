import Foundation
import SwiftUI

/// Thrown by ``assertSnapshot(of:named:size:scale:colorScheme:background:comparator:store:filePath:)``
/// when an image does not match its baseline, has no baseline yet or was just recorded.
///
/// The description says what happened and where the actual and difference images are, with
/// registered secrets masked.
public struct SnapshotError: Error, CustomStringConvertible, Sendable {
    public let verification: SnapshotStore.Verification

    public var description: String {
        TestingAutomation.redactor.redact(verification.failureMessage ?? "Snapshot failed")
    }
}

/// Renders `view` and compares it with the baseline called `name`.
///
/// The function throws instead of recording a failure, so it works the same way in Swift
/// Testing and XCTest: a thrown error fails the test with the error's message.
///
/// The first run records the baseline in `__Snapshots__/<test file>/` next to the test and
/// throws, so a missing baseline is never mistaken for a pass; later runs compare against it.
/// Set `TESTING_AUTOMATION_RECORD=all` to re-record every baseline.
///
/// ```swift
/// @Test @MainActor func badge() throws {
///     try assertSnapshot(of: Badge(count: 3), named: "badge-3", size: CGSize(width: 120, height: 44))
/// }
/// ```
///
/// Rendering differs between operating system versions (fonts and controls change), so record
/// baselines on the OS version your CI uses.
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
    filePath: StaticString = #filePath
) throws {
    let image = try ViewRenderer.render(view, size: size, scale: scale, colorScheme: colorScheme, background: background)
    try assertSnapshot(of: image, named: name, comparator: comparator, store: store, filePath: filePath)
}

/// Compares an image you produced yourself with the baseline called `name`, and throws a
/// ``SnapshotError`` unless it matches.
public func assertSnapshot(
    of image: Bitmap,
    named name: String,
    comparator: ImageComparator = ImageComparator(pixelTolerance: 0.02),
    store: SnapshotStore? = nil,
    filePath: StaticString = #filePath
) throws {
    let store = store ?? .besideTestFile(filePath)
    let verification = try store.verify(image, named: name, comparator: comparator)
    guard verification.passed else { throw SnapshotError(verification: verification) }
}
