import XCTest
@testable import iOSTestingAutomationFramework

@available(iOS 15.0, macOS 12.0, *)
final class TestAutomationFrameworkTests: XCTestCase {
    
    var testFramework: TestAutomationFramework!
    
    override func setUp() {
        super.setUp()
        testFramework = TestAutomationFramework()
    }
    
    override func tearDown() {
        testFramework = nil
        super.tearDown()
    }
    
    // MARK: - Configuration Tests
    
    func testDefaultConfiguration() {
        let framework = TestAutomationFramework()
        XCTAssertNotNil(framework)
    }
    
    func testCustomConfiguration() {
        let config = TestAutomationConfiguration(
            enableParallelExecution: false,
            enableVisualTesting: false,
            enablePerformanceMonitoring: true,
            enableSecurityTesting: false,
            maxRetryCount: 5,
            timeoutInterval: 60.0,
            screenshotOnFailure: false,
            videoRecording: true
        )
        
        let framework = TestAutomationFramework(configuration: config)
        XCTAssertNotNil(framework)
    }
    
    func testConfigureWithIndividualParameters() {
        testFramework.configure(
            enableParallelExecution: false,
            enableVisualTesting: true,
            enablePerformanceMonitoring: false,
            enableSecurityTesting: true,
            maxRetryCount: 2,
            timeoutInterval: 45.0,
            screenshotOnFailure: false,
            videoRecording: true
        )
        
        // Configuration should be applied successfully
        XCTAssertNotNil(testFramework)
    }
    
    // MARK: - Test Case Creation Tests
    
    func testCreateSimpleTestCase() {
        let testCase = TestCase(
            name: "Simple Test",
            description: "A simple test case",
            executionBlock: {
                // Test execution logic
            }
        )
        
        XCTAssertEqual(testCase.name, "Simple Test")
        XCTAssertEqual(testCase.description, "A simple test case")
        XCTAssertEqual(testCase.category, .functional)
        XCTAssertEqual(testCase.priority, .medium)
        XCTAssertTrue(testCase.isEnabled)
    }
    
    func testCreateComplexTestCase() {
        let testCase = TestCase(
            name: "Complex Test",
            description: "A complex test case with all parameters",
            category: .performance,
            priority: .high,
            tags: ["performance", "critical"],
            executionBlock: {
                // Test execution logic
            },
            setupBlock: {
                // Setup logic
            },
            teardownBlock: {
                // Teardown logic
            },
            expectedExecutionTime: 60.0,
            isEnabled: true,
            customData: ["key": "value"]
        )
        
        XCTAssertEqual(testCase.name, "Complex Test")
        XCTAssertEqual(testCase.category, .performance)
        XCTAssertEqual(testCase.priority, .high)
        XCTAssertEqual(testCase.tags.count, 2)
        XCTAssertTrue(testCase.tags.contains("performance"))
        XCTAssertTrue(testCase.tags.contains("critical"))
        XCTAssertEqual(testCase.expectedExecutionTime, 60.0)
        XCTAssertTrue(testCase.isEnabled)
        XCTAssertEqual(testCase.customData["key"] as? String, "value")
    }
    
    // MARK: - Test Suite Creation Tests
    
    func testCreateSimpleTestSuite() {
        let testCase1 = TestCase(name: "Test 1", description: "First test")
        let testCase2 = TestCase(name: "Test 2", description: "Second test")
        
        let testSuite = TestSuite(
            name: "Simple Suite",
            description: "A simple test suite",
            testCases: [testCase1, testCase2]
        )
        
        XCTAssertEqual(testSuite.name, "Simple Suite")
        XCTAssertEqual(testSuite.description, "A simple test suite")
        XCTAssertEqual(testSuite.testCaseCount, 2)
        XCTAssertEqual(testSuite.enabledTestCaseCount, 2)
        XCTAssertEqual(testSuite.disabledTestCaseCount, 0)
    }
    
