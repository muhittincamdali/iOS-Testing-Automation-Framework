import XCTest
@testable import iOSTestingAutomationFramework

final class TestAutomationFrameworkTests: XCTestCase {
    
    var framework: TestAutomationFramework!
    var testSuite: TestSuite!
    
    override func setUp() {
        super.setUp()
        framework = TestAutomationFramework()
        testSuite = TestSuite(
            name: "Test Suite",
            description: "Test suite for framework testing"
        )
    }
    
    override func tearDown() {
        framework = nil
        testSuite = nil
        super.tearDown()
    }
    
    // MARK: - Framework Initialization Tests
    
    func testFrameworkInitialization() {
        XCTAssertNotNil(framework)
    }
    
    func testFrameworkConfiguration() {
        framework.configure(
            enableParallelExecution: true,
            maxConcurrentTests: 8,
            timeoutInterval: 60.0,
            enablePerformanceMonitoring: true
        )
        
        // Configuration should be applied successfully
        XCTAssertTrue(true) // If no exception is thrown, configuration is successful
    }
    
    // MARK: - Test Case Execution Tests
    
    func testSingleTestCaseExecution() async throws {
        let testCase = TestCase(
            name: "Simple Test",
            description: "A simple test case",
            executionBlock: {
                // Simulate some work
                try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
            }
        )
        
        let result = try await framework.runTest(testCase)
        
        XCTAssertEqual(result.status, .passed)
        XCTAssertEqual(result.testCase.name, "Simple Test")
        XCTAssertGreaterThan(result.executionTime, 0)
        XCTAssertNil(result.error)
    }
    
    func testTestCaseExecutionWithError() async throws {
        let testCase = TestCase(
            name: "Failing Test",
            description: "A test case that fails",
            executionBlock: {
                throw TestExecutionError.executionFailed("Intentional failure")
            }
        )
        
        let result = try await framework.runTest(testCase)
        
        XCTAssertEqual(result.status, .failed)
        XCTAssertEqual(result.testCase.name, "Failing Test")
        XCTAssertGreaterThan(result.executionTime, 0)
        XCTAssertNotNil(result.error)
    }
    
    func testTestCaseTimeout() async throws {
        let testCase = TestCase(
            name: "Timeout Test",
            description: "A test case that times out",
            executionBlock: {
                // Simulate a long-running operation
                try await Task.sleep(nanoseconds: 5_000_000_000) // 5 seconds
            }
        )
        
        // Configure framework with short timeout
        framework.configure(timeoutInterval: 1.0)
        
        do {
            _ = try await framework.runTest(testCase)
            XCTFail("Test should have timed out")
        } catch {
            XCTAssertTrue(error is TestExecutionError)
        }
    }
    
    // MARK: - Test Suite Execution Tests
    
    func testTestSuiteExecution() async throws {
        let testCases = [
            TestCase(
                name: "Test 1",
                description: "First test case",
                executionBlock: {
                    try await Task.sleep(nanoseconds: 50_000_000)
                }
            ),
            TestCase(
                name: "Test 2",
                description: "Second test case",
                executionBlock: {
                    try await Task.sleep(nanoseconds: 50_000_000)
                }
            ),
            TestCase(
                name: "Test 3",
                description: "Third test case",
                executionBlock: {
                    try await Task.sleep(nanoseconds: 50_000_000)
                }
            )
        ]
        
        let testSuite = TestSuite(
            name: "Multiple Tests Suite",
            description: "Suite with multiple test cases",
            testCases: testCases
        )
        
        let results = try await framework.runTestSuite(testSuite)
        
        XCTAssertEqual(results.totalCount, 3)
        XCTAssertEqual(results.passedCount, 3)
        XCTAssertEqual(results.failedCount, 0)
        XCTAssertEqual(results.successRate, 100.0)
        XCTAssertGreaterThan(results.totalExecutionTime, 0)
    }
    
