import Foundation

/// Runs an operation again when it fails, with a growing pause between attempts.
///
/// Use it around steps that depend on something outside the test's control, such as a test
/// server warming up. Do not use it to hide a flaky assertion: ``FlakinessAnalyzer`` reports
/// tests that only pass after a retry.
///
/// ```swift
/// let policy = RetryPolicy(maxAttempts: 4, backoff: .exponential(initial: .milliseconds(100)))
/// let token = try await policy.run { _ in try await api.signIn() }
/// ```
///
/// The initializer accepts any input and keeps it in range: `maxAttempts` is clamped to
/// 1...100, negative durations become zero, a multiplier below 1 (or NaN) becomes 1, and the
/// jitter fraction is clamped to 0...1. Delays never exceed the backoff's maximum, however many
/// attempts there are.
public struct RetryPolicy: Sendable, Equatable {
    /// How long to wait between attempts.
    public enum Backoff: Sendable, Equatable {
        /// The same pause before every retry.
        case constant(Duration)
        /// `initial`, then `initial × multiplier`, `initial × multiplier²` and so on, up to `maximum`.
        case exponential(initial: Duration, multiplier: Double = 2, maximum: Duration = .seconds(10))
    }

    /// The largest number of attempts a policy allows.
    public static let attemptLimit = 100

    /// Total attempts, including the first one.
    public let maxAttempts: Int
    public let backoff: Backoff
    /// The fraction of each delay that may be removed at random, from 0 (no jitter) to 1.
    public let jitter: Double

    public init(
        maxAttempts: Int = 3,
        backoff: Backoff = .exponential(initial: .milliseconds(200)),
        jitter: Double = 0
    ) {
        self.maxAttempts = min(max(maxAttempts, 1), Self.attemptLimit)
        self.backoff = Self.sanitized(backoff)
        self.jitter = jitter.isNaN ? 0 : min(max(jitter, 0), 1)
    }

    /// A policy that runs the operation once.
    public static let none = RetryPolicy(maxAttempts: 1, backoff: .constant(.zero))

    /// The pause before `attempt` (2 for the first retry), without jitter.
    public func delay(beforeAttempt attempt: Int) -> Duration {
        guard attempt > 1 else { return .zero }
        switch backoff {
        case .constant(let duration):
            return duration
        case .exponential(let initial, let multiplier, let maximum):
            let initialSeconds = Self.seconds(initial)
            let maximumSeconds = Self.seconds(maximum)
            // pow overflows to +infinity rather than trapping; the min() then caps it.
            let grown = initialSeconds * pow(multiplier, Double(attempt - 2))
            guard grown.isFinite, grown < maximumSeconds else { return maximum }
            return .seconds(grown)
        }
    }

    /// The pause before `attempt`, with jitter drawn from `generator`.
    public func delay(beforeAttempt attempt: Int, using generator: inout some RandomNumberGenerator) -> Duration {
        let base = delay(beforeAttempt: attempt)
        guard jitter > 0, base > .zero else { return base }
        let removed = jitter * Double.random(in: 0..<1, using: &generator)
        return base * (1 - removed)
    }

    /// Runs `operation` until it succeeds, the attempts run out or `shouldRetry` returns false.
    ///
    /// The operation receives the attempt number, starting at 1. A `CancellationError` is never
    /// retried. When every attempt fails, the last error is thrown.
    public func run<Value>(
        isolation: isolated (any Actor)? = #isolation,
        shouldRetry: (any Error) -> Bool = { _ in true },
        _ operation: (_ attempt: Int) async throws -> Value
    ) async throws -> Value {
        var generator = SystemRandomNumberGenerator()
        return try await run(clock: ContinuousClock(), generator: &generator, shouldRetry: shouldRetry, operation)
    }

    /// Runs `operation` with an injected clock and random number generator, for tests.
    public func run<Value, C: Clock>(
        clock: C,
        generator: inout some RandomNumberGenerator,
        isolation: isolated (any Actor)? = #isolation,
        shouldRetry: (any Error) -> Bool = { _ in true },
        _ operation: (_ attempt: Int) async throws -> Value
    ) async throws -> Value where C.Duration == Duration {
        var attempt = 1
        while true {
            do {
                return try await operation(attempt)
            } catch is CancellationError {
                throw CancellationError()
            } catch {
                guard attempt < maxAttempts, shouldRetry(error) else { throw error }
                attempt += 1
                let pause = delay(beforeAttempt: attempt, using: &generator)
                if pause > .zero {
                    try await clock.sleep(for: pause, tolerance: nil)
                }
            }
        }
    }

    // MARK: - Input limits

    private static func sanitized(_ backoff: Backoff) -> Backoff {
        switch backoff {
        case .constant(let duration):
            return .constant(max(duration, .zero))
        case .exponential(let initial, let multiplier, let maximum):
            let maximum = max(maximum, .zero)
            let multiplier = multiplier.isFinite && multiplier >= 1 ? multiplier : 1
            return .exponential(initial: min(max(initial, .zero), maximum), multiplier: multiplier, maximum: maximum)
        }
    }

    static func seconds(_ duration: Duration) -> Double {
        let parts = duration.components
        return Double(parts.seconds) + Double(parts.attoseconds) / 1e18
    }
}