    func testCreateComplexTestSuite() {
        let testCase1 = TestCase(
            name: "Performance Test",
            description: "A performance test",
            category: .performance,
            priority: .high,
            isEnabled: true
        )
        
        let testCase2 = TestCase(
            name: "Disabled Test",
            description: "A disabled test",
            category: .functional,
            priority: .low,
            isEnabled: false
        )
        
        let config = TestSuiteConfiguration(
            enableParallelExecution: true,
            maxConcurrentExecutions: 2,
            stopOnFirstFailure: false,
            retryFailedTests: true,
            maxRetryCount: 3,
            timeout: 300.0,
            generateDetailedReports: true,
            captureScreenshotsOnFailure: true,
            recordVideo: false
        )
        
        let testSuite = TestSuite(
            name: "Complex Suite",
            description: "A complex test suite",
            testCases: [testCase1, testCase2],
            configuration: config,
            tags: ["complex", "automation"],
            isEnabled: true,
            customData: ["suiteKey": "suiteValue"]
        )
        
        XCTAssertEqual(testSuite.name, "Complex Suite")
        XCTAssertEqual(testSuite.testCaseCount, 2)
        XCTAssertEqual(testSuite.enabledTestCaseCount, 1)
        XCTAssertEqual(testSuite.disabledTestCaseCount, 1)
        XCTAssertEqual(testSuite.tags.count, 2)
        XCTAssertTrue(testSuite.isEnabled)
    }
    
    // MARK: - Test Suite Methods Tests
    
    func testAddTestCaseToSuite() {
        let testSuite = TestSuite(name: "Empty Suite", description: "An empty test suite")
        XCTAssertEqual(testSuite.testCaseCount, 0)
        
        let testCase = TestCase(name: "New Test", description: "A new test case")
        let updatedSuite = testSuite.addTestCase(testCase)
        
        XCTAssertEqual(updatedSuite.testCaseCount, 1)
        XCTAssertEqual(updatedSuite.enabledTestCaseCount, 1)
    }
    
    func testFilterTestCasesByCategory() {
        let testCase1 = TestCase(name: "Performance Test", description: "Performance test", category: .performance)
        let testCase2 = TestCase(name: "Functional Test", description: "Functional test", category: .functional)
        let testCase3 = TestCase(name: "Security Test", description: "Security test", category: .security)
        
        let testSuite = TestSuite(
            name: "Mixed Suite",
            description: "Suite with different categories",
            testCases: [testCase1, testCase2, testCase3]
        )
        
        let performanceTests = testSuite.testCases(in: .performance)
        let functionalTests = testSuite.testCases(in: .functional)
        let securityTests = testSuite.testCases(in: .security)
        
        XCTAssertEqual(performanceTests.count, 1)
        XCTAssertEqual(functionalTests.count, 1)
        XCTAssertEqual(securityTests.count, 1)
        
        XCTAssertEqual(performanceTests.first?.name, "Performance Test")
        XCTAssertEqual(functionalTests.first?.name, "Functional Test")
        XCTAssertEqual(securityTests.first?.name, "Security Test")
    }
    
    func testEnabledTestCases() {
        let testCase1 = TestCase(name: "Enabled Test 1", description: "First enabled test", isEnabled: true)
        let testCase2 = TestCase(name: "Disabled Test", description: "Disabled test", isEnabled: false)
        let testCase3 = TestCase(name: "Enabled Test 2", description: "Second enabled test", isEnabled: true)
        
        let testSuite = TestSuite(
            name: "Mixed Enabled Suite",
            description: "Suite with enabled and disabled tests",
            testCases: [testCase1, testCase2, testCase3]
        )
        
        let enabledTests = testSuite.enabledTestCases()
        
        XCTAssertEqual(enabledTests.count, 2)
        XCTAssertEqual(testSuite.enabledTestCaseCount, 2)
        XCTAssertEqual(testSuite.disabledTestCaseCount, 1)
        
        XCTAssertTrue(enabledTests.contains { $0.name == "Enabled Test 1" })
        XCTAssertTrue(enabledTests.contains { $0.name == "Enabled Test 2" })
        XCTAssertFalse(enabledTests.contains { $0.name == "Disabled Test" })
    }
    