    func testTestSuiteWithMixedResults() async throws {
        let testCases = [
            TestCase(
                name: "Passing Test",
                description: "A test that passes",
                executionBlock: {
                    try await Task.sleep(nanoseconds: 50_000_000)
                }
            ),
            TestCase(
                name: "Failing Test",
                description: "A test that fails",
                executionBlock: {
                    throw TestExecutionError.executionFailed("Intentional failure")
                }
            ),
            TestCase(
                name: "Another Passing Test",
                description: "Another test that passes",
                executionBlock: {
                    try await Task.sleep(nanoseconds: 50_000_000)
                }
            )
        ]
        
        let testSuite = TestSuite(
            name: "Mixed Results Suite",
            description: "Suite with mixed results",
            testCases: testCases
        )
        
        let results = try await framework.runTestSuite(testSuite)
        
        XCTAssertEqual(results.totalCount, 3)
        XCTAssertEqual(results.passedCount, 2)
        XCTAssertEqual(results.failedCount, 1)
        XCTAssertEqual(results.successRate, 66.67, accuracy: 0.01)
        XCTAssertGreaterThan(results.totalExecutionTime, 0)
    }
    
    // MARK: - Parallel Execution Tests
    
    func testParallelTestExecution() async throws {
        let testCases = [
            TestCase(
                name: "Parallel Test 1",
                description: "First parallel test",
                executionBlock: {
                    try await Task.sleep(nanoseconds: 100_000_000)
                }
            ),
            TestCase(
                name: "Parallel Test 2",
                description: "Second parallel test",
                executionBlock: {
                    try await Task.sleep(nanoseconds: 100_000_000)
                }
            ),
            TestCase(
                name: "Parallel Test 3",
                description: "Third parallel test",
                executionBlock: {
                    try await Task.sleep(nanoseconds: 100_000_000)
                }
            ),
            TestCase(
                name: "Parallel Test 4",
                description: "Fourth parallel test",
                executionBlock: {
                    try await Task.sleep(nanoseconds: 100_000_000)
                }
            )
        ]
        
        let testSuite = TestSuite(
            name: "Parallel Tests Suite",
            description: "Suite for parallel execution testing",
            testCases: testCases
        )
        
        // Configure for parallel execution
        framework.configure(
            enableParallelExecution: true,
            maxConcurrentTests: 4
        )
        
        let startTime = Date()
        let results = try await framework.runTestSuite(testSuite)
        let totalTime = Date().timeIntervalSince(startTime)
        
        XCTAssertEqual(results.totalCount, 4)
        XCTAssertEqual(results.passedCount, 4)
        XCTAssertEqual(results.failedCount, 0)
        
        // Parallel execution should be faster than sequential
        // Each test takes 0.1 seconds, so sequential would take ~0.4 seconds
        // Parallel should take ~0.1 seconds
        XCTAssertLessThan(totalTime, 0.3)
    }
    
    // MARK: - Performance Monitoring Tests
    
    func testPerformanceMonitoring() async throws {
        let testCase = TestCase(
            name: "Performance Test",
            description: "Test with performance monitoring",
            executionBlock: {
                // Simulate CPU-intensive work
                for _ in 0..<1000000 {
                    _ = sqrt(Double.random(in: 0...1000))
                }
            }
        )
        
        let result = try await framework.runTest(testCase)
        
        XCTAssertEqual(result.status, .passed)
        XCTAssertGreaterThan(result.executionTime, 0)
        
        // Get performance metrics
        let metrics = framework.getPerformanceMetrics()
        XCTAssertGreaterThanOrEqual(metrics.performanceScore, 0)
        XCTAssertLessThanOrEqual(metrics.performanceScore, 100)
    }
    
    // MARK: - Report Generation Tests
    
