import Foundation
import SwiftUI
import Testing
import iOSTestingAutomationFramework

// The README's unit-test samples are copied from this file, so they compile and pass in CI.
// The baseline for the snapshot sample is in __Snapshots__/ReadmeExamples/.

struct SignalBars: View {
    let level: Int

    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            ForEach(1...4, id: \.self) { bar in
                Rectangle()
                    .fill(bar <= level ? Color.blue : Color.gray.opacity(0.3))
                    .frame(width: 8, height: CGFloat(bar * 8))
            }
        }
        .frame(width: 44, height: 32, alignment: .bottomLeading)
    }
}

protocol UserService: Sendable {
    func user(id: Int) async throws -> String
}

struct FakeUserService: UserService {
    let fetchUser = ThrowingSpy<Int, String>(returning: "Ada")

    func user(id: Int) async throws -> String {
        try fetchUser(id)
    }
}

@MainActor
@Observable
final class ProfileModel {
    private(set) var name: String?
    private let service: any UserService

    init(service: any UserService) { self.service = service }

    func load(id: Int) {
        Task { name = try? await service.user(id: id) }
    }
}

@Suite("README samples")
struct ReadmeExamples {
    @Test @MainActor func signalBarsLookRight() throws {
        try assertSnapshot(of: SignalBars(level: 3), named: "signal-bars-3", size: CGSize(width: 44, height: 32))
    }

    @Test @MainActor func profileLoadsTheUser() async throws {
        let service = FakeUserService()
        let model = ProfileModel(service: service)

        model.load(id: 42)

        try await Wait.until("the name to load") { model.name == "Ada" }
        #expect(service.fetchUser.inputs == [42])
    }

    @Test func retryAFlakyServer() async throws {
        let policy = RetryPolicy(maxAttempts: 3, backoff: .constant(.milliseconds(10)))
        var calls = 0
        let token = try await policy.run { attempt in
            calls += 1
            if attempt < 2 { throw URLError(.timedOut) }
            return "token-\(attempt)"
        }
        #expect(token == "token-2")
        #expect(calls == 2)
    }

    @Test func reproducibleTestData() {
        var fixtures = Fixtures(seed: 42)
        let email = fixtures.email()
        #expect(email.hasSuffix("@example.com"))
    }

    @Test func junitReport() {
        let results = [
            TestResult(name: "testSignIn", suite: "SignInTests", status: .passed, duration: 1.2),
            TestResult(name: "testCheckout", suite: "CheckoutTests", status: .failed, duration: 3.4,
                       errorMessage: "Expected total 12.00, got password=hunter2")
        ]
        let report = TestReport(name: "Nightly", results: results)
        let xml = report.junitXML()
        #expect(xml.contains(#"<testsuites name="Nightly" tests="2" failures="1""#))
        #expect(!xml.contains("hunter2"))
    }
}
