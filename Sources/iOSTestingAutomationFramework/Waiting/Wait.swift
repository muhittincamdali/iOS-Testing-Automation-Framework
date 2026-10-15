import Foundation

/// Polls a condition until it holds or a timeout passes. Use it in unit tests for code that
/// finishes on its own schedule: a view model that loads in a task, a debounced search, a
/// notification posted from another queue.
///
/// ```swift
/// try await Wait.until { await model.isLoaded }
/// let user = try await Wait.value { await cache.user(id: 7) }
/// ```
///
/// The condition is checked once right away and then after every polling interval. The last
/// check happens at the deadline, so a condition that becomes true just before the timeout is
/// still seen. A negative timeout is treated as zero, and an interval shorter than one
/// millisecond is raised to one millisecond so the loop never spins.
public enum Wait {
    /// The default timeout: five seconds.
    public static let defaultTimeout: Duration = .seconds(5)
    /// The default polling interval: 20 milliseconds.
    public static let defaultInterval: Duration = .milliseconds(20)

    /// Thrown when the condition does not hold before the timeout.
    public struct TimeoutError: Error, CustomStringConvertible, Equatable {
        /// What was being waited for.
        public let message: String
        /// The timeout that passed.
        public let timeout: Duration
        /// How many times the condition was checked.
        public let checks: Int

        public var description: String {
            "Timed out after \(timeout) waiting for \(message) (checked \(checks) times)"
        }
    }

    /// Waits until `condition` returns `true`.
    ///
    /// - Throws: ``TimeoutError`` when the timeout passes, `CancellationError` when the task is
    ///   cancelled, or any error the condition throws.
    public static func until(
        _ message: @autoclosure () -> String = "the condition",
        timeout: Duration = defaultTimeout,
        pollingEvery interval: Duration = defaultInterval,
        isolation: isolated (any Actor)? = #isolation,
        _ condition: () async throws -> Bool
    ) async throws {
        _ = try await value(message(), timeout: timeout, pollingEvery: interval, clock: ContinuousClock()) {
            try await condition() ? true : nil
        }
    }

    /// Waits until `produce` returns a value other than `nil`, and returns it.
    public static func value<Value>(
        _ message: @autoclosure () -> String = "a value",
        timeout: Duration = defaultTimeout,
        pollingEvery interval: Duration = defaultInterval,
        isolation: isolated (any Actor)? = #isolation,
        _ produce: () async throws -> Value?
    ) async throws -> Value {
        try await value(message(), timeout: timeout, pollingEvery: interval, clock: ContinuousClock(), produce)
    }

    /// Waits until `produce` returns a value, measuring time with `clock`.
    ///
    /// Pass a test clock to make a wait deterministic.
    public static func value<Value, C: Clock>(
        _ message: @autoclosure () -> String = "a value",
        timeout: Duration = defaultTimeout,
        pollingEvery interval: Duration = defaultInterval,
        clock: C,
        isolation: isolated (any Actor)? = #isolation,
        _ produce: () async throws -> Value?
    ) async throws -> Value where C.Duration == Duration {
        let timeout = max(timeout, .zero)
        let interval = max(interval, .milliseconds(1))
        let deadline = clock.now.advanced(by: timeout)
        var checks = 0
        while true {
            try Task.checkCancellation()
            checks += 1
            if let value = try await produce() {
                return value
            }
            let now = clock.now
            guard now < deadline else {
                throw TimeoutError(message: message(), timeout: timeout, checks: checks)
            }
            // Sleep a full interval, or only up to the deadline for the final check.
            let remaining = now.duration(to: deadline)
            try await clock.sleep(for: min(interval, remaining), tolerance: nil)
        }
    }
}
