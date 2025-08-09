# Test Framework API

<!-- TOC START -->
## Table of Contents
- [Test Framework API](#test-framework-api)
- [Overview](#overview)
- [Core Test Framework](#core-test-framework)
  - [Test Manager](#test-manager)
  - [Test Case](#test-case)
  - [Test Suite](#test-suite)
- [Test Runner](#test-runner)
  - [Test Runner Implementation](#test-runner-implementation)
- [Test Configuration](#test-configuration)
  - [Configuration Management](#configuration-management)
- [Test Coverage](#test-coverage)
  - [Coverage Analysis](#coverage-analysis)
- [Test Reporting](#test-reporting)
  - [Report Generator](#report-generator)
- [Testing](#testing)
  - [Framework Tests](#framework-tests)
- [Best Practices](#best-practices)
<!-- TOC END -->


## Overview

The Test Framework API provides the core testing infrastructure for iOS applications. It includes test case management, test execution, reporting, and integration with various testing tools.

## Core Test Framework

### Test Manager

```swift
protocol TestManager {
    func runTests(_ tests: [TestCase]) async throws -> TestResult
    func runTestSuite(_ suite: TestSuite) async throws -> TestSuiteResult
    func generateReport(_ results: TestResult) async throws -> TestReport
    func configure(_ configuration: TestConfiguration) async throws
}

class TestManagerImpl: TestManager {
    private let testRunner: TestRunner
    private let reportGenerator: ReportGenerator
    private let configuration: TestConfiguration
    
    init(testRunner: TestRunner, reportGenerator: ReportGenerator, configuration: TestConfiguration) {
        self.testRunner = testRunner
        self.reportGenerator = reportGenerator
        self.configuration = configuration
    }
    
    func runTests(_ tests: [TestCase]) async throws -> TestResult {
        let startTime = Date()
        var passedTests: [TestCase] = []
        var failedTests: [TestCase] = []
        var skippedTests: [TestCase] = []
        
        for test in tests {
            do {
                let result = try await testRunner.runTest(test)
                switch result.status {
                case .passed:
                    passedTests.append(test)
                case .failed:
                    failedTests.append(test)
                case .skipped:
                    skippedTests.append(test)
                }
            } catch {
                failedTests.append(test)
            }
        }
        
        let endTime = Date()
        let duration = endTime.timeIntervalSince(startTime)
        
        return TestResult(
            passedTests: passedTests,
            failedTests: failedTests,
            skippedTests: skippedTests,
            duration: duration,
            timestamp: startTime
        )
    }
    
    func runTestSuite(_ suite: TestSuite) async throws -> TestSuiteResult {
        let results = try await runTests(suite.tests)
        
        return TestSuiteResult(
            suite: suite,
            result: results,
            coverage: calculateCoverage(results)
        )
    }
    
    func generateReport(_ results: TestResult) async throws -> TestReport {
        return try await reportGenerator.generateReport(results)
    }
    
    func configure(_ configuration: TestConfiguration) async throws {
        // Apply configuration settings
        try await testRunner.configure(configuration)
        try await reportGenerator.configure(configuration)
    }
    
    private func calculateCoverage(_ results: TestResult) -> TestCoverage {
        let totalTests = results.passedTests.count + results.failedTests.count + results.skippedTests.count
        let passedPercentage = Double(results.passedTests.count) / Double(totalTests) * 100
        
        return TestCoverage(
            totalTests: totalTests,
            passedTests: results.passedTests.count,
            failedTests: results.failedTests.count,
            skippedTests: results.skippedTests.count,
            passedPercentage: passedPercentage
        )
    }
}
```

### Test Case

```swift
struct TestCase: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let category: TestCategory
    let priority: TestPriority
    let timeout: TimeInterval
    let dependencies: [UUID]
    let tags: [String]
    
    init(name: String, description: String, category: TestCategory, priority: TestPriority = .medium, timeout: TimeInterval = 30.0, dependencies: [UUID] = [], tags: [String] = []) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.category = category
        self.priority = priority
        self.timeout = timeout
        self.dependencies = dependencies
        self.tags = tags
    }
}

enum TestCategory: String, CaseIterable, Codable {
    case unit = "Unit"
    case integration = "Integration"
    case ui = "UI"
    case performance = "Performance"
    case security = "Security"
    case accessibility = "Accessibility"
    case visual = "Visual"
    case load = "Load"
}

enum TestPriority: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case critical = "Critical"
}
```

### Test Suite

```swift
struct TestSuite: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let tests: [TestCase]
    let configuration: TestSuiteConfiguration
    
    init(name: String, description: String, tests: [TestCase], configuration: TestSuiteConfiguration = TestSuiteConfiguration()) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.tests = tests
        self.configuration = configuration
    }
}

struct TestSuiteConfiguration: Codable {
    let parallelExecution: Bool
    let maxConcurrentTests: Int
    let retryFailedTests: Bool
    let maxRetries: Int
    let stopOnFailure: Bool
    
    init(parallelExecution: Bool = true, maxConcurrentTests: Int = 4, retryFailedTests: Bool = true, maxRetries: Int = 2, stopOnFailure: Bool = false) {
        self.parallelExecution = parallelExecution
        self.maxConcurrentTests = maxConcurrentTests
        self.retryFailedTests = retryFailedTests
        self.maxRetries = maxRetries
        self.stopOnFailure = stopOnFailure
    }
}
```

## Test Runner

### Test Runner Implementation

```swift
protocol TestRunner {
    func runTest(_ test: TestCase) async throws -> TestResult
    func configure(_ configuration: TestConfiguration) async throws
}

class TestRunnerImpl: TestRunner {
    private var configuration: TestConfiguration
    private let testExecutor: TestExecutor
    private let resultCollector: ResultCollector
    
    init(configuration: TestConfiguration, testExecutor: TestExecutor, resultCollector: ResultCollector) {
        self.configuration = configuration
        self.testExecutor = testExecutor
        self.resultCollector = resultCollector
    }
    
    func runTest(_ test: TestCase) async throws -> TestResult {
        let startTime = Date()
        
        // Check dependencies
        guard await checkDependencies(test.dependencies) else {
            return TestResult(
                passedTests: [],
                failedTests: [test],
                skippedTests: [],
                duration: 0,
                timestamp: startTime,
                error: TestError.dependencyFailed
            )
        }
        
        // Execute test
        let result = try await testExecutor.execute(test)
        
        // Collect results
        await resultCollector.collect(result)
        
        let endTime = Date()
        let duration = endTime.timeIntervalSince(startTime)
        
        return TestResult(
            passedTests: result.status == .passed ? [test] : [],
            failedTests: result.status == .failed ? [test] : [],
            skippedTests: result.status == .skipped ? [test] : [],
            duration: duration,
            timestamp: startTime,
            error: result.error
        )
    }
    
    func configure(_ configuration: TestConfiguration) async throws {
        self.configuration = configuration
        try await testExecutor.configure(configuration)
        try await resultCollector.configure(configuration)
    }
    
    private func checkDependencies(_ dependencies: [UUID]) async -> Bool {
        // Check if all dependencies are satisfied
        for dependency in dependencies {
            // Implementation for dependency checking
        }
        return true
    }
}

enum TestStatus: String, Codable {
    case passed = "Passed"
    case failed = "Failed"
    case skipped = "Skipped"
    case running = "Running"
}

struct TestResult: Codable {
    let passedTests: [TestCase]
    let failedTests: [TestCase]
    let skippedTests: [TestCase]
    let duration: TimeInterval
    let timestamp: Date
    let error: TestError?
    
    var totalTests: Int {
        return passedTests.count + failedTests.count + skippedTests.count
    }
    
    var success: Bool {
        return failedTests.isEmpty
    }
}

enum TestError: Error, LocalizedError, Codable {
    case timeout
    case assertionFailed(String)
    case dependencyFailed
    case configurationError(String)
    case executionError(String)
    
    var errorDescription: String? {
        switch self {
        case .timeout:
            return "Test execution timed out"
        case .assertionFailed(let message):
            return "Assertion failed: \(message)"
        case .dependencyFailed:
            return "Test dependencies failed"
        case .configurationError(let message):
            return "Configuration error: \(message)"
        case .executionError(let message):
            return "Execution error: \(message)"
        }
    }
}
```

## Test Configuration

### Configuration Management

```swift
struct TestConfiguration: Codable {
    let executionMode: ExecutionMode
    let parallelExecution: Bool
    let maxConcurrentTests: Int
    let timeout: TimeInterval
    let retryFailedTests: Bool
    let maxRetries: Int
    let stopOnFailure: Bool
    let generateReports: Bool
    let reportFormat: ReportFormat
    let logLevel: LogLevel
    
    init(executionMode: ExecutionMode = .sequential, parallelExecution: Bool = true, maxConcurrentTests: Int = 4, timeout: TimeInterval = 30.0, retryFailedTests: Bool = true, maxRetries: Int = 2, stopOnFailure: Bool = false, generateReports: Bool = true, reportFormat: ReportFormat = .html, logLevel: LogLevel = .info) {
        self.executionMode = executionMode
        self.parallelExecution = parallelExecution
        self.maxConcurrentTests = maxConcurrentTests
        self.timeout = timeout
        self.retryFailedTests = retryFailedTests
        self.maxRetries = maxRetries
        self.stopOnFailure = stopOnFailure
        self.generateReports = generateReports
        self.reportFormat = reportFormat
        self.logLevel = logLevel
    }
}

enum ExecutionMode: String, CaseIterable, Codable {
    case sequential = "Sequential"
    case parallel = "Parallel"
    case mixed = "Mixed"
}

enum ReportFormat: String, CaseIterable, Codable {
    case html = "HTML"
    case json = "JSON"
    case xml = "XML"
    case pdf = "PDF"
}

enum LogLevel: String, CaseIterable, Codable {
    case debug = "Debug"
    case info = "Info"
    case warning = "Warning"
    case error = "Error"
}
```

## Test Coverage

### Coverage Analysis

```swift
struct TestCoverage: Codable {
    let totalTests: Int
    let passedTests: Int
    let failedTests: Int
    let skippedTests: Int
    let passedPercentage: Double
    
    var failedPercentage: Double {
        return Double(failedTests) / Double(totalTests) * 100
    }
    
    var skippedPercentage: Double {
        return Double(skippedTests) / Double(totalTests) * 100
    }
    
    var isSuccessful: Bool {
        return failedTests == 0
    }
}

class CoverageAnalyzer {
    func analyzeCoverage(_ results: TestResult) -> TestCoverage {
        let totalTests = results.totalTests
        let passedPercentage = Double(results.passedTests.count) / Double(totalTests) * 100
        
        return TestCoverage(
            totalTests: totalTests,
            passedTests: results.passedTests.count,
            failedTests: results.failedTests.count,
            skippedTests: results.skippedTests.count,
            passedPercentage: passedPercentage
        )
    }
    
    func generateCoverageReport(_ coverage: TestCoverage) -> String {
        return """
        Test Coverage Report
        ===================
        Total Tests: \(coverage.totalTests)
        Passed: \(coverage.passedTests) (\(String(format: "%.1f", coverage.passedPercentage))%)
        Failed: \(coverage.failedTests) (\(String(format: "%.1f", coverage.failedPercentage))%)
        Skipped: \(coverage.skippedTests) (\(String(format: "%.1f", coverage.skippedPercentage))%)
        Success: \(coverage.isSuccessful ? "Yes" : "No")
        """
    }
}
```

## Test Reporting

### Report Generator

```swift
protocol ReportGenerator {
    func generateReport(_ results: TestResult) async throws -> TestReport
    func configure(_ configuration: TestConfiguration) async throws
}

class ReportGeneratorImpl: ReportGenerator {
    private let configuration: TestConfiguration
    private let coverageAnalyzer: CoverageAnalyzer
    
    init(configuration: TestConfiguration, coverageAnalyzer: CoverageAnalyzer) {
        self.configuration = configuration
        self.coverageAnalyzer = coverageAnalyzer
    }
    
    func generateReport(_ results: TestResult) async throws -> TestReport {
        let coverage = coverageAnalyzer.analyzeCoverage(results)
        let reportData = generateReportData(results, coverage: coverage)
        
        return TestReport(
            results: results,
            coverage: coverage,
            data: reportData,
            format: configuration.reportFormat,
            timestamp: Date()
        )
    }
    
    func configure(_ configuration: TestConfiguration) async throws {
        // Apply configuration settings
    }
    
    private func generateReportData(_ results: TestResult, coverage: TestCoverage) -> [String: Any] {
        return [
            "summary": [
                "totalTests": results.totalTests,
                "passedTests": results.passedTests.count,
                "failedTests": results.failedTests.count,
                "skippedTests": results.skippedTests.count,
                "duration": results.duration,
                "success": results.success
            ],
            "coverage": [
                "totalTests": coverage.totalTests,
                "passedPercentage": coverage.passedPercentage,
                "failedPercentage": coverage.failedPercentage,
                "skippedPercentage": coverage.skippedPercentage,
                "isSuccessful": coverage.isSuccessful
            ],
            "details": [
                "passedTests": results.passedTests.map { $0.name },
                "failedTests": results.failedTests.map { $0.name },
                "skippedTests": results.skippedTests.map { $0.name }
            ]
        ]
    }
}

struct TestReport: Codable {
    let results: TestResult
    let coverage: TestCoverage
    let data: [String: Any]
    let format: ReportFormat
    let timestamp: Date
    
    var summary: String {
        return """
        Test Report
        ===========
        Date: \(timestamp)
        Total Tests: \(results.totalTests)
        Passed: \(results.passedTests.count)
        Failed: \(results.failedTests.count)
        Skipped: \(results.skippedTests.count)
        Duration: \(String(format: "%.2f", results.duration))s
        Success: \(results.success ? "Yes" : "No")
        Coverage: \(String(format: "%.1f", coverage.passedPercentage))%
        """
    }
}
```

## Testing

### Framework Tests

```swift
class TestFrameworkTests: XCTestCase {
    var testManager: TestManager!
    var mockTestRunner: MockTestRunner!
    var mockReportGenerator: MockReportGenerator!
    
    override func setUp() {
        super.setUp()
        mockTestRunner = MockTestRunner()
        mockReportGenerator = MockReportGenerator()
        let configuration = TestConfiguration()
        testManager = TestManagerImpl(
            testRunner: mockTestRunner,
            reportGenerator: mockReportGenerator,
            configuration: configuration
        )
    }
    
    func testRunTestsSuccess() async throws {
        // Given
        let testCase = TestCase(name: "Test Case", description: "Test Description", category: .unit)
        let tests = [testCase]
        mockTestRunner.mockResult = TestResult(
            passedTests: [testCase],
            failedTests: [],
            skippedTests: [],
            duration: 1.0,
            timestamp: Date()
        )
        
        // When
        let result = try await testManager.runTests(tests)
        
        // Then
        XCTAssertEqual(result.passedTests.count, 1)
        XCTAssertEqual(result.failedTests.count, 0)
        XCTAssertTrue(result.success)
    }
    
    func testRunTestsFailure() async throws {
        // Given
        let testCase = TestCase(name: "Test Case", description: "Test Description", category: .unit)
        let tests = [testCase]
        mockTestRunner.mockResult = TestResult(
            passedTests: [],
            failedTests: [testCase],
            skippedTests: [],
            duration: 1.0,
            timestamp: Date()
        )
        
        // When
        let result = try await testManager.runTests(tests)
        
        // Then
        XCTAssertEqual(result.passedTests.count, 0)
        XCTAssertEqual(result.failedTests.count, 1)
        XCTAssertFalse(result.success)
    }
}
```

## Best Practices

1. **Test Organization**: Organize tests by category and priority
2. **Dependency Management**: Handle test dependencies properly
3. **Configuration**: Make test configuration flexible and extensible
4. **Reporting**: Generate comprehensive test reports
5. **Coverage Analysis**: Track and analyze test coverage
6. **Error Handling**: Provide detailed error information for failed tests 