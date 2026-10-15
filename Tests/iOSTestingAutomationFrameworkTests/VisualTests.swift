import CoreGraphics
import Foundation
import SwiftUI
import Testing
@testable import iOSTestingAutomationFramework

private func temporaryDirectory() -> URL {
    FileManager.default.temporaryDirectory.appendingPathComponent("ITAFTests-\(UUID().uuidString)", isDirectory: true)
}

@Suite("Bitmap")
struct BitmapTests {
    @Test("rejects empty, negative and oversized dimensions before allocating")
    func sizeLimits() {
        #expect(throws: Bitmap.Error.invalidSize(width: 0, height: 5)) { try Bitmap(width: 0, height: 5) }
        #expect(throws: Bitmap.Error.invalidSize(width: -1, height: 5)) { try Bitmap(width: -1, height: 5) }
        #expect(throws: Bitmap.Error.tooLarge(width: .max, height: 2)) { try Bitmap(width: .max, height: 2) }
        #expect(throws: Bitmap.Error.tooLarge(width: 10_000, height: 10_000)) { try Bitmap(width: 10_000, height: 10_000) }
        #expect(throws: Bitmap.Error.pixelCountMismatch(expected: 16, actual: 3)) {
            try Bitmap(width: 2, height: 2, bytes: [1, 2, 3])
        }
    }

    @Test("reads and writes pixels, ignoring positions outside the image")
    func pixels() throws {
        var bitmap = try Bitmap(width: 3, height: 2, filledWith: .white)
        bitmap.setPixel(.black, x: 2, y: 1)
        bitmap.setPixel(.black, x: 3, y: 0)
        bitmap.setPixel(.black, x: -1, y: 0)
        #expect(bitmap[x: 2, y: 1] == .black)
        #expect(bitmap[x: 0, y: 0] == .white)
        #expect(bitmap[x: 3, y: 0] == nil)
        #expect(bitmap[x: 0, y: -1] == nil)
    }

    @Test("survives a PNG round trip, including transparency")
    func pngRoundTrip() throws {
        var bitmap = try Bitmap(width: 4, height: 3, filledWith: Bitmap.Pixel(red: 0, green: 113, blue: 227))
        bitmap.setPixel(Bitmap.Pixel(red: 10, green: 20, blue: 30, alpha: 0), x: 0, y: 0)
        bitmap.setPixel(Bitmap.Pixel(red: 200, green: 100, blue: 50, alpha: 255), x: 3, y: 2)
        let decoded = try Bitmap(data: try bitmap.pngData())
        #expect(decoded.width == 4)
        #expect(decoded.height == 3)
        #expect(decoded[x: 3, y: 2] == Bitmap.Pixel(red: 200, green: 100, blue: 50))
        #expect(decoded[x: 1, y: 1] == Bitmap.Pixel(red: 0, green: 113, blue: 227))
        #expect(decoded[x: 0, y: 0]?.alpha == 0)
    }

    @Test("rejects data that is not an image")
    func garbage() {
        #expect(throws: Bitmap.Error.unreadableImage) { try Bitmap(data: Data("not a png".utf8)) }
        #expect(throws: Bitmap.Error.unreadableImage) { try Bitmap(data: Data()) }
    }

    @Test("refuses a PNG whose header claims a huge size, without decoding it")
    func decompressionBomb() throws {
        // A real 1 × 1 PNG with the IHDR width and height patched to 100,000 × 100,000.
        var data = try Bitmap(width: 1, height: 1, filledWith: .white).pngData()
        let ihdr = try #require(data.range(of: Data("IHDR".utf8)))
        let size: [UInt8] = [0x00, 0x01, 0x86, 0xA0]
        data.replaceSubrange(ihdr.upperBound..<(ihdr.upperBound + 4), with: size)
        data.replaceSubrange((ihdr.upperBound + 4)..<(ihdr.upperBound + 8), with: size)
        #expect(throws: Bitmap.Error.self) { try Bitmap(data: data) }
    }

    @Test("pixel rectangles from points reject NaN, infinity and values that do not fit Int")
    func pixelRectConversion() {
        #expect(PixelRect(CGRect(x: 1.2, y: 0.5, width: 10, height: 2.2), scale: 2) == PixelRect(x: 2, y: 1, width: 21, height: 5))
        #expect(PixelRect(CGRect(x: CGFloat.nan, y: 0, width: 1, height: 1)) == nil)
        #expect(PixelRect(CGRect(x: 0, y: 0, width: CGFloat.infinity, height: 1)) == nil)
        #expect(PixelRect(CGRect(x: 0, y: 0, width: 1e300, height: 1)) == nil)
        #expect(PixelRect(CGRect(x: 0, y: 0, width: 1, height: 1), scale: 0) == nil)
        #expect(PixelRect(CGRect(x: 0, y: 0, width: 1, height: 1), scale: -2) == nil)
    }

    @Test("clipping and containment never overflow")
    func clipping() {
        let rect = PixelRect(x: .max - 1, y: 0, width: .max, height: 10)
        #expect(rect.clipped(toWidth: 100, height: 100) == nil)
        #expect(PixelRect(x: -10, y: -10, width: 20, height: 20).clipped(toWidth: 5, height: 5) == PixelRect(x: 0, y: 0, width: 5, height: 5))
        #expect(PixelRect(x: .min, y: .min, width: 5, height: 5).contains(x: 100, y: 100) == false)
        #expect(PixelRect(x: 0, y: 0, width: 0, height: 5).contains(x: 0, y: 0) == false)
        #expect(PixelRect(x: 2, y: 2, width: 2, height: 2).contains(x: 3, y: 3))
    }
}

