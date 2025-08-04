import Foundation
import XCTest

/// Comprehensive test reporting system for iOS Testing Automation Framework
public class TestReporter {
    
    // MARK: - Properties
    
    private let configuration: ReportingConfiguration
    private var testResults: [TestResult] = []
    private var performanceMetrics: [PerformanceMetric] = []
    private var screenshots: [Screenshot] = []
    private var videos: [Video] = []
    
    // MARK: - Initialization
    
    public init(configuration: ReportingConfiguration = ReportingConfiguration()) {
        self.configuration = configuration
    }
    
    // MARK: - Test Result Management
    
    /// Add a test result to the reporter
    public func addTestResult(_ result: TestResult) {
        testResults.append(result)
    }
    
    /// Add performance metrics
    public func addPerformanceMetric(_ metric: PerformanceMetric) {
        performanceMetrics.append(metric)
    }
    
    /// Add screenshot
    public func addScreenshot(_ screenshot: Screenshot) {
        if configuration.includeScreenshots {
            screenshots.append(screenshot)
        }
    }
    
    /// Add video recording
    public func addVideo(_ video: Video) {
        if configuration.includeVideos {
            videos.append(video)
        }
    }
    
    // MARK: - Report Generation
    
    /// Generate comprehensive test report
    public func generateReport() async throws -> TestReport {
        let summary = generateSummary()
        let detailedResults = generateDetailedResults()
        let performanceReport = generatePerformanceReport()
        let coverageReport = generateCoverageReport()
        
        return TestReport(
            summary: summary,
            detailedResults: detailedResults,
            performanceReport: performanceReport,
            coverageReport: coverageReport,
            screenshots: screenshots,
            videos: videos,
            generatedAt: Date()
        )
    }
    
    /// Generate HTML report
    public func generateHTMLReport() async throws -> String {
        let report = try await generateReport()
        return HTMLReportGenerator.generate(from: report)
    }
    
    /// Generate JSON report
    public func generateJSONReport() async throws -> Data {
        let report = try await generateReport()
        return try JSONEncoder().encode(report)
    }
    
    /// Generate JUnit XML report
    public func generateJUnitReport() async throws -> String {
        let report = try await generateReport()
        return JUnitReportGenerator.generate(from: report)
    }
    
    // MARK: - Private Methods
    
    private func generateSummary() -> TestSummary {
        let totalTests = testResults.count
        let passedTests = testResults.filter { $0.status == .passed }.count
        let failedTests = testResults.filter { $0.status == .failed }.count
        let skippedTests = testResults.filter { $0.status == .skipped }.count
        
        let successRate = totalTests > 0 ? Double(passedTests) / Double(totalTests) * 100 : 0
        let averageExecutionTime = testResults.map { $0.executionTime }.reduce(0, +) / Double(max(totalTests, 1))
        
        return TestSummary(
            totalTests: totalTests,
            passedTests: passedTests,
            failedTests: failedTests,
            skippedTests: skippedTests,
            successRate: successRate,
            averageExecutionTime: averageExecutionTime,
            totalExecutionTime: testResults.map { $0.executionTime }.reduce(0, +)
        )
    }
    
    private func generateDetailedResults() -> [TestResult] {
        return testResults.sorted { $0.executionTime > $1.executionTime }
    }
    
    private func generatePerformanceReport() -> PerformanceReport {
        let memoryMetrics = performanceMetrics.filter { $0.type == .memory }
        let cpuMetrics = performanceMetrics.filter { $0.type == .cpu }
        let networkMetrics = performanceMetrics.filter { $0.type == .network }
        let batteryMetrics = performanceMetrics.filter { $0.type == .battery }
        
        return PerformanceReport(
            memoryMetrics: memoryMetrics,
            cpuMetrics: cpuMetrics,
            networkMetrics: networkMetrics,
            batteryMetrics: batteryMetrics,
            averageMemoryUsage: calculateAverageMemoryUsage(),
            averageCPUUsage: calculateAverageCPUUsage(),
            peakMemoryUsage: calculatePeakMemoryUsage(),
            peakCPUUsage: calculatePeakCPUUsage()
        )
    }
    
