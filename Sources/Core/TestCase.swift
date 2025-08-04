import Foundation
import XCTest

/// Represents a single test case in the testing framework
public struct TestCase {
    public let id: String
    public let name: String
    public let description: String
    public let category: TestCategory
    public let priority: TestPriority
    public let tags: Set<String>
    public let executionBlock: (() async throws -> Void)?
    public let setupBlock: (() async throws -> Void)?
    public let teardownBlock: (() async throws -> Void)?
    public let expectedExecutionTime: TimeInterval
    public let isEnabled: Bool
    public let customData: [String: Any]
    
    public init(
        id: String = UUID().uuidString,
        name: String,
        description: String,
        category: TestCategory = .functional,
        priority: TestPriority = .medium,
        tags: Set<String> = [],
        executionBlock: (() async throws -> Void)? = nil,
        setupBlock: (() async throws -> Void)? = nil,
        teardownBlock: (() async throws -> Void)? = nil,
        expectedExecutionTime: TimeInterval = 30.0,
        isEnabled: Bool = true,
        customData: [String: Any] = [:]
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.category = category
        self.priority = priority
        self.tags = tags
        self.executionBlock = executionBlock
        self.setupBlock = setupBlock
        self.teardownBlock = teardownBlock
        self.expectedExecutionTime = expectedExecutionTime
        self.isEnabled = isEnabled
        self.customData = customData
    }
}

/// Represents a collection of test cases organized into a suite
public struct TestSuite {
    public let id: String
    public let name: String
    public let description: String
    public let testCases: [TestCase]
    public let configuration: TestSuiteConfiguration
    public let tags: Set<String>
    public let isEnabled: Bool
    public let customData: [String: Any]
    
    public init(
        id: String = UUID().uuidString,
        name: String,
        description: String,
        testCases: [TestCase] = [],
        configuration: TestSuiteConfiguration = TestSuiteConfiguration(),
        tags: Set<String> = [],
        isEnabled: Bool = true,
        customData: [String: Any] = [:]
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.testCases = testCases
        self.configuration = configuration
        self.tags = tags
        self.isEnabled = isEnabled
        self.customData = customData
    }
    
    public var testCaseCount: Int { testCases.count }
    public var enabledTestCaseCount: Int { testCases.filter { $0.isEnabled }.count }
    public var disabledTestCaseCount: Int { testCases.filter { !$0.isEnabled }.count }
    public var totalExpectedExecutionTime: TimeInterval { testCases.reduce(0) { $0 + $1.expectedExecutionTime } }
    
    public func addTestCase(_ testCase: TestCase) -> TestSuite {
        return TestSuite(
            id: id,
            name: name,
            description: description,
            testCases: testCases + [testCase],
            configuration: configuration,
            tags: tags,
            isEnabled: isEnabled,
            customData: customData
        )
    }
    
    public func testCases(in category: TestCategory) -> [TestCase] {
        return testCases.filter { $0.category == category }
    }
    
    public func enabledTestCases() -> [TestCase] {
        return testCases.filter { $0.isEnabled }
    }
}

/// Categories for test cases
public enum TestCategory: String, CaseIterable {
    case functional = "functional"
    case performance = "performance"
    case security = "security"
    case ui = "ui"
    case integration = "integration"
    case unit = "unit"
    case smoke = "smoke"
    case regression = "regression"
    case accessibility = "accessibility"
    case visual = "visual"
    
    public var displayName: String { rawValue.capitalized }
}

/// Priority levels for test cases
public enum TestPriority: String, CaseIterable, Comparable {
    case critical = "critical"
    case high = "high"
    case medium = "medium"
    case low = "low"
    case lowest = "lowest"
    
    public var displayName: String { rawValue.capitalized }
    
    public static func < (lhs: TestPriority, rhs: TestPriority) -> Bool {
        let order: [TestPriority] = [.critical, .high, .medium, .low, .lowest]
        guard let lhsIndex = order.firstIndex(of: lhs),
              let rhsIndex = order.firstIndex(of: rhs) else { return false }
        return lhsIndex < rhsIndex
    }
}

/// Configuration for test suites
public struct TestSuiteConfiguration {
    public let enableParallelExecution: Bool
    public let maxConcurrentExecutions: Int
    public let stopOnFirstFailure: Bool
    public let retryFailedTests: Bool
    public let maxRetryCount: Int
    public let timeout: TimeInterval
    public let generateDetailedReports: Bool
    public let captureScreenshotsOnFailure: Bool
    public let recordVideo: Bool
    
    public init(
        enableParallelExecution: Bool = true,
        maxConcurrentExecutions: Int = 4,
        stopOnFirstFailure: Bool = false,
        retryFailedTests: Bool = true,
        maxRetryCount: Int = 3,
        timeout: TimeInterval = 300.0,
        generateDetailedReports: Bool = true,
        captureScreenshotsOnFailure: Bool = true,
        recordVideo: Bool = false
    ) {
        self.enableParallelExecution = enableParallelExecution
        self.maxConcurrentExecutions = maxConcurrentExecutions
        self.stopOnFirstFailure = stopOnFirstFailure
        self.retryFailedTests = retryFailedTests
        self.maxRetryCount = maxRetryCount
        self.timeout = timeout
        self.generateDetailedReports = generateDetailedReports
        self.captureScreenshotsOnFailure = captureScreenshotsOnFailure
        self.recordVideo = recordVideo
    }
} 