@Suite("ImageComparator")
struct ImageComparatorTests {
    @Test("identical images match")
    func identical() throws {
        let image = try Bitmap(width: 8, height: 8, filledWith: .white)
        let comparison = ImageComparator().compare(image, image)
        #expect(comparison.matches)
        #expect(comparison.differentPixelCount == 0)
        #expect(comparison.differenceImage == nil)
        #expect(comparison.summary == "Images match")
    }

    @Test("finds changed pixels, their bounds and draws a difference image")
    func differences() throws {
        let baseline = try Bitmap(width: 10, height: 10, filledWith: .white)
        var actual = baseline
        actual.fill(PixelRect(x: 2, y: 3, width: 3, height: 2), with: .black)
        let comparison = ImageComparator().compare(baseline, actual)
        #expect(!comparison.matches)
        #expect(comparison.outcome == .different)
        #expect(comparison.differentPixelCount == 6)
        #expect(comparison.comparedPixelCount == 100)
        #expect(comparison.maximumChannelDifference == 255)
        #expect(comparison.differenceBounds == PixelRect(x: 2, y: 3, width: 3, height: 2))
        let difference = try #require(comparison.differenceImage)
        #expect(difference[x: 2, y: 3] == Bitmap.Pixel(red: 0, green: 113, blue: 227))
        #expect(difference[x: 0, y: 0] != Bitmap.Pixel(red: 0, green: 113, blue: 227))
        #expect(comparison.summary.contains("6 of 100 pixels differ"))
    }

    @Test("pixel tolerance absorbs small color changes")
    func tolerance() throws {
        let baseline = try Bitmap(width: 4, height: 4, filledWith: Bitmap.Pixel(red: 100, green: 100, blue: 100))
        let actual = try Bitmap(width: 4, height: 4, filledWith: Bitmap.Pixel(red: 104, green: 100, blue: 100))
        #expect(!ImageComparator().compare(baseline, actual).matches)
        #expect(ImageComparator(pixelTolerance: 0.02).compare(baseline, actual).matches)
    }

    @Test("an allowed fraction of changed pixels still matches")
    func allowedFraction() throws {
        let baseline = try Bitmap(width: 10, height: 10, filledWith: .white)
        var actual = baseline
        actual.setPixel(.black, x: 0, y: 0)
        #expect(ImageComparator(maximumDifferentPixelFraction: 0.01).compare(baseline, actual).matches)
        #expect(!ImageComparator(maximumDifferentPixelFraction: 0.005).compare(baseline, actual).matches)
    }

    @Test("ignored regions are not compared")
    func ignoredRegions() throws {
        let baseline = try Bitmap(width: 10, height: 10, filledWith: .white)
        var actual = baseline
        actual.fill(PixelRect(x: 0, y: 0, width: 4, height: 1), with: .black)
        let comparator = ImageComparator(ignoredRegions: [PixelRect(x: 0, y: 0, width: 10, height: 1), PixelRect(x: 50, y: 50, width: 5, height: 5)])
        let comparison = comparator.compare(baseline, actual)
        #expect(comparison.matches)
        #expect(comparison.comparedPixelCount == 90)
    }

    @Test("different sizes never match")
    func sizeMismatch() throws {
        let comparison = ImageComparator(maximumDifferentPixelFraction: 1).compare(
            try Bitmap(width: 2, height: 2), try Bitmap(width: 3, height: 2))
        #expect(comparison.outcome == .sizeMismatch)
        #expect(comparison.summary == "Image size changed from 2 × 2 to 3 × 2")
    }

