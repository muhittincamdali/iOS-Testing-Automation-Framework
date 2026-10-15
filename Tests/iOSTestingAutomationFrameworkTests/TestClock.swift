import Foundation

/// A clock whose sleeps return immediately and move its time forward, so time-based code can
/// be tested without waiting.
final class TestClock: Clock, @unchecked Sendable {
    struct Instant: InstantProtocol {
        var offset: Duration

        func advanced(by duration: Duration) -> Instant { Instant(offset: offset + duration) }
        func duration(to other: Instant) -> Duration { other.offset - offset }
        static func < (lhs: Instant, rhs: Instant) -> Bool { lhs.offset < rhs.offset }
    }

    // Tests drive the clock from one task at a time; the lock keeps the sleeps list consistent.
    private let lock = NSLock()
    private var current = Instant(offset: .zero)
    private var recordedSleeps: [Duration] = []

    var now: Instant { lock.withLock { current } }
    var minimumResolution: Duration { .nanoseconds(1) }
    var sleeps: [Duration] { lock.withLock { recordedSleeps } }

    func sleep(until deadline: Instant, tolerance: Duration?) async throws {
        try Task.checkCancellation()
        lock.withLock {
            recordedSleeps.append(current.duration(to: deadline))
            if deadline > current { current = deadline }
        }
    }

    func advance(by duration: Duration) {
        lock.withLock { current = current.advanced(by: duration) }
    }
}
