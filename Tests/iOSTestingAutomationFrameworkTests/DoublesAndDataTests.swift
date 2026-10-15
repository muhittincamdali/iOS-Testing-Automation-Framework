import Foundation
import Testing
@testable import iOSTestingAutomationFramework

@Suite("Spy")
struct SpyTests {
    struct User: Equatable, Sendable {
        let id: Int
        let name: String
    }

    @Test("records inputs and returns the default until stubbed")
    func recordsCalls() {
        let fetch = Spy<Int, User>(returning: User(id: 0, name: "Default"))
        #expect(!fetch.wasCalled)
        #expect(fetch(1).name == "Default")
        fetch.stub(User(id: 2, name: "Ada"))
        #expect(fetch(2).name == "Ada")
        #expect(fetch.inputs == [1, 2])
        #expect(fetch.lastInput == 2)
        #expect(fetch.callCount == 2)
        #expect(fetch.wasCalled(with: 1))
        #expect(!fetch.wasCalled(with: 3))
        #expect(fetch.callCount(with: 2) == 1)
    }

    @Test("plays back a sequence and then repeats its last value")
    func sequence() {
        let next = Spy<Void, Int>(returning: 0)
        next.stub(sequence: [1, 2, 3])
        #expect((0..<5).map { _ in next(()) } == [1, 2, 3, 3, 3])
        next.stub(sequence: [])
        #expect(next(()) == 3)
    }

    @Test("computes results from the input")
    func compute() {
        let double = Spy<Int, Int>(returning: 0)
        double.stub { $0 * 2 }
        #expect(double(21) == 42)
    }

    @Test("reset forgets calls and stubs")
    func reset() {
        let spy = Spy<String, Int>(returning: -1)
        spy.stub(5)
        _ = spy("a")
        spy.reset()
        #expect(spy.callCount == 0)
        #expect(spy.inputs.isEmpty)
        #expect(spy("b") == -1)
    }

    @Test("keeps at most the configured number of inputs but counts every call")
    func boundedRecording() {
        let spy = Spy<Int, Void>(maximumRecordedCalls: 3)
        for value in 0..<1_000 { spy(value) }
        #expect(spy.callCount == 1_000)
        #expect(spy.inputs == [0, 1, 2])
        #expect(Spy<Int, Void>(maximumRecordedCalls: -5).maximumRecordedCalls == 0)
    }

    @Test("is safe to call from many tasks at once")
    func concurrentCalls() async {
        let spy = Spy<Int, Void>()
        await withTaskGroup(of: Void.self) { group in
            for value in 0..<500 {
                group.addTask { spy(value) }
            }
        }
        #expect(spy.callCount == 500)
        #expect(Set(spy.inputs) == Set(0..<500))
    }

    @Test("a stub may call back into its own spy without deadlocking")
    func reentrantStub() {
        let spy = Spy<Int, Int>(returning: 0)
        spy.stub { _ in spy.callCount }
        #expect(spy(1) == 1)
    }

    @Test("a throwing spy throws the stubbed error and then recovers")
    func throwingSpy() throws {
        let save = ThrowingSpy<String, Void>()
        try save("draft")
        save.stub(throwing: URLError(.notConnectedToInternet))
        #expect(throws: URLError.self) { try save("offline") }
        save.stub(sequence: [.failure(URLError(.timedOut)), .success(())])
        #expect(throws: URLError(.timedOut)) { try save("retry") }
        try save("retry")
        #expect(save.inputs == ["draft", "offline", "retry", "retry"])
        #expect(save.wasCalled(with: "offline"))
    }

    @Test("a throwing spy can compute results or errors")
    func throwingCompute() {
        struct Odd: Error {}
        let half = ThrowingSpy<Int, Int>(returning: 0)
        half.stub { value in
            guard value.isMultiple(of: 2) else { throw Odd() }
            return value / 2
        }
        #expect((try? half(8)) == 4)
        #expect(throws: Odd.self) { try half(3) }
    }
}

@Suite("Fixtures")
struct FixturesTests {
    @Test("the same seed gives the same data")
    func deterministic() {
        var first = Fixtures(seed: 2026)
        var second = Fixtures(seed: 2026)
        for _ in 0..<20 {
            #expect(first.email() == second.email())
            #expect(first.uuid() == second.uuid())
            #expect(first.int(in: -5...5) == second.int(in: -5...5))
        }
        var other = Fixtures(seed: 2027)
        var again = Fixtures(seed: 2026)
        #expect((0..<10).map { _ in other.uuid() } != (0..<10).map { _ in again.uuid() })
    }

