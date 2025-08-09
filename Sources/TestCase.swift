import Foundation

/// Basic test case structure
public struct TestCase {
    public let name: String
    public let description: String
    public let executionBlock: () async throws -> Void
    
    public init(
        name: String,
        description: String,
        executionBlock: @escaping () async throws -> Void
    ) {
        self.name = name
        self.description = description
        self.executionBlock = executionBlock
    }
}

/// Test result structure
public struct TestResult {
    public let testCase: TestCase
    public let status: TestStatus
    public let executionTime: TimeInterval
    public let error: Error?
    
    public init(
        testCase: TestCase,
        status: TestStatus,
        executionTime: TimeInterval,
        error: Error?
    ) {
        self.testCase = testCase
        self.status = status
        self.executionTime = executionTime
        self.error = error
    }
}

/// Test status enum
public enum TestStatus {
    case passed
    case failed
    case running
}
