import Foundation
import Logging

/// Test orchestrator for managing test execution flow
@available(iOS 15.0, macOS 12.0, *)
public class TestOrchestrator {
    
    // MARK: - Properties
    
    /// Logger for test orchestration
    private let logger = Logger(label: "TestOrchestrator")
    
    /// Current test execution state
    private var executionState: TestExecutionState = .idle
    
    /// Test execution queue
    private var executionQueue: [TestCase] = []
    
    /// Completed test results
    private var completedResults: [TestExecutionResult] = []
    
    /// Test execution configuration
    private var configuration: TestOrchestratorConfiguration
    
    // MARK: - Initialization
    
    /// Initialize the test orchestrator
    /// - Parameter configuration: Configuration for the orchestrator
    public init(configuration: TestOrchestratorConfiguration = TestOrchestratorConfiguration()) {
        self.configuration = configuration
        setupOrchestrator()
    }
    
    // MARK: - Public Methods
    
    /// Add test cases to the execution queue
    /// - Parameter testCases: Test cases to add
    public func addTestCases(_ testCases: [TestCase]) {
        executionQueue.append(contentsOf: testCases)
        logger.info("Added \(testCases.count) test cases to execution queue")
    }
    
    /// Clear the execution queue
    public func clearQueue() {
        executionQueue.removeAll()
        logger.info("Execution queue cleared")
    }
    
    /// Get current execution state
    /// - Returns: Current execution state
    public func getExecutionState() -> TestExecutionState {
        return executionState
    }
    
    /// Get completed test results
    /// - Returns: Array of completed test results
    public func getCompletedResults() -> [TestExecutionResult] {
        return completedResults
    }
    
    /// Get pending test cases
    /// - Returns: Array of pending test cases
    public func getPendingTestCases() -> [TestCase] {
        return executionQueue
    }
    
    /// Execute all test cases in the queue
    /// - Returns: Test execution results
    public func executeAllTests() async throws -> TestExecutionResults {
        logger.info("Starting execution of \(executionQueue.count) test cases")
        
        executionState = .running
        let startTime = Date()
        
        var results: [TestExecutionResult] = []
        
        for testCase in executionQueue {
            do {
                let result = try await executeTestCase(testCase)
                results.append(result)
                
                if result.status == .failed && configuration.stopOnFirstFailure {
                    logger.warning("Test case '\(testCase.name)' failed, stopping execution")
                    break
                }
            } catch {
                logger.error("Error executing test case '\(testCase.name)': \(error)")
                let failedResult = TestExecutionResult(
                    testCase: testCase,
                    status: .failed,
                    executionTime: 0,
                    error: error,
                    screenshotPath: nil
                )
                results.append(failedResult)
                
                if configuration.stopOnFirstFailure {
                    break
                }
            }
        }
        
        executionState = .completed
        completedResults = results
        
        let totalTime = Date().timeIntervalSince(startTime)
        logger.info("Test execution completed in \(String(format: "%.2f", totalTime))s")
        
        return TestExecutionResults(results: results)
    }
    
    /// Execute a single test case
    /// - Parameter testCase: Test case to execute
    /// - Returns: Test execution result
    public func executeTestCase(_ testCase: TestCase) async throws -> TestExecutionResult {
        logger.info("Executing test case: \(testCase.name)")
        
        let startTime = Date()
        
        // Run setup if available
        if let setupBlock = testCase.setupBlock {
            try await setupBlock()
        }
        
        // Execute the test case
        var executionError: Error?
        do {
            try await testCase.executionBlock?()
        } catch {
            executionError = error
        }
        
        // Run teardown if available
        if let teardownBlock = testCase.teardownBlock {
            try await teardownBlock()
        }
        
        let executionTime = Date().timeIntervalSince(startTime)
        let status: TestStatus = executionError == nil ? .passed : .failed
        
        let result = TestExecutionResult(
            testCase: testCase,
            status: status,
            executionTime: executionTime,
            error: executionError,
            screenshotPath: status == .failed && configuration.captureScreenshotsOnFailure ? captureScreenshot() : nil
        )
        
        logger.info("Test case '\(testCase.name)' completed with status: \(status)")
        
        return result
    }
    
