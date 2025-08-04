# API Reference

## Overview

The iOS Testing Automation Framework provides a comprehensive API for automated testing of iOS applications. This document outlines the main components and their usage.

## Core Components

### TestAutomationFramework

The main entry point for the testing framework.

```swift
import iOSTestingAutomationFramework

let framework = TestAutomationFramework()
```

#### Configuration

```swift
framework.configure(
    enableParallelExecution: true,
    maxConcurrentTests: 4,
    timeoutInterval: 30.0,
    enablePerformanceMonitoring: true
)
```

#### Running Tests

```swift
// Run a single test case
let testCase = TestCase(name: "My Test", description: "Test description") {
    // Test implementation
}
let result = try await framework.runTest(testCase)

// Run a test suite
let testSuite = TestSuite(name: "My Suite", description: "Suite description")
let results = try await framework.runTestSuite(testSuite)
```

### TestCase

Represents an individual test case.

```swift
let testCase = TestCase(
    name: "Login Test",
    description: "Tests user login functionality",
    executionBlock: {
        // Test implementation
        try await performLogin()
        XCTAssertTrue(isLoggedIn)
    }
)
```

### TestSuite

Organizes multiple test cases into a suite.

```swift
let testSuite = TestSuite(
    name: "Authentication Suite",
    description: "Tests for authentication functionality",
    testCases: [
        loginTestCase,
        logoutTestCase,
        passwordResetTestCase
    ]
)
```

### TestConfiguration

Configures the behavior of the testing framework.

```swift
let config = TestConfiguration(
    enableParallelExecution: true,
    maxConcurrentTests: 4,
    timeoutInterval: 30.0,
    enablePerformanceMonitoring: true,
    enableVisualTesting: true,
    enableSecurityTesting: true,
    enableAccessibilityTesting: true
)
```

## UI Testing

### UITestSuite

Specialized test suite for UI automation.

```swift
let uiTestSuite = UITestSuite()

let loginUITest = UITestCase(
    name: "Login UI Test",
    description: "Tests login UI flow",
    category: .authentication,
    priority: .high
) {
    // UI test implementation
    try await tapLoginButton()
    try await enterCredentials()
    try await verifyLoginSuccess()
}

uiTestSuite.addTest(loginUITest)
let results = try await uiTestSuite.runAllTests()
```

### UITestCase

UI-specific test case with additional metadata.

```swift
let uiTestCase = UITestCase(
    name: "Navigation Test",
    description: "Tests app navigation",
    category: .navigation,
    priority: .medium
) {
    // UI test implementation
}
```

## Performance Monitoring

### PerformanceMonitor

Monitors and tracks performance metrics during test execution.

```swift
let monitor = PerformanceMonitor()
monitor.startMonitoring()

// Run your tests
let result = try await framework.runTest(testCase)

monitor.stopMonitoring()
let metrics = monitor.getMetrics()

print("Memory usage: \(metrics.memoryUsageMB) MB")
print("CPU usage: \(metrics.cpuUsage)%")
print("Frame rate: \(metrics.frameRate) FPS")
```

### PerformanceMetrics

Contains performance data from test execution.

```swift
let metrics = framework.getPerformanceMetrics()

// Check if performance is acceptable
if metrics.isPerformanceAcceptable {
    print("Performance is within acceptable limits")
}

// Get performance score
let score = metrics.performanceScore
print("Performance score: \(score)/100")
```

## Report Generation

### TestReportGenerator

Generates comprehensive test reports.

```swift
let reportGenerator = TestReportGenerator()

// Generate report from test results
let report = reportGenerator.generateReport(from: [testSuiteResults])

// Generate HTML report
let htmlReport = reportGenerator.generateHTMLReport(from: report)

// Generate JSON report
let jsonData = reportGenerator.generateJSONReport(from: report)

// Save report to file
try reportGenerator.saveReport(report, to: "test-report.html", format: .html)
```

### TestReport

Contains comprehensive test execution results.

```swift
let report = framework.generateReport(from: [testSuiteResults])

print("Total tests: \(report.totalTests)")
print("Passed: \(report.passedTests)")
print("Failed: \(report.failedTests)")
print("Success rate: \(report.successRate)%")
print("Total execution time: \(report.totalExecutionTime)s")
```

## Error Handling

### TestExecutionError

Framework-specific error types.

```swift
do {
    let result = try await framework.runTest(testCase)
} catch TestExecutionError.timeout(let message) {
    print("Test timed out: \(message)")
} catch TestExecutionError.invalidTestCase(let message) {
    print("Invalid test case: \(message)")
} catch TestExecutionError.executionFailed(let message) {
    print("Execution failed: \(message)")
} catch {
    print("Unexpected error: \(error)")
}
```

## Advanced Usage

### Parallel Execution

```swift
framework.configure(
    enableParallelExecution: true,
    maxConcurrentTests: 4
)

let results = try await framework.runTestSuite(testSuite)
```

### Custom Performance Metrics

```swift
let monitor = PerformanceMonitor()
monitor.recordMetric(name: "custom_metric", value: 42.0)
monitor.recordMemoryUsage(1024 * 1024) // 1MB
monitor.recordCPUUsage(75.5) // 75.5%
monitor.recordFrameRate(60.0) // 60 FPS
```

### Test Environment

```swift
let environment = TestEnvironment(
    deviceType: "iPhone 14",
    osVersion: "16.0",
    appVersion: "1.0.0",
    isSimulator: true,
    availableMemory: 8 * 1024 * 1024 * 1024, // 8GB
    cpuUsage: 25.0
)
```

## Best Practices

1. **Use descriptive test names**: Make test names clear and descriptive
2. **Group related tests**: Use test suites to organize related test cases
3. **Monitor performance**: Enable performance monitoring for critical tests
4. **Handle errors gracefully**: Always implement proper error handling
5. **Generate reports**: Use the reporting system to track test results
6. **Use parallel execution**: Enable parallel execution for faster test runs
7. **Set appropriate timeouts**: Configure timeouts based on test complexity
8. **Validate test results**: Always verify expected outcomes

## Examples

See the [Examples](Examples/) directory for complete working examples of the framework usage. 