    @Test("settings are clamped and NaN is the strictest value")
    func clamping() {
        #expect(ImageComparator(pixelTolerance: .nan).pixelTolerance == 0)
        #expect(ImageComparator(pixelTolerance: 4).pixelTolerance == 1)
        #expect(ImageComparator(maximumDifferentPixelFraction: -1).maximumDifferentPixelFraction == 0)
        #expect(ImageComparator(maximumDifferentPixelFraction: .nan).maximumDifferentPixelFraction == 0)
    }
}

@Suite("SnapshotStore")
struct SnapshotStoreTests {
    @Test("file names cannot leave the baseline folder")
    func safeFileNames() {
        #expect(SnapshotStore.fileName(for: "../../etc/passwd") == "etc-passwd")
        #expect(SnapshotStore.fileName(for: "..") == "snapshot")
        #expect(SnapshotStore.fileName(for: "") == "snapshot")
        #expect(SnapshotStore.fileName(for: ".hidden") == "hidden")
        #expect(SnapshotStore.fileName(for: "Sign in — dark") == "Sign-in-dark")
        #expect(SnapshotStore.fileName(for: "a/b\\c:d") == "a-b-c-d")
        #expect(SnapshotStore.fileName(for: String(repeating: "x", count: 500)).count == 120)

        let store = SnapshotStore(directory: URL(fileURLWithPath: "/tmp/baselines"), environment: [:])
        let url = store.baselineURL(for: "../../../../outside").standardizedFileURL
        #expect(url.path.hasPrefix("/tmp/baselines/"))
    }

    @Test("records a missing baseline, then matches, then reports a change with files")
    func lifecycle() throws {
        let root = temporaryDirectory()
        defer { try? FileManager.default.removeItem(at: root) }
        let store = SnapshotStore(directory: root.appendingPathComponent("baselines"),
                                  failureDirectory: root.appendingPathComponent("failures"), environment: [:])
        let image = try Bitmap(width: 6, height: 6, filledWith: .white)

        guard case .recorded(let url) = try store.verify(image, named: "screen") else {
            Issue.record("Expected the first run to record")
            return
        }
        #expect(FileManager.default.fileExists(atPath: url.path))
        #expect(try store.verify(image, named: "screen").passed)

        var changed = image
        changed.setPixel(.black, x: 1, y: 1)
        let verification = try store.verify(changed, named: "screen")
        guard case .mismatch(let comparison, _, let actual, let difference) = verification else {
            Issue.record("Expected a mismatch")
            return
        }
        #expect(comparison.differentPixelCount == 1)
        #expect(actual.map { FileManager.default.fileExists(atPath: $0.path) } == true)
        #expect(difference.map { FileManager.default.fileExists(atPath: $0.path) } == true)
        #expect(verification.failureMessage?.contains("1 of 36 pixels differ") == true)
    }

    @Test("never mode reports a missing baseline without writing it")
    func neverRecords() throws {
        let root = temporaryDirectory()
        defer { try? FileManager.default.removeItem(at: root) }
        let store = SnapshotStore(directory: root, recordMode: .never, environment: [:])
        let result = try store.verify(try Bitmap(width: 1, height: 1), named: "missing")
        guard case .missingBaseline(let url) = result else {
            Issue.record("Expected a missing baseline")
            return
        }
        #expect(!FileManager.default.fileExists(atPath: url.path))
        #expect(result.failureMessage?.contains(SnapshotStore.RecordMode.environmentKey) == true)
    }

    @Test("the environment overrides the record mode, ignoring invalid values")
    func environmentOverride() {
        let directory = URL(fileURLWithPath: "/tmp/x")
        #expect(SnapshotStore(directory: directory, recordMode: .never, environment: ["TESTING_AUTOMATION_RECORD": "ALL"]).recordMode == .all)
        #expect(SnapshotStore(directory: directory, recordMode: .never, environment: ["TESTING_AUTOMATION_RECORD": "sometimes"]).recordMode == .never)
    }

    @Test("all mode replaces existing baselines")
    func recordAll() throws {
        let root = temporaryDirectory()
        defer { try? FileManager.default.removeItem(at: root) }
        _ = try SnapshotStore(directory: root, environment: [:]).verify(try Bitmap(width: 2, height: 2, filledWith: .white), named: "s")
        let all = SnapshotStore(directory: root, recordMode: .all, environment: [:])
        guard case .recorded = try all.verify(try Bitmap(width: 2, height: 2, filledWith: .black), named: "s") else {
            Issue.record("Expected a new recording")
            return
        }
        #expect(try Bitmap(contentsOf: all.baselineURL(for: "s"))[x: 0, y: 0] == .black)
    }
}