    private func generateCoverageReport() -> CoverageReport {
        let totalLines = testResults.compactMap { $0.coverage?.totalLines }.reduce(0, +)
        let coveredLines = testResults.compactMap { $0.coverage?.coveredLines }.reduce(0, +)
        let coveragePercentage = totalLines > 0 ? Double(coveredLines) / Double(totalLines) * 100 : 0
        
        return CoverageReport(
            totalLines: totalLines,
            coveredLines: coveredLines,
            coveragePercentage: coveragePercentage,
            uncoveredFiles: testResults.compactMap { $0.coverage?.uncoveredFiles }.flatMap { $0 }
        )
    }
    
    private func calculateAverageMemoryUsage() -> Int64 {
        let memoryMetrics = performanceMetrics.filter { $0.type == .memory }
        guard !memoryMetrics.isEmpty else { return 0 }
        return memoryMetrics.map { $0.value }.reduce(0, +) / Int64(memoryMetrics.count)
    }
    
    private func calculateAverageCPUUsage() -> Double {
        let cpuMetrics = performanceMetrics.filter { $0.type == .cpu }
        guard !cpuMetrics.isEmpty else { return 0 }
        return cpuMetrics.map { $0.value }.reduce(0, +) / Double(cpuMetrics.count)
    }
    
    private func calculatePeakMemoryUsage() -> Int64 {
        let memoryMetrics = performanceMetrics.filter { $0.type == .memory }
        return memoryMetrics.map { $0.value }.max() ?? 0
    }
    
    private func calculatePeakCPUUsage() -> Double {
        let cpuMetrics = performanceMetrics.filter { $0.type == .cpu }
        return cpuMetrics.map { $0.value }.max() ?? 0
    }
}

// MARK: - Supporting Types

public struct TestResult {
    public let testName: String
    public let testClass: String
    public let status: TestStatus
    public let executionTime: TimeInterval
    public let startTime: Date
    public let endTime: Date
    public let errorMessage: String?
    public let stackTrace: String?
    public let coverage: CodeCoverage?
    public let performanceMetrics: [PerformanceMetric]
    public let screenshots: [Screenshot]
    
    public init(testName: String,
                testClass: String,
                status: TestStatus,
                executionTime: TimeInterval,
                startTime: Date,
                endTime: Date,
                errorMessage: String? = nil,
                stackTrace: String? = nil,
                coverage: CodeCoverage? = nil,
                performanceMetrics: [PerformanceMetric] = [],
                screenshots: [Screenshot] = []) {
        self.testName = testName
        self.testClass = testClass
        self.status = status
        self.executionTime = executionTime
        self.startTime = startTime
        self.endTime = endTime
        self.errorMessage = errorMessage
        self.stackTrace = stackTrace
        self.coverage = coverage
        self.performanceMetrics = performanceMetrics
        self.screenshots = screenshots
    }
}

public enum TestStatus: String, CaseIterable {
    case passed = "passed"
    case failed = "failed"
    case skipped = "skipped"
    case error = "error"
}

public struct TestSummary {
    public let totalTests: Int
    public let passedTests: Int
    public let failedTests: Int
    public let skippedTests: Int
    public let successRate: Double
    public let averageExecutionTime: TimeInterval
    public let totalExecutionTime: TimeInterval
}

public struct PerformanceMetric {
    public let type: MetricType
    public let value: Double
    public let timestamp: Date
    public let testName: String?
    
    public init(type: MetricType, value: Double, timestamp: Date, testName: String? = nil) {
        self.type = type
        self.value = value
        self.timestamp = timestamp
        self.testName = testName
    }
}