    @Test("SplitMix64 produces the published reference values")
    func splitMixReference() {
        var generator = SeededRandomNumberGenerator(seed: 0)
        #expect(generator.next() == 0xE220_A839_7B1D_CDAF)
        #expect(generator.next() == 0x6E78_9E6A_A1B9_65F4)
    }

    @Test("UUIDs are version 4 and emails use example.com")
    func formats() {
        var fixtures = Fixtures(seed: 9)
        for _ in 0..<50 {
            let uuid = fixtures.uuid().uuidString
            #expect(Array(uuid)[14] == "4")
            #expect("89AB".contains(Array(uuid)[19]))
            let email = fixtures.email()
            #expect(email.hasSuffix("@example.com"))
            #expect(email.allSatisfy { $0.isASCII })
        }
    }

    @Test("strings respect the length limit and the alphabet")
    func strings() {
        var fixtures = Fixtures(seed: 1)
        #expect(fixtures.string(length: 12, from: "ab").allSatisfy { "ab".contains($0) })
        #expect(fixtures.string(length: 12).count == 12)
        #expect(fixtures.string(length: -3).isEmpty)
        #expect(fixtures.string(length: 5, from: "").isEmpty)
        #expect(fixtures.string(length: .max).count == Fixtures.maximumStringLength)
    }

    @Test("numbers and dates stay in range, even for extreme bounds")
    func ranges() {
        var fixtures = Fixtures(seed: 3)
        for _ in 0..<100 {
            #expect((10...20).contains(fixtures.int(in: 10...20)))
            let value = fixtures.double(in: -Double.greatestFiniteMagnitude...Double.greatestFiniteMagnitude)
            #expect(value.isFinite)
        }
        #expect(fixtures.double(in: 1...Double.infinity) == 1)
        let start = Date(timeIntervalSince1970: 0)
        let end = Date(timeIntervalSince1970: 1_000)
        let date = fixtures.date(between: end, and: start)
        #expect(date >= start && date <= end)
        #expect(fixtures.date(between: .distantPast, and: Date(timeIntervalSinceReferenceDate: .infinity)) == .distantPast)
        #expect(fixtures.element(of: [Int]()) == nil)
    }

    @Test("reads the seed from the environment")
    func environmentSeed() {
        #expect(Fixtures.fromEnvironment(["TESTING_AUTOMATION_SEED": "77"]).seed == 77)
        _ = Fixtures.fromEnvironment(["TESTING_AUTOMATION_SEED": "not a number"])
    }
}

@Suite("Benchmark")
struct BenchmarkTests {
    @Test("statistics of a known sample")
    func statistics() throws {
        let stats = try #require(SampleStatistics([4, 1, 3, 2, 5]))
        #expect(stats.count == 5)
        #expect(stats.minimum == 1)
        #expect(stats.maximum == 5)
        #expect(stats.mean == 3)
        #expect(stats.median == 3)
        #expect(abs(stats.standardDeviation - 1.5811) < 0.001)
        #expect(stats.percentile(25) == 2)
        #expect(stats.percentile(90) == 4.6)
        #expect(stats.percentile(-10) == 1)
        #expect(stats.percentile(500) == 5)
        #expect(stats.percentile(.nan) == nil)
    }

    @Test("drops NaN and infinity and handles extreme values")
    func robustness() throws {
        #expect(SampleStatistics([]) == nil)
        #expect(SampleStatistics([.nan, .infinity]) == nil)
        let single = try #require(SampleStatistics([.nan, 7]))
        #expect(single.count == 1)
        #expect(single.standardDeviation == 0)
        let huge = try #require(SampleStatistics([.greatestFiniteMagnitude, .greatestFiniteMagnitude]))
        #expect(huge.mean.isFinite)
    }

    @Test("measures the requested number of iterations after the warm-up")
    func measures() async throws {
        let calls = Spy<Void, Void>()
        let result = try await Benchmark.measure("sleep", iterations: 5, warmup: 2) {
            calls(())
            try await Task.sleep(for: .milliseconds(2))
        }
        #expect(calls.callCount == 7)
        #expect(result.samples.count == 5)
        #expect(result.median >= .milliseconds(2))
        #expect(!result.exceeds(median: .seconds(5)))
        #expect(result.summary.hasPrefix("sleep: median"))
    }

    @Test("clamps the iteration counts")
    func clampsIterations() async {
        let calls = Spy<Void, Void>()
        let result = await Benchmark.measure("noop", iterations: -3, warmup: -1) { calls(()) }
        #expect(result.samples.count == 1)
        #expect(calls.callCount == 1)
        #expect(Benchmark.result(label: "empty", samples: []).statistics.count == 1)
    }
}
