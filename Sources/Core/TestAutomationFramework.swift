import Foundation
import Logging
import XCTest
import UIKit

/// Main test automation framework for iOS applications
@available(iOS 15.0, macOS 12.0, *)
public class TestAutomationFramework {
    
    // MARK: - Properties
    
    private let logger = Logger(label: "TestAutomationFramework")
    private let configuration: TestConfiguration
    private let testExecutor: TestExecutor
    private let reportGenerator: TestReportGenerator
    private let performanceMonitor: PerformanceMonitor
    
    // MARK: - Initialization
    
    public init(configuration: TestConfiguration = TestConfiguration()) {
        self.configuration = configuration
        self.testExecutor = TestExecutor(configuration: configuration)
        self.reportGenerator = TestReportGenerator()
        self.performanceMonitor = PerformanceMonitor()
        
        logger.info("TestAutomationFramework initialized with configuration: \(configuration)")
    }
    
    // MARK: - Public Methods
    
    /// Configure the framework with custom settings
    public func configure(enableParallelExecution: Bool = false,
                         maxConcurrentTests: Int = 4,
                         timeoutInterval: TimeInterval = 30.0,
                         enablePerformanceMonitoring: Bool = true) {
        
        configuration.enableParallelExecution = enableParallelExecution
        configuration.maxConcurrentTests = maxConcurrentTests
        configuration.timeoutInterval = timeoutInterval
        configuration.enablePerformanceMonitoring = enablePerformanceMonitoring
        
        logger.info("Framework configured: parallel=\(enableParallelExecution), maxConcurrent=\(maxConcurrentTests)")
    }
    
    /// Run a single test case
    public func runTest(_ testCase: TestCase) async throws -> TestResult {
        logger.info("Running test case: \(testCase.name)")
        
        let startTime = Date()
        performanceMonitor.startMonitoring()
        
        do {
            try await testExecutor.execute(testCase)
            let executionTime = Date().timeIntervalSince(startTime)
            performanceMonitor.stopMonitoring()
            
            let result = TestResult(
                testCase: testCase,
                status: .passed,
                executionTime: executionTime,
                error: nil
            )
            
            logger.info("Test passed: \(testCase.name) in \(executionTime)s")
            return result
            
        } catch {
            let executionTime = Date().timeIntervalSince(startTime)
            performanceMonitor.stopMonitoring()
            
            let result = TestResult(
                testCase: testCase,
                status: .failed,
                executionTime: executionTime,
                error: error
            )
            
            logger.error("Test failed: \(testCase.name) - \(error)")
            throw error
        }
    }
    
    /// Run a test suite
    public func runTestSuite(_ testSuite: TestSuite) async throws -> TestSuiteResults {
        logger.info("Running test suite: \(testSuite.name) with \(testSuite.testCaseCount) test cases")
        
        var results: [TestResult] = []
        
        if configuration.enableParallelExecution {
            results = try await runTestsInParallel(testSuite.testCases)
        } else {
            results = try await runTestsSequentially(testSuite.testCases)
        }
        
        let suiteResults = TestSuiteResults(results: results)
        
        logger.info("Test suite completed: \(suiteResults.passedCount)/\(suiteResults.totalCount) passed")
        return suiteResults
    }
    
    /// Run multiple test suites
    public func runTestSuites(_ testSuites: [TestSuite]) async throws -> [TestSuiteResults] {
        logger.info("Running \(testSuites.count) test suites")
        
        var allResults: [TestSuiteResults] = []
        
        for testSuite in testSuites {
            let results = try await runTestSuite(testSuite)
            allResults.append(results)
        }
        
        return allResults
    }
    
    /// Generate comprehensive test report
    public func generateReport(from results: [TestSuiteResults]) -> TestReport {
        return reportGenerator.generateReport(from: results)
    }
    
    /// Get performance metrics
    public func getPerformanceMetrics() -> PerformanceMetrics {
        return performanceMonitor.getMetrics()
    }
    
    // MARK: - Private Methods
    
    private func runTestsSequentially(_ testCases: [TestCase]) async throws -> [TestResult] {
        var results: [TestResult] = []
        
        for testCase in testCases {
            let result = try await runTest(testCase)
            results.append(result)
        }
        
        return results
    }
    
    private func runTestsInParallel(_ testCases: [TestCase]) async throws -> [TestResult] {
        let semaphore = DispatchSemaphore(value: configuration.maxConcurrentTests)
        var results: [TestResult] = []
        let queue = DispatchQueue(label: "test.execution", attributes: .concurrent)
        
        return try await withThrowingTaskGroup(of: TestResult.self) { group in
            for testCase in testCases {
                group.addTask {
                    return try await self.runTest(testCase)
                }
            }
            
            var allResults: [TestResult] = []
            for try await result in group {
                allResults.append(result)
            }
            
            return allResults
        }
    }
}

// MARK: - Test Configuration

public struct TestConfiguration {
    public var enableParallelExecution: Bool
    public var maxConcurrentTests: Int
    public var timeoutInterval: TimeInterval
    public var enablePerformanceMonitoring: Bool
    public var enableVisualTesting: Bool
    public var enableSecurityTesting: Bool
    public var enableAccessibilityTesting: Bool
    
    public init(enableParallelExecution: Bool = false,
                maxConcurrentTests: Int = 4,
                timeoutInterval: TimeInterval = 30.0,
                enablePerformanceMonitoring: Bool = true,
                enableVisualTesting: Bool = true,
                enableSecurityTesting: Bool = true,
                enableAccessibilityTesting: Bool = true) {
        
        self.enableParallelExecution = enableParallelExecution
        self.maxConcurrentTests = maxConcurrentTests
        self.timeoutInterval = timeoutInterval
        self.enablePerformanceMonitoring = enablePerformanceMonitoring
        self.enableVisualTesting = enableVisualTesting
        self.enableSecurityTesting = enableSecurityTesting
        self.enableAccessibilityTesting = enableAccessibilityTesting
    }
}

// MARK: - Test Report

public struct TestReport {
    public let totalTests: Int
    public let passedTests: Int
    public let failedTests: Int
    public let successRate: Double
    public let totalExecutionTime: TimeInterval
    public let performanceMetrics: PerformanceMetrics
    public let detailedResults: [TestResult]
    
    public init(totalTests: Int,
                passedTests: Int,
                failedTests: Int,
                successRate: Double,
                totalExecutionTime: TimeInterval,
                performanceMetrics: PerformanceMetrics,
                detailedResults: [TestResult]) {
        
        self.totalTests = totalTests
        self.passedTests = passedTests
        self.failedTests = failedTests
        self.successRate = successRate
        self.totalExecutionTime = totalExecutionTime
        self.performanceMetrics = performanceMetrics
        self.detailedResults = detailedResults
    }
} 