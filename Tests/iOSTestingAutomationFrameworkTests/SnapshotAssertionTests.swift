import CoreGraphics
import Foundation
import SwiftUI
import Testing
@testable import iOSTestingAutomationFramework

private func temporaryDirectory() -> URL {
    FileManager.default.temporaryDirectory.appendingPathComponent("ITAFTests-\(UUID().uuidString)", isDirectory: true)
}

@Suite("assertSnapshot", .serialized)
@MainActor
struct SnapshotAssertionTests {
    @Test("passes on a matching baseline and throws on a change or a new baseline")
    func assertion() throws {
        let root = temporaryDirectory()
        defer { try? FileManager.default.removeItem(at: root) }
        let store = SnapshotStore(directory: root, failureDirectory: root.appendingPathComponent("failures"), environment: [:])
        let size = CGSize(width: 16, height: 16)
        _ = try store.verify(try ViewRenderer.render(Swatch(color: .blue), size: size), named: "swatch")

        try assertSnapshot(of: Swatch(color: .blue), named: "swatch", size: size, store: store)

        let mismatch = #expect(throws: SnapshotError.self) {
            try assertSnapshot(of: Swatch(color: .orange), named: "swatch", size: size, store: store)
        }
        #expect(mismatch?.description.contains("does not match swatch.png") == true)
        #expect(mismatch?.description.contains("Difference:") == true)

        let recorded = #expect(throws: SnapshotError.self) {
            try assertSnapshot(of: Swatch(color: .blue), named: "new-baseline", size: size, store: store)
        }
        #expect(recorded?.description.contains("Recorded a new baseline") == true)
        // The second run compares against the recorded baseline and passes.
        try assertSnapshot(of: Swatch(color: .blue), named: "new-baseline", size: size, store: store)
    }

    @Test("error messages mask registered secrets")
    func maskedFailures() throws {
        let root = temporaryDirectory()
        defer {
            try? FileManager.default.removeItem(at: root)
            TestingAutomation.removeAllSecrets()
        }
        TestingAutomation.registerSecret("s3cr3t-name")
        let store = SnapshotStore(directory: root, recordMode: .never, environment: [:])
        let error = #expect(throws: SnapshotError.self) {
            try assertSnapshot(of: try Bitmap(width: 1, height: 1), named: "s3cr3t-name", store: store)
        }
        #expect(error?.description.contains("No baseline") == true)
        #expect(error?.description.contains("s3cr3t-name") == false)
    }
}

@Suite("TestResultCollector")
struct TestResultCollectorTests {
    @Test("XCTest test names split into suite and test")
    func splitsTestNames() {
        #expect(TestResultCollector.split("-[ShowcaseUITests.SignInTests testSignIn]") == ("SignInTests", "testSignIn"))
        #expect(TestResultCollector.split("-[SignInTests testSignIn]") == ("SignInTests", "testSignIn"))
        #expect(TestResultCollector.split("plainName") == ("", "plainName"))
    }

    @Test("the healing suggestions in the summary are masked")
    func healingSuggestionsAreMasked() {
        let report = TestReport(name: "UI", results: [], redactor: Redactor(secrets: ["s3cr3t-label"]))
        let healing = "### Healed locators\n\n- `login` was found by label: Add .accessibilityIdentifier(\"login\") to button \"s3cr3t-label\"\n"
        let summary = TestResultCollector.summary(of: report, healing: healing)
        #expect(summary.contains("### Healed locators"))
        #expect(summary.contains(#"button "••••""#))
        #expect(!summary.contains("s3cr3t-label"))
        #expect(TestResultCollector.summary(of: report, healing: "") == report.markdownSummary())
    }
}