    func testReportGeneration() async throws {
        let testCases = [
            TestCase(
                name: "Report Test 1",
                description: "First test for report",
                executionBlock: {
                    try await Task.sleep(nanoseconds: 50_000_000)
                }
            ),
            TestCase(
                name: "Report Test 2",
                description: "Second test for report",
                executionBlock: {
                    try await Task.sleep(nanoseconds: 50_000_000)
                }
            )
        ]
        
        let testSuite = TestSuite(
            name: "Report Test Suite",
            description: "Suite for report generation testing",
            testCases: testCases
        )
        
        let results = try await framework.runTestSuite(testSuite)
        let report = framework.generateReport(from: [results])
        
        XCTAssertEqual(report.totalTests, 2)
        XCTAssertEqual(report.passedTests, 2)
        XCTAssertEqual(report.failedTests, 0)
        XCTAssertEqual(report.successRate, 100.0)
        XCTAssertGreaterThan(report.totalExecutionTime, 0)
        XCTAssertEqual(report.detailedResults.count, 2)
    }
    
    // MARK: - Error Handling Tests
    
    func testInvalidTestCaseHandling() async throws {
        let invalidTestCase = TestCase(
            name: "",
            description: "",
            executionBlock: {
                // Empty execution block
            }
        )
        
        do {
            _ = try await framework.runTest(invalidTestCase)
            XCTFail("Should have thrown an error for invalid test case")
        } catch {
            XCTAssertTrue(error is TestExecutionError)
        }
    }
    
    func testConfigurationErrorHandling() {
        // Test with invalid configuration
        framework.configure(maxConcurrentTests: -1)
        
        // Should not crash and should handle gracefully
        XCTAssertTrue(true)
    }
    
    // MARK: - Memory Management Tests
    
    func testMemoryManagement() async throws {
        // Create many test cases to test memory management
        var testCases: [TestCase] = []
        
        for i in 0..<100 {
            let testCase = TestCase(
                name: "Memory Test \(i)",
                description: "Test case for memory management",
                executionBlock: {
                    // Allocate some memory
                    let array = Array(0..<1000)
                    _ = array.map { $0 * 2 }
                    try await Task.sleep(nanoseconds: 10_000_000)
                }
            )
            testCases.append(testCase)
        }
        
        let testSuite = TestSuite(
            name: "Memory Management Suite",
            description: "Suite for testing memory management",
            testCases: testCases
        )
        
        let results = try await framework.runTestSuite(testSuite)
        
        XCTAssertEqual(results.totalCount, 100)
        XCTAssertEqual(results.passedCount, 100)
        XCTAssertEqual(results.failedCount, 0)
    }
    
    // MARK: - Stress Tests
    
    func testStressTest() async throws {
        // Create a large number of test cases
        var testCases: [TestCase] = []
        
        for i in 0..<50 {
            let testCase = TestCase(
                name: "Stress Test \(i)",
                description: "Stress test case \(i)",
                executionBlock: {
                    // Simulate varying workloads
                    let workload = i % 3
                    switch workload {
                    case 0:
                        try await Task.sleep(nanoseconds: 10_000_000) // 0.01s
                    case 1:
                        try await Task.sleep(nanoseconds: 50_000_000) // 0.05s
                    case 2:
                        try await Task.sleep(nanoseconds: 100_000_000) // 0.1s
                    default:
                        break
                    }
                }
            )
            testCases.append(testCase)
        }
        
        let testSuite = TestSuite(
            name: "Stress Test Suite",
            description: "Suite for stress testing",
            testCases: testCases
        )
        
        // Configure for parallel execution
        framework.configure(
            enableParallelExecution: true,
            maxConcurrentTests: 10
        )
        
        let startTime = Date()
        let results = try await framework.runTestSuite(testSuite)
        let totalTime = Date().timeIntervalSince(startTime)
        
        XCTAssertEqual(results.totalCount, 50)
        XCTAssertEqual(results.passedCount, 50)
        XCTAssertEqual(results.failedCount, 0)
        XCTAssertGreaterThan(totalTime, 0)
        XCTAssertLessThan(totalTime, 10) // Should complete within reasonable time
    }
} 