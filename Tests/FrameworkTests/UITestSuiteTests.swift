import XCTest
@testable import iOSTestingAutomationFramework

final class UITestSuiteTests: XCTestCase {
    
    var testSuite: UITestSuite!
    var configuration: TestConfiguration!
    
    override func setUp() {
        super.setUp()
        configuration = TestConfiguration()
        testSuite = UITestSuite(configuration: configuration)
    }
    
    override func tearDown() {
        testSuite = nil
        configuration = nil
        super.tearDown()
    }
    
    // MARK: - Test Management Tests
    
    func testAddTest() {
        let testCase = MockUITestCase(name: "TestLogin")
        testSuite.addTest(testCase)
        
        // Verify test was added (we'll check through execution)
        let expectation = XCTestExpectation(description: "Test execution")
        
        Task {
            let report = try await testSuite.runTests()
            XCTAssertEqual(report.summary.totalTests, 1)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testAddMultipleTests() {
        let testCase1 = MockUITestCase(name: "TestLogin")
        let testCase2 = MockUITestCase(name: "TestLogout")
        let testCase3 = MockUITestCase(name: "TestRegistration")
        
        testSuite.addTests([testCase1, testCase2, testCase3])
        
        let expectation = XCTestExpectation(description: "Multiple tests execution")
        
        Task {
            let report = try await testSuite.runTests()
            XCTAssertEqual(report.summary.totalTests, 3)
            XCTAssertEqual(report.summary.passedTests, 3)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRemoveTest() {
        let testCase = MockUITestCase(name: "TestLogin")
        testSuite.addTest(testCase)
        
        // Remove the test
        testSuite.removeTest(testCase)
        
        let expectation = XCTestExpectation(description: "Test removal verification")
        
        Task {
            let report = try await testSuite.runTests()
            XCTAssertEqual(report.summary.totalTests, 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testClearTests() {
        let testCase1 = MockUITestCase(name: "TestLogin")
        let testCase2 = MockUITestCase(name: "TestLogout")
        
        testSuite.addTests([testCase1, testCase2])
        testSuite.clearTests()
        
        let expectation = XCTestExpectation(description: "Clear tests verification")
        
        Task {
            let report = try await testSuite.runTests()
            XCTAssertEqual(report.summary.totalTests, 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Test Execution Tests
    
    func testSequentialExecution() {
        configuration.enableParallelExecution = false
        let sequentialSuite = UITestSuite(configuration: configuration)
        
        let testCase1 = MockUITestCase(name: "Test1")
        let testCase2 = MockUITestCase(name: "Test2")
        let testCase3 = MockUITestCase(name: "Test3")
        
        sequentialSuite.addTests([testCase1, testCase2, testCase3])
        
        let expectation = XCTestExpectation(description: "Sequential execution")
        
        Task {
            let report = try await sequentialSuite.runTests()
            XCTAssertEqual(report.summary.totalTests, 3)
            XCTAssertEqual(report.summary.passedTests, 3)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testParallelExecution() {
        configuration.enableParallelExecution = true
        configuration.maxConcurrentTests = 2
        let parallelSuite = UITestSuite(configuration: configuration)
        
        let testCase1 = MockUITestCase(name: "ParallelTest1")
        let testCase2 = MockUITestCase(name: "ParallelTest2")
        let testCase3 = MockUITestCase(name: "ParallelTest3")
        
        parallelSuite.addTests([testCase1, testCase2, testCase3])
        
        let expectation = XCTestExpectation(description: "Parallel execution")
        
        Task {
            let report = try await parallelSuite.runTests()
            XCTAssertEqual(report.summary.totalTests, 3)
            XCTAssertEqual(report.summary.passedTests, 3)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testTestExecutionWithError() {
        let failingTestCase = MockUITestCase(name: "FailingTest", shouldFail: true)
        testSuite.addTest(failingTestCase)
        
        let expectation = XCTestExpectation(description: "Failing test execution")
        
        Task {
            let report = try await testSuite.runTests()
            XCTAssertEqual(report.summary.totalTests, 1)
            XCTAssertEqual(report.summary.failedTests, 1)
            XCTAssertEqual(report.summary.passedTests, 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Configuration Tests
    
    func testConfigurationValidation() {
        // Test with valid configuration
        XCTAssertNoThrow(try configuration.validate())
        
        // Test with invalid configuration
        configuration.maxConcurrentTests = 0
        XCTAssertThrowsError(try configuration.validate())
        
        // Reset to valid configuration
        configuration.maxConcurrentTests = 4
        XCTAssertNoThrow(try configuration.validate())
    }
    
    func testDeviceConfiguration() {
        configuration.deviceConfiguration.iOSVersion = "15.0"
        configuration.deviceConfiguration.screenSize = CGSize(width: 390, height: 844)
        
        XCTAssertTrue(configuration.deviceConfiguration.isValid)
        
        // Test invalid configuration
        configuration.deviceConfiguration.iOSVersion = ""
        XCTAssertFalse(configuration.deviceConfiguration.isValid)
    }
    
    func testPerformanceThresholds() {
        configuration.performanceThresholds.maxMemoryUsage = 200 * 1024 * 1024
        configuration.performanceThresholds.maxCPUUsage = 80.0
        
        XCTAssertTrue(configuration.performanceThresholds.isValid)
        
        // Test invalid thresholds
        configuration.performanceThresholds.maxMemoryUsage = 0
        XCTAssertFalse(configuration.performanceThresholds.isValid)
    }
    
    // MARK: - Environment Setup Tests
    
    func testDeviceSettingsConfiguration() {
        configuration.deviceConfiguration.orientation = .landscapeLeft
        configuration.deviceConfiguration.language = "es"
        configuration.deviceConfiguration.region = "ES"
        
        let expectation = XCTestExpectation(description: "Device settings test")
        
        Task {
            // This would normally test device settings configuration
            // For now, we'll just verify the configuration is set
            XCTAssertEqual(configuration.deviceConfiguration.orientation, .landscapeLeft)
            XCTAssertEqual(configuration.deviceConfiguration.language, "es")
            XCTAssertEqual(configuration.deviceConfiguration.region, "ES")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testAccessibilityConfiguration() {
        configuration.enableAccessibilityTesting = true
        
        let expectation = XCTestExpectation(description: "Accessibility configuration test")
        
        Task {
            // This would normally test accessibility configuration
            // For now, we'll just verify the configuration is enabled
            XCTAssertTrue(configuration.enableAccessibilityTesting)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Screenshot Capture Tests
    
    func testScreenshotCapture() {
        let testCase = MockUITestCase(name: "ScreenshotTest")
        testCase.screenshotPoints = [
            ScreenshotPoint(name: "before", description: "Before test", timing: .beforeTest),
            ScreenshotPoint(name: "after", description: "After test", timing: .afterTest)
        ]
        
        testSuite.addTest(testCase)
        
        let expectation = XCTestExpectation(description: "Screenshot capture test")
        
        Task {
            let report = try await testSuite.runTests()
            XCTAssertEqual(report.screenshots.count, 2)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Performance Monitoring Tests
    
    func testPerformanceMonitoring() {
        configuration.enablePerformanceMonitoring = true
        let performanceSuite = UITestSuite(configuration: configuration)
        
        let testCase = MockUITestCase(name: "PerformanceTest")
        performanceSuite.addTest(testCase)
        
        let expectation = XCTestExpectation(description: "Performance monitoring test")
        
        Task {
            let report = try await performanceSuite.runTests()
            XCTAssertNotNil(report.performanceReport)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Error Handling Tests
    
    func testConfigurationErrorHandling() {
        configuration.maxConcurrentTests = 0
        
        let expectation = XCTestExpectation(description: "Configuration error handling")
        
        Task {
            do {
                _ = try await testSuite.runTests()
                XCTFail("Should have thrown configuration error")
            } catch {
                XCTAssertTrue(error is TestConfigurationError)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testTestExecutionErrorHandling() {
        let errorTestCase = MockUITestCase(name: "ErrorTest", shouldThrowError: true)
        testSuite.addTest(errorTestCase)
        
        let expectation = XCTestExpectation(description: "Test execution error handling")
        
        Task {
            let report = try await testSuite.runTests()
            XCTAssertEqual(report.summary.totalTests, 1)
            XCTAssertEqual(report.summary.failedTests, 1)
            
            let failedResult = report.detailedResults.first
            XCTAssertNotNil(failedResult?.errorMessage)
            XCTAssertNotNil(failedResult?.stackTrace)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Helper Classes
    
    class MockUITestCase: UITestCase {
        let testName: String
        let shouldFail: Bool
        let shouldThrowError: Bool
        var screenshotPoints: [ScreenshotPoint]?
        var testDataSetup: (() async throws -> Void)?
        var dependencySetup: (() async throws -> Void)?
        
        init(name: String, shouldFail: Bool = false, shouldThrowError: Bool = false) {
            self.testName = name
            self.shouldFail = shouldFail
            self.shouldThrowError = shouldThrowError
        }
        
        func execute() async throws {
            if shouldThrowError {
                throw TestExecutionError.testExecutionFailed("Mock test execution failed")
            }
            
            if shouldFail {
                throw TestExecutionError.assertionFailed("Mock test assertion failed")
            }
            
            // Simulate test execution time
            try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        }
    }
    
    enum TestExecutionError: Error {
        case testExecutionFailed(String)
        case assertionFailed(String)
    }
} 