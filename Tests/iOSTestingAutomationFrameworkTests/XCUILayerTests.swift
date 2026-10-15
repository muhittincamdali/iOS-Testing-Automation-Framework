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
    @Test("assertSnapshot passes on a matching baseline and records an issue on a change")
    func assertion() throws {
        let root = temporaryDirectory()
        defer { try? FileManager.default.removeItem(at: root) }
        let store = SnapshotStore(directory: root, failureDirectory: root.appendingPathComponent("failures"), environment: [:])
        let size = CGSize(width: 16, height: 16)
        _ = try store.verify(try ViewRenderer.render(Swatch(color: .blue), size: size), named: "swatch")

        assertSnapshot(of: Swatch(color: .blue), named: "swatch", size: size, store: store)
        withKnownIssue {
            assertSnapshot(of: Swatch(color: .orange), named: "swatch", size: size, store: store)
        } matching: { issue in
            issue.comments.contains { $0.rawValue.contains("does not match") }
        }
        withKnownIssue {
            assertSnapshot(of: Swatch(color: .blue), named: "new-baseline", size: size, store: store)
        } matching: { issue in
            issue.comments.contains { $0.rawValue.contains("Recorded a new baseline") }
        }
    }

    @Test("failure messages mask registered secrets")
    func maskedFailures() throws {
        let root = temporaryDirectory()
        defer {
            try? FileManager.default.removeItem(at: root)
            TestingAutomation.removeAllSecrets()
        }
        TestingAutomation.registerSecret("s3cr3t-name")
        let store = SnapshotStore(directory: root, recordMode: .never, environment: [:])
        let image = try Bitmap(width: 1, height: 1)
        withKnownIssue {
            assertSnapshot(of: image, named: "s3cr3t-name", store: store)
        } matching: { issue in
            issue.comments.allSatisfy { !$0.rawValue.contains("s3cr3t-name") }
        }
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
}
