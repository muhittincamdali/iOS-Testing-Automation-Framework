import Foundation
import Testing
@testable import iOSTestingAutomationFramework

@Suite("Wait")
struct WaitTests {
    @Test("returns as soon as the condition holds")
    func returnsWhenConditionHolds() async throws {
        let clock = TestClock()
        var checks = 0
        let value = try await Wait.value(timeout: .seconds(1), pollingEvery: .milliseconds(100), clock: clock) { () -> Int? in
            checks += 1
            return checks == 3 ? 42 : nil
        }
        #expect(value == 42)
        #expect(checks == 3)
        #expect(clock.sleeps == [.milliseconds(100), .milliseconds(100)])
    }

    @Test("throws a timeout error after the last check at the deadline")
    func timesOut() async throws {
        let clock = TestClock()
        var checks = 0
        await #expect(throws: Wait.TimeoutError.self) {
            _ = try await Wait.value("the spinner to stop", timeout: .milliseconds(250), pollingEvery: .milliseconds(100), clock: clock) { () -> Int? in
                checks += 1
                return nil
            }
        }
        // Checks at 0, 100, 200 and the final one at the 250 ms deadline.
        #expect(checks == 4)
        #expect(clock.sleeps == [.milliseconds(100), .milliseconds(100), .milliseconds(50)])
    }

    @Test("describes what it waited for")
    func timeoutMessage() async {
        do {
            _ = try await Wait.value("the user", timeout: .zero, clock: TestClock()) { () -> String? in nil }
            Issue.record("Expected a timeout")
        } catch let error as Wait.TimeoutError {
            #expect(error.message == "the user")
            #expect(error.checks == 1)
            #expect(error.description.contains("the user"))
        } catch {
            Issue.record("Unexpected error \(error)")
        }
    }

    @Test("treats a negative timeout as zero and checks once")
    func negativeTimeout() async {
        let clock = TestClock()
        var checks = 0
        await #expect(throws: Wait.TimeoutError.self) {
            _ = try await Wait.value(timeout: .seconds(-5), clock: clock) { () -> Int? in
                checks += 1
                return nil
            }
        }
        #expect(checks == 1)
        #expect(clock.sleeps.isEmpty)
    }

    @Test("raises a zero or negative interval to one millisecond so the loop cannot spin")
    func zeroInterval() async {
        let clock = TestClock()
        await #expect(throws: Wait.TimeoutError.self) {
            _ = try await Wait.value(timeout: .milliseconds(3), pollingEvery: .zero, clock: clock) { () -> Int? in nil }
        }
        #expect(clock.sleeps == [.milliseconds(1), .milliseconds(1), .milliseconds(1)])
    }

    @Test("passes on errors thrown by the condition")
    func passesOnErrors() async {
        struct Boom: Error {}
        await #expect(throws: Boom.self) {
            try await Wait.until(timeout: .seconds(1)) { throw Boom() }
        }
    }

    @Test("stops when the task is cancelled")
    func cancellation() async {
        let task = Task {
            try await Wait.until(timeout: .seconds(30), pollingEvery: .milliseconds(5)) { false }
        }
        task.cancel()
        await #expect(throws: CancellationError.self) { try await task.value }
    }

    @Test("works with the real clock")
    func realClock() async throws {
        let start = ContinuousClock.now
        let flag = Flag()
        let producer = Task {
            try await Task.sleep(for: .milliseconds(30))
            await flag.set()
        }
        try await Wait.until(timeout: .seconds(5), pollingEvery: .milliseconds(5)) { await flag.isSet }
        try await producer.value
        #expect(ContinuousClock.now - start < .seconds(5))
    }
}

@Suite("RetryPolicy")
struct RetryPolicyTests {
    struct Failure: Error, Equatable { let attempt: Int }

    @Test("exponential delays grow and stop at the maximum")
    func exponentialDelays() {
        let policy = RetryPolicy(maxAttempts: 10, backoff: .exponential(initial: .milliseconds(100), multiplier: 2, maximum: .milliseconds(500)))
        #expect(policy.delay(beforeAttempt: 1) == .zero)
        #expect(policy.delay(beforeAttempt: 2) == .milliseconds(100))
        #expect(policy.delay(beforeAttempt: 3) == .milliseconds(200))
        #expect(policy.delay(beforeAttempt: 4) == .milliseconds(400))
        #expect(policy.delay(beforeAttempt: 5) == .milliseconds(500))
        #expect(policy.delay(beforeAttempt: 10_000) == .milliseconds(500))
        #expect(policy.delay(beforeAttempt: .max) == .milliseconds(500))
    }

    @Test("clamps attempts, durations, multiplier and jitter instead of trapping")
    func sanitizesInput() {
        let policy = RetryPolicy(
            maxAttempts: .max,
            backoff: .exponential(initial: .seconds(-3), multiplier: .nan, maximum: .seconds(-1)),
            jitter: .infinity
        )
        #expect(policy.maxAttempts == RetryPolicy.attemptLimit)
        #expect(policy.backoff == .exponential(initial: .zero, multiplier: 1, maximum: .zero))
        #expect(policy.jitter == 1)
        #expect(RetryPolicy(maxAttempts: -4).maxAttempts == 1)
        #expect(RetryPolicy(jitter: .nan).jitter == 0)
        #expect(RetryPolicy(backoff: .constant(.seconds(-2))).backoff == .constant(.zero))
        let huge = RetryPolicy(backoff: .exponential(initial: .seconds(1), multiplier: .greatestFiniteMagnitude, maximum: .seconds(30)))
        #expect(huge.delay(beforeAttempt: 50) == .seconds(30))
    }

