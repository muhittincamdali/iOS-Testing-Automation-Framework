import XCTest
@testable import iOSTestingAutomationFramework

final class TestReporterTests: XCTestCase {
    
    var reporter: TestReporter!
    var configuration: ReportingConfiguration!
    
    override func setUp() {
        super.setUp()
        configuration = ReportingConfiguration()
        reporter = TestReporter(configuration: configuration)
    }
    
    override func tearDown() {
        reporter = nil
        configuration = nil
        super.tearDown()
    }
    
    // MARK: - Test Result Management Tests
    
    func testAddTestResult() {
        let testResult = createSampleTestResult()
        reporter.addTestResult(testResult)
        
        // Verify result was added (we'll check this through report generation)
        let expectation = XCTestExpectation(description: "Report generation")
        
        Task {
            let report = try await reporter.generateReport()
            XCTAssertEqual(report.summary.totalTests, 1)
            XCTAssertEqual(report.summary.passedTests, 1)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testAddPerformanceMetric() {
        let metric = PerformanceMetric(
            type: .memory,
            value: 100.0,
            timestamp: Date(),
            testName: "TestMemoryUsage"
        )
        
        reporter.addPerformanceMetric(metric)
        
        let expectation = XCTestExpectation(description: "Performance report generation")
        
        Task {
            let report = try await reporter.generateReport()
            XCTAssertEqual(report.performanceReport.memoryMetrics.count, 1)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testAddScreenshot() {
        let screenshot = Screenshot(
            name: "test_screenshot",
            data: Data(),
            timestamp: Date(),
            testName: "TestScreenshot"
        )
        
        reporter.addScreenshot(screenshot)
        
        let expectation = XCTestExpectation(description: "Screenshot report generation")
        
        Task {
            let report = try await reporter.generateReport()
            XCTAssertEqual(report.screenshots.count, 1)
            XCTAssertEqual(report.screenshots.first?.name, "test_screenshot")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testAddVideo() {
        let video = Video(
            name: "test_video",
            url: URL(string: "file://test.mp4")!,
            duration: 10.0,
            testName: "TestVideo"
        )
        
        reporter.addVideo(video)
        
        let expectation = XCTestExpectation(description: "Video report generation")
        
        Task {
            let report = try await reporter.generateReport()
            XCTAssertEqual(report.videos.count, 1)
            XCTAssertEqual(report.videos.first?.name, "test_video")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Report Generation Tests
    
    func testGenerateReportWithMultipleResults() {
        // Add multiple test results
        let passedResult = createSampleTestResult(status: .passed)
        let failedResult = createSampleTestResult(status: .failed, testName: "FailedTest")
        let skippedResult = createSampleTestResult(status: .skipped, testName: "SkippedTest")
        
        reporter.addTestResult(passedResult)
        reporter.addTestResult(failedResult)
        reporter.addTestResult(skippedResult)
        
        let expectation = XCTestExpectation(description: "Multiple results report generation")
        
        Task {
            let report = try await reporter.generateReport()
            
            XCTAssertEqual(report.summary.totalTests, 3)
            XCTAssertEqual(report.summary.passedTests, 1)
            XCTAssertEqual(report.summary.failedTests, 1)
            XCTAssertEqual(report.summary.skippedTests, 1)
            XCTAssertEqual(report.summary.successRate, 33.33, accuracy: 0.01)
            XCTAssertEqual(report.detailedResults.count, 3)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGenerateHTMLReport() {
        let testResult = createSampleTestResult()
        reporter.addTestResult(testResult)
        
        let expectation = XCTestExpectation(description: "HTML report generation")
        
        Task {
            let htmlReport = try await reporter.generateHTMLReport()
            
            XCTAssertTrue(htmlReport.contains("<!DOCTYPE html>"))
            XCTAssertTrue(htmlReport.contains("iOS Testing Automation Framework"))
            XCTAssertTrue(htmlReport.contains("Test Summary"))
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGenerateJSONReport() {
        let testResult = createSampleTestResult()
        reporter.addTestResult(testResult)
        
        let expectation = XCTestExpectation(description: "JSON report generation")
        
        Task {
            let jsonData = try await reporter.generateJSONReport()
            let jsonString = String(data: jsonData, encoding: .utf8)!
            
            XCTAssertTrue(jsonString.contains("summary"))
            XCTAssertTrue(jsonString.contains("detailedResults"))
            XCTAssertTrue(jsonString.contains("performanceReport"))
            XCTAssertTrue(jsonString.contains("coverageReport"))
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGenerateJUnitReport() {
        let testResult = createSampleTestResult()
        reporter.addTestResult(testResult)
        
        let expectation = XCTestExpectation(description: "JUnit report generation")
        
        Task {
            let junitReport = try await reporter.generateJUnitReport()
            
            XCTAssertTrue(junitReport.contains("<?xml version=\"1.0\" encoding=\"UTF-8\"?>"))
            XCTAssertTrue(junitReport.contains("testsuites"))
            XCTAssertTrue(junitReport.contains("testsuite"))
            XCTAssertTrue(junitReport.contains("testcase"))
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Performance Report Tests
    
    func testPerformanceReportGeneration() {
        // Add performance metrics
        let memoryMetric = PerformanceMetric(type: .memory, value: 150.0, timestamp: Date())
        let cpuMetric = PerformanceMetric(type: .cpu, value: 75.0, timestamp: Date())
        let networkMetric = PerformanceMetric(type: .network, value: 2.5, timestamp: Date())
        let batteryMetric = PerformanceMetric(type: .battery, value: 3.0, timestamp: Date())
        
        reporter.addPerformanceMetric(memoryMetric)
        reporter.addPerformanceMetric(cpuMetric)
        reporter.addPerformanceMetric(networkMetric)
        reporter.addPerformanceMetric(batteryMetric)
        
        let expectation = XCTestExpectation(description: "Performance report generation")
        
        Task {
            let report = try await reporter.generateReport()
            let performanceReport = report.performanceReport
            
            XCTAssertEqual(performanceReport.memoryMetrics.count, 1)
            XCTAssertEqual(performanceReport.cpuMetrics.count, 1)
            XCTAssertEqual(performanceReport.networkMetrics.count, 1)
            XCTAssertEqual(performanceReport.batteryMetrics.count, 1)
            XCTAssertEqual(performanceReport.averageMemoryUsage, 150)
            XCTAssertEqual(performanceReport.averageCPUUsage, 75.0)
            XCTAssertEqual(performanceReport.peakMemoryUsage, 150)
            XCTAssertEqual(performanceReport.peakCPUUsage, 75.0)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Coverage Report Tests
    
    func testCoverageReportGeneration() {
        let coverage = CodeCoverage(
            totalLines: 1000,
            coveredLines: 850,
            uncoveredFiles: ["UncoveredFile1.swift", "UncoveredFile2.swift"],
            coveragePercentage: 85.0
        )
        
        let testResult = TestResult(
            testName: "TestWithCoverage",
            testClass: "CoverageTestClass",
            status: .passed,
            executionTime: 5.0,
            startTime: Date(),
            endTime: Date().addingTimeInterval(5.0),
            coverage: coverage
        )
        
        reporter.addTestResult(testResult)
        
        let expectation = XCTestExpectation(description: "Coverage report generation")
        
        Task {
            let report = try await reporter.generateReport()
            let coverageReport = report.coverageReport
            
            XCTAssertEqual(coverageReport.totalLines, 1000)
            XCTAssertEqual(coverageReport.coveredLines, 850)
            XCTAssertEqual(coverageReport.coveragePercentage, 85.0)
            XCTAssertEqual(coverageReport.uncoveredFiles.count, 2)
            XCTAssertTrue(coverageReport.uncoveredFiles.contains("UncoveredFile1.swift"))
            XCTAssertTrue(coverageReport.uncoveredFiles.contains("UncoveredFile2.swift"))
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Configuration Tests
    
    func testReportingConfigurationWithScreenshotsDisabled() {
        configuration.includeScreenshots = false
        let customReporter = TestReporter(configuration: configuration)
        
        let screenshot = Screenshot(
            name: "test_screenshot",
            data: Data(),
            timestamp: Date(),
            testName: "TestScreenshot"
        )
        
        customReporter.addScreenshot(screenshot)
        
        let expectation = XCTestExpectation(description: "Screenshot disabled report generation")
        
        Task {
            let report = try await customReporter.generateReport()
            XCTAssertEqual(report.screenshots.count, 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testReportingConfigurationWithVideosDisabled() {
        configuration.includeVideos = false
        let customReporter = TestReporter(configuration: configuration)
        
        let video = Video(
            name: "test_video",
            url: URL(string: "file://test.mp4")!,
            duration: 10.0,
            testName: "TestVideo"
        )
        
        customReporter.addVideo(video)
        
        let expectation = XCTestExpectation(description: "Video disabled report generation")
        
        Task {
            let report = try await customReporter.generateReport()
            XCTAssertEqual(report.videos.count, 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Error Handling Tests
    
    func testReportGenerationWithNoResults() {
        let expectation = XCTestExpectation(description: "Empty report generation")
        
        Task {
            let report = try await reporter.generateReport()
            
            XCTAssertEqual(report.summary.totalTests, 0)
            XCTAssertEqual(report.summary.passedTests, 0)
            XCTAssertEqual(report.summary.failedTests, 0)
            XCTAssertEqual(report.summary.skippedTests, 0)
            XCTAssertEqual(report.summary.successRate, 0.0)
            XCTAssertEqual(report.detailedResults.count, 0)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Helper Methods
    
    private func createSampleTestResult(
        status: TestStatus = .passed,
        testName: String = "SampleTest"
    ) -> TestResult {
        return TestResult(
            testName: testName,
            testClass: "SampleTestClass",
            status: status,
            executionTime: 2.5,
            startTime: Date(),
            endTime: Date().addingTimeInterval(2.5),
            errorMessage: status == .failed ? "Test failed" : nil,
            stackTrace: status == .failed ? "Stack trace here" : nil
        )
    }
} 