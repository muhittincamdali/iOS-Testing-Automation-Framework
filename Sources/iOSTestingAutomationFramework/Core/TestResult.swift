import Foundation

/// The outcome of one test.
public enum TestStatus: String, Codable, Sendable, CaseIterable {
    case passed
    case failed
    case skipped
}

/// The result of running one test, as reports and the flakiness analysis read it.
///
/// Durations that are negative, NaN or infinite are stored as `0`, and `attempts` is at least
/// `1`, so a report built from these values never contains `nan` or a negative time.
public struct TestResult: Codable, Sendable, Hashable, Identifiable {
    public let id: UUID
    /// The test's name, for example `testSignIn()`.
    public let name: String
    /// The suite or class the test belongs to. Empty when unknown.
    public let suite: String
    public let status: TestStatus
    /// Wall-clock duration in seconds.
    public let duration: TimeInterval
    /// The failure or skip message, if any.
    public let errorMessage: String?
    /// How many times the test ran before this result. A pass with more than one attempt is a
    /// pass after a retry.
    public let attempts: Int

    /// Creates a result without a suite name.
    public init(name: String, status: TestStatus, duration: TimeInterval, errorMessage: String? = nil) {
        self.init(id: UUID(), name: name, suite: "", status: status, duration: duration, errorMessage: errorMessage)
    }

    /// Creates a result.
    public init(
        id: UUID = UUID(),
        name: String,
        suite: String,
        status: TestStatus,
        duration: TimeInterval,
        errorMessage: String? = nil,
        attempts: Int = 1
    ) {
        self.id = id
        self.name = name
        self.suite = suite
        self.status = status
        self.duration = Self.sanitized(duration)
        self.errorMessage = errorMessage
        self.attempts = max(1, attempts)
    }

    private enum CodingKeys: String, CodingKey {
        case id, name, suite, status, duration, errorMessage, attempts
    }

    // Decoding goes through the memberwise initializer so the same limits apply to stored reports.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            id: try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID(),
            name: try container.decode(String.self, forKey: .name),
            suite: try container.decodeIfPresent(String.self, forKey: .suite) ?? "",
            status: try container.decode(TestStatus.self, forKey: .status),
            duration: try container.decode(TimeInterval.self, forKey: .duration),
            errorMessage: try container.decodeIfPresent(String.self, forKey: .errorMessage),
            attempts: try container.decodeIfPresent(Int.self, forKey: .attempts) ?? 1
        )
    }

    private static func sanitized(_ duration: TimeInterval) -> TimeInterval {
        guard duration.isFinite, duration > 0 else { return 0 }
        return duration
    }
}
