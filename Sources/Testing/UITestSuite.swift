import Foundation
import XCTest
import UIKit

/// UI Test Suite for managing UI automation tests
@available(iOS 15.0, macOS 12.0, *)
public class UITestSuite {
    
    // MARK: - Properties
    
    private let logger = Logger(label: "UITestSuite")
    private var testCases: [UITestCase] = []
    private let configuration: UITestConfiguration
    
    // MARK: - Initialization
    
    public init(configuration: UITestConfiguration = UITestConfiguration()) {
        self.configuration = configuration
        logger.info("UITestSuite initialized")
    }
    
    // MARK: - Public Methods
    
    /// Add a UI test case to the suite
    public func addTest(_ testCase: UITestCase) {
        testCases.append(testCase)
        logger.debug("Added UI test case: \(testCase.name)")
    }
    
    /// Add multiple UI test cases to the suite
    public func addTests(_ testCases: [UITestCase]) {
        self.testCases.append(contentsOf: testCases)
        logger.debug("Added \(testCases.count) UI test cases")
    }
    
    /// Remove a test case from the suite
    public func removeTest(withName name: String) {
        testCases.removeAll { $0.name == name }
        logger.debug("Removed UI test case: \(name)")
    }
    
    /// Get all test cases in the suite
    public func getAllTests() -> [UITestCase] {
        return testCases
    }
    
    /// Get test cases by category
    public func getTests(byCategory category: UITestCategory) -> [UITestCase] {
        return testCases.filter { $0.category == category }
    }
    
    /// Get test cases by priority
    public func getTests(byPriority priority: UITestPriority) -> [UITestCase] {
        return testCases.filter { $0.priority == priority }
    }
    
    /// Run all tests in the suite
    public func runAllTests() async throws -> UITestSuiteResults {
        logger.info("Running all UI tests in suite (\(testCases.count) tests)")
        
        var results: [UITestResult] = []
        
        for testCase in testCases {
            let result = try await runTest(testCase)
            results.append(result)
        }
        
        let suiteResults = UITestSuiteResults(results: results)
        
        logger.info("UI test suite completed: \(suiteResults.passedCount)/\(suiteResults.totalCount) passed")
        return suiteResults
    }
    
    /// Run tests by category
    public func runTests(byCategory category: UITestCategory) async throws -> UITestSuiteResults {
        let categoryTests = getTests(byCategory: category)
        logger.info("Running UI tests for category: \(category) (\(categoryTests.count) tests)")
        
        var results: [UITestResult] = []
        
        for testCase in categoryTests {
            let result = try await runTest(testCase)
            results.append(result)
        }
        
        let suiteResults = UITestSuiteResults(results: results)
        
        logger.info("Category tests completed: \(suiteResults.passedCount)/\(suiteResults.totalCount) passed")
        return suiteResults
    }
    
    /// Run tests by priority
    public func runTests(byPriority priority: UITestPriority) async throws -> UITestSuiteResults {
        let priorityTests = getTests(byPriority: priority)
        logger.info("Running UI tests for priority: \(priority) (\(priorityTests.count) tests)")
        
        var results: [UITestResult] = []
        
        for testCase in priorityTests {
            let result = try await runTest(testCase)
            results.append(result)
        }
        
        let suiteResults = UITestSuiteResults(results: results)
        
        logger.info("Priority tests completed: \(suiteResults.passedCount)/\(suiteResults.totalCount) passed")
        return suiteResults
    }
    
    /// Run a single UI test
    public func runTest(_ testCase: UITestCase) async throws -> UITestResult {
        logger.info("Running UI test: \(testCase.name)")
        
        let startTime = Date()
        
        do {
            try await testCase.execute()
            let executionTime = Date().timeIntervalSince(startTime)
            
            let result = UITestResult(
                testCase: testCase,
                status: .passed,
                executionTime: executionTime,
                error: nil,
                screenshots: testCase.screenshots
            )
            
            logger.info("UI test passed: \(testCase.name) in \(executionTime)s")
            return result
            
        } catch {
            let executionTime = Date().timeIntervalSince(startTime)
            
            let result = UITestResult(
                testCase: testCase,
                status: .failed,
                executionTime: executionTime,
                error: error,
                screenshots: testCase.screenshots
            )
            
            logger.error("UI test failed: \(testCase.name) - \(error)")
            return result
        }
    }
    
    /// Clear all test cases from the suite
    public func clearTests() {
        testCases.removeAll()
        logger.info("Cleared all UI test cases from suite")
    }
    