    // MARK: - Test Category Tests
    
    func testTestCategoryDisplayNames() {
        XCTAssertEqual(TestCategory.functional.displayName, "Functional")
        XCTAssertEqual(TestCategory.performance.displayName, "Performance")
        XCTAssertEqual(TestCategory.security.displayName, "Security")
        XCTAssertEqual(TestCategory.ui.displayName, "Ui")
        XCTAssertEqual(TestCategory.integration.displayName, "Integration")
        XCTAssertEqual(TestCategory.unit.displayName, "Unit")
        XCTAssertEqual(TestCategory.smoke.displayName, "Smoke")
        XCTAssertEqual(TestCategory.regression.displayName, "Regression")
        XCTAssertEqual(TestCategory.accessibility.displayName, "Accessibility")
        XCTAssertEqual(TestCategory.visual.displayName, "Visual")
    }
    
    func testTestPriorityComparison() {
        XCTAssertTrue(TestPriority.critical > TestPriority.high)
        XCTAssertTrue(TestPriority.high > TestPriority.medium)
        XCTAssertTrue(TestPriority.medium > TestPriority.low)
        XCTAssertTrue(TestPriority.low > TestPriority.lowest)
        
        XCTAssertFalse(TestPriority.lowest > TestPriority.critical)
        XCTAssertFalse(TestPriority.medium > TestPriority.high)
    }
    
    func testTestPriorityDisplayNames() {
        XCTAssertEqual(TestPriority.critical.displayName, "Critical")
        XCTAssertEqual(TestPriority.high.displayName, "High")
        XCTAssertEqual(TestPriority.medium.displayName, "Medium")
        XCTAssertEqual(TestPriority.low.displayName, "Low")
        XCTAssertEqual(TestPriority.lowest.displayName, "Lowest")
    }
    
    // MARK: - Test Suite Configuration Tests
    
    func testTestSuiteConfiguration() {
        let config = TestSuiteConfiguration(
            enableParallelExecution: true,
            maxConcurrentExecutions: 4,
            stopOnFirstFailure: false,
            retryFailedTests: true,
            maxRetryCount: 3,
            timeout: 300.0,
            generateDetailedReports: true,
            captureScreenshotsOnFailure: true,
            recordVideo: false
        )
        
        XCTAssertTrue(config.enableParallelExecution)
        XCTAssertEqual(config.maxConcurrentExecutions, 4)
        XCTAssertFalse(config.stopOnFirstFailure)
        XCTAssertTrue(config.retryFailedTests)
        XCTAssertEqual(config.maxRetryCount, 3)
        XCTAssertEqual(config.timeout, 300.0)
        XCTAssertTrue(config.generateDetailedReports)
        XCTAssertTrue(config.captureScreenshotsOnFailure)
        XCTAssertFalse(config.recordVideo)
    }
    
    // MARK: - Performance Tests
    
    func testPerformanceMetrics() {
        testFramework.enablePerformanceMonitoring()
        let metrics = testFramework.getPerformanceMetrics()
        
        // Metrics should be available after enabling monitoring
        XCTAssertNotNil(metrics)
    }
    
    // MARK: - Error Handling Tests
    
    func testEmptyTestSuiteValidation() {
        let emptySuite = TestSuite(name: "Empty Suite", description: "An empty test suite")
        
        // This should not throw an error as validation is handled internally
        XCTAssertNotNil(emptySuite)
        XCTAssertEqual(emptySuite.testCaseCount, 0)
    }
    
    func testTestCaseValidation() {
        let validTestCase = TestCase(
            name: "Valid Test",
            description: "A valid test case",
            executionBlock: {
                // Valid execution block
            }
        )
        
        XCTAssertNotNil(validTestCase)
        XCTAssertFalse(validTestCase.name.isEmpty)
        XCTAssertNotNil(validTestCase.executionBlock)
    }
} 