    /// Retry failed test cases
    /// - Parameter maxRetries: Maximum number of retries
    /// - Returns: Updated test execution results
    public func retryFailedTests(maxRetries: Int = 3) async throws -> TestExecutionResults {
        let failedResults = completedResults.filter { $0.status == .failed }
        
        guard !failedResults.isEmpty else {
            logger.info("No failed tests to retry")
            return TestExecutionResults(results: completedResults)
        }
        
        logger.info("Retrying \(failedResults.count) failed test cases")
        
        var updatedResults = completedResults.filter { $0.status != .failed }
        
        for failedResult in failedResults {
            var retryCount = 0
            var lastError: Error?
            
            while retryCount < maxRetries {
                do {
                    let retryResult = try await executeTestCase(failedResult.testCase)
                    if retryResult.status == .passed {
                        updatedResults.append(retryResult)
                        logger.info("Test case '\(failedResult.testCase.name)' passed on retry \(retryCount + 1)")
                        break
                    } else {
                        lastError = retryResult.error
                    }
                } catch {
                    lastError = error
                }
                
                retryCount += 1
                
                if retryCount < maxRetries {
                    try await Task.sleep(nanoseconds: UInt64(configuration.retryDelay * 1_000_000_000))
                }
            }
            
            if retryCount >= maxRetries {
                let finalFailedResult = TestExecutionResult(
                    testCase: failedResult.testCase,
                    status: .failed,
                    executionTime: failedResult.executionTime,
                    error: lastError,
                    screenshotPath: failedResult.screenshotPath
                )
                updatedResults.append(finalFailedResult)
                logger.warning("Test case '\(failedResult.testCase.name)' failed after \(maxRetries) retries")
            }
        }
        
        completedResults = updatedResults
        return TestExecutionResults(results: updatedResults)
    }
    
    /// Get execution statistics
    /// - Returns: Execution statistics
    public func getExecutionStatistics() -> TestExecutionStatistics {
        let totalTests = completedResults.count
        let passedTests = completedResults.filter { $0.status == .passed }.count
        let failedTests = completedResults.filter { $0.status == .failed }.count
        let skippedTests = completedResults.filter { $0.status == .skipped }.count
        
        let totalExecutionTime = completedResults.reduce(0) { $0 + $1.executionTime }
        let averageExecutionTime = totalTests > 0 ? totalExecutionTime / Double(totalTests) : 0
        
        return TestExecutionStatistics(
            totalTests: totalTests,
            passedTests: passedTests,
            failedTests: failedTests,
            skippedTests: skippedTests,
            totalExecutionTime: totalExecutionTime,
            averageExecutionTime: averageExecutionTime,
            successRate: totalTests > 0 ? Double(passedTests) / Double(totalTests) * 100 : 0
        )
    }
    
    // MARK: - Private Methods
    
    private func setupOrchestrator() {
        logger.info("Test orchestrator initialized with configuration: \(configuration)")
    }
    
    private func captureScreenshot() -> String? {
        // Implement screenshot capture logic
        return nil
    }
}

// MARK: - Supporting Types

/// Test execution state
public enum TestExecutionState {
    case idle
    case running
    case completed
    case paused
    case cancelled
}

/// Configuration for test orchestrator
public struct TestOrchestratorConfiguration {
    /// Whether to stop execution on first failure
    public let stopOnFirstFailure: Bool
    
    /// Whether to capture screenshots on failure
    public let captureScreenshotsOnFailure: Bool
    
    /// Whether to record video during execution
    public let recordVideo: Bool
    
    /// Delay between retries in seconds
    public let retryDelay: TimeInterval
    
    /// Maximum number of concurrent executions
    public let maxConcurrentExecutions: Int
    
    /// Timeout for individual test cases
    public let testCaseTimeout: TimeInterval
    
    public init(
        stopOnFirstFailure: Bool = false,
        captureScreenshotsOnFailure: Bool = true,
        recordVideo: Bool = false,
        retryDelay: TimeInterval = 1.0,
        maxConcurrentExecutions: Int = 4,
        testCaseTimeout: TimeInterval = 30.0
    ) {
        self.stopOnFirstFailure = stopOnFirstFailure
        self.captureScreenshotsOnFailure = captureScreenshotsOnFailure
        self.recordVideo = recordVideo
        self.retryDelay = retryDelay
        self.maxConcurrentExecutions = maxConcurrentExecutions
        self.testCaseTimeout = testCaseTimeout
    }
}

/// Test execution statistics
public struct TestExecutionStatistics {
    /// Total number of tests executed
    public let totalTests: Int
    
    /// Number of tests that passed
    public let passedTests: Int
    
    /// Number of tests that failed
    public let failedTests: Int
    
    /// Number of tests that were skipped
    public let skippedTests: Int
    
    /// Total execution time in seconds
    public let totalExecutionTime: TimeInterval
    
    /// Average execution time in seconds
    public let averageExecutionTime: TimeInterval
    
    /// Success rate as percentage
    public let successRate: Double
    
    public init(
        totalTests: Int,
        passedTests: Int,
        failedTests: Int,
        skippedTests: Int,
        totalExecutionTime: TimeInterval,
        averageExecutionTime: TimeInterval,
        successRate: Double
    ) {
        self.totalTests = totalTests
        self.passedTests = passedTests
        self.failedTests = failedTests
        self.skippedTests = skippedTests
        self.totalExecutionTime = totalExecutionTime
        self.averageExecutionTime = averageExecutionTime
        self.successRate = successRate
    }
} 