    @Test("jitter removes at most the given fraction of a delay")
    func jitter() {
        let policy = RetryPolicy(maxAttempts: 5, backoff: .constant(.seconds(1)), jitter: 0.5)
        var generator = StepGenerator(seed: 7)
        for _ in 0..<200 {
            let delay = policy.delay(beforeAttempt: 2, using: &generator)
            #expect(delay <= .seconds(1))
            #expect(delay > .milliseconds(500))
        }
    }

    @Test("retries until the operation succeeds and sleeps between attempts")
    func retriesUntilSuccess() async throws {
        let clock = TestClock()
        var generator = StepGenerator(seed: 1)
        let policy = RetryPolicy(maxAttempts: 5, backoff: .exponential(initial: .milliseconds(10)))
        var attempts: [Int] = []
        let value = try await policy.run(clock: clock, generator: &generator) { attempt in
            attempts.append(attempt)
            if attempt < 3 { throw Failure(attempt: attempt) }
            return "ok"
        }
        #expect(value == "ok")
        #expect(attempts == [1, 2, 3])
        #expect(clock.sleeps == [.milliseconds(10), .milliseconds(20)])
    }

    @Test("throws the last error when the attempts run out")
    func exhausts() async {
        var generator = StepGenerator(seed: 1)
        let policy = RetryPolicy(maxAttempts: 3, backoff: .constant(.zero))
        await #expect(throws: Failure(attempt: 3)) {
            try await policy.run(clock: TestClock(), generator: &generator) { attempt -> Int in
                throw Failure(attempt: attempt)
            }
        }
    }

    @Test("does not retry errors the predicate rejects, nor cancellation")
    func shouldRetry() async {
        var generator = StepGenerator(seed: 1)
        let policy = RetryPolicy(maxAttempts: 5, backoff: .constant(.zero))
        var calls = 0
        await #expect(throws: Failure(attempt: 1)) {
            try await policy.run(clock: TestClock(), generator: &generator, shouldRetry: { _ in false }) { attempt -> Int in
                calls += 1
                throw Failure(attempt: attempt)
            }
        }
        #expect(calls == 1)

        calls = 0
        await #expect(throws: CancellationError.self) {
            try await policy.run(clock: TestClock(), generator: &generator) { _ -> Int in
                calls += 1
                throw CancellationError()
            }
        }
        #expect(calls == 1)
    }
}

@Suite("FlakinessAnalyzer")
struct FlakinessAnalyzerTests {
    private func run(_ name: String, _ status: TestStatus, attempts: Int = 1) -> TestResult {
        TestResult(name: name, suite: "Suite", status: status, duration: 1, attempts: attempts)
    }

    @Test("classifies flaky, failing and stable tests")
    func classifies() {
        let history = [
            run("testA", .passed), run("testB", .failed), run("testC", .passed), run("testD", .passed, attempts: 2),
            run("testA", .failed), run("testB", .failed), run("testC", .passed),
            run("testA", .passed), run("testB", .skipped), run("testC", .skipped)
        ]
        let entries = FlakinessAnalyzer().analyze(history)
        let byName = Dictionary(uniqueKeysWithValues: entries.map { ($0.name, $0) })
        #expect(byName["testA"]?.classification == .flaky)
        #expect(byName["testA"]?.flips == 2)
        #expect(byName["testA"]?.passRate == 2.0 / 3.0)
        #expect(byName["testB"]?.classification == .failing)
        #expect(byName["testB"]?.skips == 1)
        #expect(byName["testC"]?.classification == .stable)
        #expect(byName["testD"]?.classification == .flaky)
        #expect(byName["testD"]?.passesAfterRetry == 1)
        #expect(entries.map(\.name) == ["testA", "testD", "testB", "testC"])
    }

    @Test("a test that was always skipped has no pass rate")
    func allSkipped() {
        let entry = FlakinessAnalyzer().analyze([run("t", .skipped), run("t", .skipped)]).first
        #expect(entry?.passRate == nil)
        #expect(entry?.classification == .stable)
    }

    @Test("separates tests with the same name in different suites")
    func suites() {
        let results = [TestResult(name: "t", suite: "A", status: .passed, duration: 1),
                       TestResult(name: "t", suite: "B", status: .failed, duration: 1)]
        #expect(FlakinessAnalyzer().analyze(results).count == 2)
        #expect(FlakinessAnalyzer().analyze([]).isEmpty)
    }
}

private actor Flag {
    private(set) var isSet = false
    func set() { isSet = true }
}

/// A small deterministic generator (a 64-bit linear congruential generator) for jitter tests.
struct StepGenerator: RandomNumberGenerator {
    var state: UInt64
    init(seed: UInt64) { state = seed }
    mutating func next() -> UInt64 {
        state = state &* 6_364_136_223_846_793_005 &+ 1_442_695_040_888_963_407
        return state
    }
}