public enum MetricType: String, CaseIterable {
    case memory = "memory"
    case cpu = "cpu"
    case network = "network"
    case battery = "battery"
    case disk = "disk"
}

public struct PerformanceReport {
    public let memoryMetrics: [PerformanceMetric]
    public let cpuMetrics: [PerformanceMetric]
    public let networkMetrics: [PerformanceMetric]
    public let batteryMetrics: [PerformanceMetric]
    public let averageMemoryUsage: Int64
    public let averageCPUUsage: Double
    public let peakMemoryUsage: Int64
    public let peakCPUUsage: Double
}

public struct CodeCoverage {
    public let totalLines: Int
    public let coveredLines: Int
    public let uncoveredFiles: [String]
    public let coveragePercentage: Double
}

public struct CoverageReport {
    public let totalLines: Int
    public let coveredLines: Int
    public let coveragePercentage: Double
    public let uncoveredFiles: [String]
}

public struct Screenshot {
    public let name: String
    public let data: Data
    public let timestamp: Date
    public let testName: String
}

public struct Video {
    public let name: String
    public let url: URL
    public let duration: TimeInterval
    public let testName: String
}

public struct TestReport {
    public let summary: TestSummary
    public let detailedResults: [TestResult]
    public let performanceReport: PerformanceReport
    public let coverageReport: CoverageReport
    public let screenshots: [Screenshot]
    public let videos: [Video]
    public let generatedAt: Date
}

// MARK: - Report Generators

public class HTMLReportGenerator {
    public static func generate(from report: TestReport) -> String {
        // HTML report generation implementation
        return """
        <!DOCTYPE html>
        <html>
        <head>
            <title>iOS Testing Automation Framework - Test Report</title>
            <style>
                body { font-family: -apple-system, BlinkMacSystemFont, sans-serif; margin: 20px; }
                .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; border-radius: 10px; }
                .summary { background: #f8f9fa; padding: 20px; border-radius: 10px; margin: 20px 0; }
                .metric { display: inline-block; margin: 10px; padding: 15px; background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
                .success { color: #28a745; }
                .failure { color: #dc3545; }
                .warning { color: #ffc107; }
            </style>
        </head>
        <body>
            <div class="header">
                <h1>🧪 iOS Testing Automation Framework</h1>
                <p>Comprehensive Test Report</p>
            </div>
            <div class="summary">
                <h2>Test Summary</h2>
                <div class="metric">
                    <strong>Total Tests:</strong> \(report.summary.totalTests)
                </div>
                <div class="metric success">
                    <strong>Passed:</strong> \(report.summary.passedTests)
                </div>
                <div class="metric failure">
                    <strong>Failed:</strong> \(report.summary.failedTests)
                </div>
                <div class="metric warning">
                    <strong>Skipped:</strong> \(report.summary.skippedTests)
                </div>
                <div class="metric">
                    <strong>Success Rate:</strong> \(String(format: "%.1f%%", report.summary.successRate))
                </div>
            </div>
        </body>
        </html>
        """
    }
}

public class JUnitReportGenerator {
    public static func generate(from report: TestReport) -> String {
        // JUnit XML report generation implementation
        return """
        <?xml version="1.0" encoding="UTF-8"?>
        <testsuites name="iOS Testing Automation Framework">
            <testsuite name="Test Suite" tests="\(report.summary.totalTests)" failures="\(report.summary.failedTests)" skipped="\(report.summary.skippedTests)" time="\(report.summary.totalExecutionTime)">
                \(report.detailedResults.map { result in
                    """
                    <testcase name="\(result.testName)" classname="\(result.testClass)" time="\(result.executionTime)">
                        \(result.status == .failed ? "<failure message=\"\(result.errorMessage ?? "")\">\(result.stackTrace ?? "")</failure>" : "")
                    </testcase>
                    """
                }.joined(separator: "\n"))
            </testsuite>
        </testsuites>
        """
    }
} 