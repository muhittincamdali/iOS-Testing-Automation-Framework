# Comparing Screenshots

Catch visual regressions with SwiftUI snapshots in unit tests and screenshot baselines in UI tests.

## Snapshots of SwiftUI views

``assertSnapshot(of:named:size:scale:colorScheme:background:comparator:store:filePath:)``
renders a view with `ImageRenderer` and compares it with a PNG baseline next to the test
file, in `__Snapshots__/<test file name>/`:

```swift
@Test @MainActor func signalBarsLookRight() throws {
    try assertSnapshot(of: SignalBars(level: 3), named: "signal-bars-3", size: CGSize(width: 44, height: 32))
}
```

The function throws ``SnapshotError`` instead of recording an issue, so it works the same in
Swift Testing and XCTest. The first run writes the baseline and throws "Recorded a new
baseline", so a missing baseline never passes silently; commit the PNG and later runs compare
against it. When a SwiftPM test target contains the folder, exclude it from the sources:

```swift
.testTarget(name: "AppTests", dependencies: [...], exclude: ["__Snapshots__"])
```

Rendering depends on the operating system (fonts and system controls change between
releases), so record baselines on the OS version your CI uses. Views that need a window, such
as sheets or UIKit-backed controls, cannot be rendered this way; compare them with a UI-test
screenshot instead.

## Screenshots in UI tests

``Robot/assertScreenshot(named:of:ignoring:comparator:store:fileID:filePath:line:column:)``
takes a screenshot of the app (or one element) and compares it with its baseline. Leave out
parts that change on their own, such as a clock:

```swift
catalog.assertScreenshot(named: "catalog", ignoring: [catalog.lastUpdated])
```

On a mismatch the baseline, the actual image and a difference image are attached to the test
activity, and the actual and difference PNGs are written to the store's failure folder. In
the difference image the actual screenshot is faded and every changed pixel is blue:

@Image(source: "visual-diff-light.png", alt: "The catalog screen with prices, the same screen with the prices hidden, and the difference image in which the prices and the switch are blue")

## Tolerances

``ImageComparator`` has two settings:

- `pixelTolerance` (0...1): how far a color channel may move before a pixel counts as changed.
  The assertions use 0.02, which absorbs color management and anti-aliasing noise.
- `maximumDifferentPixelFraction` (0...1): the share of pixels that may change. The default,
  0, fails on any changed pixel.

Out-of-range values are clamped and NaN becomes the strictest setting. Ignored regions are
given in pixels as ``PixelRect`` values; `PixelRect(_:scale:)` converts a frame in points and
returns `nil` for NaN or infinite input instead of stopping the process.

## Recording modes

``SnapshotStore/RecordMode`` decides when a baseline is written:

| Mode                 | Missing baseline              | Existing baseline |
| -------------------- | ----------------------------- | ----------------- |
| `.missing` (default) | recorded, the assertion fails | compared          |
| `.never`             | the assertion fails           | compared          |
| `.all`               | recorded                      | replaced          |

Set `TESTING_AUTOMATION_RECORD=all` (in a scheme's environment, or with the `TEST_RUNNER_`
prefix for `xcodebuild`) to re-record every baseline after an intended change, and `never` on
CI so a forgotten baseline fails the build.

Snapshot names become safe file names: only letters, digits, `.`, `-` and `_` are kept, so a
name cannot point outside the baseline folder.