    /// Get test suite statistics
    public func getStatistics() -> UITestSuiteStatistics {
        let totalTests = testCases.count
        let categories = Set(testCases.map { $0.category })
        let priorities = Set(testCases.map { $0.priority })
        
        let categoryBreakdown = Dictionary(grouping: testCases, by: { $0.category })
            .mapValues { $0.count }
        
        let priorityBreakdown = Dictionary(grouping: testCases, by: { $0.priority })
            .mapValues { $0.count }
        
        return UITestSuiteStatistics(
            totalTests: totalTests,
            uniqueCategories: categories.count,
            uniquePriorities: priorities.count,
            categoryBreakdown: categoryBreakdown,
            priorityBreakdown: priorityBreakdown
        )
    }
}

// MARK: - UI Test Case

public struct UITestCase {
    public let name: String
    public let description: String
    public let category: UITestCategory
    public let priority: UITestPriority
    public let executionBlock: () async throws -> Void
    public var screenshots: [String] = []
    
    public init(
        name: String,
        description: String,
        category: UITestCategory,
        priority: UITestPriority,
        executionBlock: @escaping () async throws -> Void
    ) {
        self.name = name
        self.description = description
        self.category = category
        self.priority = priority
        self.executionBlock = executionBlock
    }
    
    public func execute() async throws {
        try await executionBlock()
    }
    
    public mutating func addScreenshot(_ path: String) {
        screenshots.append(path)
    }
}

// MARK: - UI Test Result

public struct UITestResult {
    public let testCase: UITestCase
    public let status: UITestStatus
    public let executionTime: TimeInterval
    public let error: Error?
    public let screenshots: [String]
    
    public init(
        testCase: UITestCase,
        status: UITestStatus,
        executionTime: TimeInterval,
        error: Error?,
        screenshots: [String]
    ) {
        self.testCase = testCase
        self.status = status
        self.executionTime = executionTime
        self.error = error
        self.screenshots = screenshots
    }
}

// MARK: - UI Test Suite Results

public struct UITestSuiteResults {
    public let results: [UITestResult]
    
    public var passedCount: Int {
        results.filter { $0.status == .passed }.count
    }
    
    public var failedCount: Int {
        results.filter { $0.status == .failed }.count
    }
    
    public var totalCount: Int {
        results.count
    }
    
    public var successRate: Double {
        guard totalCount > 0 else { return 0.0 }
        return Double(passedCount) / Double(totalCount) * 100.0
    }
    
    public var totalExecutionTime: TimeInterval {
        results.reduce(0) { $0 + $1.executionTime }
    }
    
    public var averageExecutionTime: TimeInterval {
        guard totalCount > 0 else { return 0.0 }
        return totalExecutionTime / Double(totalCount)
    }
    
    public init(results: [UITestResult]) {
        self.results = results
    }
}

// MARK: - UI Test Configuration

public struct UITestConfiguration {
    public var enableScreenshots: Bool
    public var screenshotQuality: ScreenshotQuality
    public var enableVideoRecording: Bool
    public var enableAccessibilityTesting: Bool
    public var enableVisualTesting: Bool
    public var timeoutInterval: TimeInterval
    public var retryCount: Int
    
    public init(
        enableScreenshots: Bool = true,
        screenshotQuality: ScreenshotQuality = .high,
        enableVideoRecording: Bool = false,
        enableAccessibilityTesting: Bool = true,
        enableVisualTesting: Bool = true,
        timeoutInterval: TimeInterval = 30.0,
        retryCount: Int = 3
    ) {
        self.enableScreenshots = enableScreenshots
        self.screenshotQuality = screenshotQuality
        self.enableVideoRecording = enableVideoRecording
        self.enableAccessibilityTesting = enableAccessibilityTesting
        self.enableVisualTesting = enableVisualTesting
        self.timeoutInterval = timeoutInterval
        self.retryCount = retryCount
    }
}

// MARK: - Supporting Types

public enum UITestCategory {
    case navigation
    case authentication
    case dataEntry
    case validation
    case performance
    case accessibility
    case visual
    case integration
    case regression
    case smoke
}

public enum UITestPriority {
    case critical
    case high
    case medium
    case low
}

public enum UITestStatus {
    case passed
    case failed
    case skipped
    case running
}

public enum ScreenshotQuality {
    case low
    case medium
    case high
    case ultra
}

// MARK: - UI Test Suite Statistics

public struct UITestSuiteStatistics {
    public let totalTests: Int
    public let uniqueCategories: Int
    public let uniquePriorities: Int
    public let categoryBreakdown: [UITestCategory: Int]
    public let priorityBreakdown: [UITestPriority: Int]
    
    public init(
        totalTests: Int,
        uniqueCategories: Int,
        uniquePriorities: Int,
        categoryBreakdown: [UITestCategory: Int],
        priorityBreakdown: [UITestPriority: Int]
    ) {
        self.totalTests = totalTests
        self.uniqueCategories = uniqueCategories
        self.uniquePriorities = uniquePriorities
        self.categoryBreakdown = categoryBreakdown
        self.priorityBreakdown = priorityBreakdown
    }
} 