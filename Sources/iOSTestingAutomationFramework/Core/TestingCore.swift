import Foundation

/// Main testing automation framework namespace
public enum TestingAutomation {
    public static let version = "2.0.0"
}

/// Generic test status
public enum TestStatus: String, Codable, Sendable {
    case passed
    case failed
    case skipped
}

/// Result of a single test execution
public struct TestResult: Codable, Sendable {
    public let id: UUID
    public let name: String
    public let status: TestStatus
    public let duration: TimeInterval
    public let errorMessage: String?
    
    public init(name: String, status: TestStatus, duration: TimeInterval, errorMessage: String? = nil) {
        self.id = UUID()
        self.name = name
        self.status = status
        self.duration = duration
        self.errorMessage = errorMessage
    }
}
