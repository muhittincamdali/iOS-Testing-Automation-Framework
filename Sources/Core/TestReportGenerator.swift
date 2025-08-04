import Foundation
import Logging

/// Test report generator for creating detailed test reports
@available(iOS 15.0, macOS 12.0, *)
public class TestReportGenerator {
    
    // MARK: - Properties
    
    /// Logger for report generation
    private let logger = Logger(label: "TestReportGenerator")
    
    /// Report configuration
    private var configuration: ReportConfiguration
    
    // MARK: - Initialization
    
    /// Initialize the test report generator
    /// - Parameter configuration: Configuration for report generation
    public init(configuration: ReportConfiguration = ReportConfiguration()) {
        self.configuration = configuration
        setupReportGenerator()
    }
    
    // MARK: - Public Methods
    
    /// Generate a comprehensive test report
    /// - Parameter results: Test execution results
    /// - Returns: Generated test report
    public func generateReport(for results: TestExecutionResults) -> TestReport {
        logger.info("Generating test report for \(results.totalCount) test results")
        
        let report = TestReport(
            id: UUID().uuidString,
            title: "Test Execution Report",
            description: "Comprehensive test execution report",
            timestamp: Date(),
            results: results,
            summary: generateSummary(from: results),
            details: generateDetails(from: results),
            metadata: generateMetadata(from: results)
        )
        
        logger.info("Test report generated successfully")
        return report
    }
    
    /// Generate multiple reports for different formats
    /// - Parameters:
    ///   - results: Test execution results
    ///   - startTime: Start time of test execution
    /// - Returns: Array of generated reports
    public func generateReports(for results: TestExecutionResults, startTime: Date) -> [TestReport] {
        var reports: [TestReport] = []
        
        // Generate summary report
        let summaryReport = generateSummaryReport(for: results, startTime: startTime)
        reports.append(summaryReport)
        
        // Generate detailed report
        let detailedReport = generateDetailedReport(for: results, startTime: startTime)
        reports.append(detailedReport)
        
        // Generate performance report
        let performanceReport = generatePerformanceReport(for: results, startTime: startTime)
        reports.append(performanceReport)
        
        return reports
    }
    
    /// Generate a report for a single test result
    /// - Parameters:
    ///   - result: Single test execution result
    ///   - startTime: Start time of test execution
    /// - Returns: Generated test report
    public func generateReport(for result: TestExecutionResult, startTime: Date) -> TestReport {
        let results = TestExecutionResults(results: [result])
        
        let report = TestReport(
            id: UUID().uuidString,
            title: "Single Test Report",
            description: "Report for single test execution",
            timestamp: Date(),
            results: results,
            summary: generateSummary(from: results),
            details: generateDetails(from: results),
            metadata: generateMetadata(from: results)
        )
        
        return report
    }
    
    /// Export test results to various formats
    /// - Parameters:
    ///   - results: Test execution results
    ///   - format: Export format
    ///   - path: Export file path
    public func exportResults(_ results: TestExecutionResults, format: ExportFormat, to path: String) throws {
        logger.info("Exporting test results to \(format) format at path: \(path)")
        
        switch format {
        case .json:
            try exportToJSON(results, to: path)
        case .html:
            try exportToHTML(results, to: path)
        case .pdf:
            try exportToPDF(results, to: path)
        case .xml:
            try exportToXML(results, to: path)
        }
        
        logger.info("Test results exported successfully to \(path)")
    }
    
    // MARK: - Private Methods
    
    private func setupReportGenerator() {
        logger.info("Test report generator initialized with configuration: \(configuration)")
    }
    
    private func generateSummary(from results: TestExecutionResults) -> TestReportSummary {
        let totalTests = results.totalCount
        let passedTests = results.passedCount
        let failedTests = results.failedCount
        let successRate = results.successRate
        
        let totalExecutionTime = results.results.reduce(0) { $0 + $1.executionTime }
        let averageExecutionTime = totalTests > 0 ? totalExecutionTime / Double(totalTests) : 0
        
        return TestReportSummary(
            totalTests: totalTests,
            passedTests: passedTests,
            failedTests: failedTests,
            successRate: successRate,
            totalExecutionTime: totalExecutionTime,
            averageExecutionTime: averageExecutionTime
        )
    }
    
    private func generateDetails(from results: TestExecutionResults) -> TestReportDetails {
        var details = TestReportDetails()
        
        for result in results.results {
            let testDetail = TestDetail(
                name: result.testCase.name,
                description: result.testCase.description,
                category: result.testCase.category,
                priority: result.testCase.priority,
                status: result.status,
                executionTime: result.executionTime,
                error: result.error?.localizedDescription,
                screenshotPath: result.screenshotPath
            )
            details.testDetails.append(testDetail)
        }
        
        return details
    }
    
    private func generateMetadata(from results: TestExecutionResults) -> TestReportMetadata {
        return TestReportMetadata(
            frameworkVersion: "1.0.0",
            platform: "iOS",
            deviceInfo: "Simulator",
            executionEnvironment: "Automated",
            timestamp: Date()
        )
    }
    
    private func generateSummaryReport(for results: TestExecutionResults, startTime: Date) -> TestReport {
        let summary = generateSummary(from: results)
        
        return TestReport(
            id: UUID().uuidString,
            title: "Test Execution Summary",
            description: "Summary report of test execution",
            timestamp: Date(),
            results: results,
            summary: summary,
            details: TestReportDetails(),
            metadata: generateMetadata(from: results)
        )
    }
    
    private func generateDetailedReport(for results: TestExecutionResults, startTime: Date) -> TestReport {
        let summary = generateSummary(from: results)
        let details = generateDetails(from: results)
        
        return TestReport(
            id: UUID().uuidString,
            title: "Detailed Test Report",
            description: "Detailed report of test execution",
            timestamp: Date(),
            results: results,
            summary: summary,
            details: details,
            metadata: generateMetadata(from: results)
        )
    }
    
    private func generatePerformanceReport(for results: TestExecutionResults, startTime: Date) -> TestReport {
        let summary = generateSummary(from: results)
        
        return TestReport(
            id: UUID().uuidString,
            title: "Performance Test Report",
            description: "Performance analysis of test execution",
            timestamp: Date(),
            results: results,
            summary: summary,
            details: TestReportDetails(),
            metadata: generateMetadata(from: results)
        )
    }
    
    private func exportToJSON(_ results: TestExecutionResults, to path: String) throws {
        let report = generateReport(for: results)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let data = try encoder.encode(report)
        try data.write(to: URL(fileURLWithPath: path))
    }
    
    private func exportToHTML(_ results: TestExecutionResults, to path: String) throws {
        let report = generateReport(for: results)
        let htmlContent = generateHTMLContent(for: report)
        try htmlContent.write(to: URL(fileURLWithPath: path), atomically: true, encoding: .utf8)
    }
    
    private func exportToPDF(_ results: TestExecutionResults, to path: String) throws {
        // PDF generation would require additional dependencies
        logger.warning("PDF export not implemented")
        throw ReportGenerationError.pdfExportNotSupported
    }
    
    private func exportToXML(_ results: TestExecutionResults, to path: String) throws {
        let report = generateReport(for: results)
        let xmlContent = generateXMLContent(for: report)
        try xmlContent.write(to: URL(fileURLWithPath: path), atomically: true, encoding: .utf8)
    }
    
    private func generateHTMLContent(for report: TestReport) -> String {
        return """
        <!DOCTYPE html>
        <html>
        <head>
            <title>\(report.title)</title>
            <style>
                body { font-family: Arial, sans-serif; margin: 20px; }
                .header { background-color: #f0f0f0; padding: 20px; border-radius: 5px; }
                .summary { margin: 20px 0; }
                .details { margin: 20px 0; }
                .test-result { margin: 10px 0; padding: 10px; border-left: 4px solid #ccc; }
                .passed { border-left-color: #4CAF50; }
                .failed { border-left-color: #f44336; }
            </style>
        </head>
        <body>
            <div class="header">
                <h1>\(report.title)</h1>
                <p>\(report.description)</p>
                <p>Generated: \(report.timestamp)</p>
            </div>
            
            <div class="summary">
                <h2>Summary</h2>
                <p>Total Tests: \(report.summary.totalTests)</p>
                <p>Passed: \(report.summary.passedTests)</p>
                <p>Failed: \(report.summary.failedTests)</p>
                <p>Success Rate: \(String(format: "%.2f", report.summary.successRate))%</p>
            </div>
            
            <div class="details">
                <h2>Test Details</h2>
                \(report.details.testDetails.map { detail in
                    """
                    <div class="test-result \(detail.status == .passed ? "passed" : "failed")">
                        <h3>\(detail.name)</h3>
                        <p>Status: \(detail.status)</p>
                        <p>Execution Time: \(String(format: "%.2f", detail.executionTime))s</p>
                    </div>
                    """
                }.joined(separator: "\n"))
            </div>
        </body>
        </html>
        """
    }
    
    private func generateXMLContent(for report: TestReport) -> String {
        return """
        <?xml version="1.0" encoding="UTF-8"?>
        <testReport>
            <title>\(report.title)</title>
            <description>\(report.description)</description>
            <timestamp>\(report.timestamp)</timestamp>
            <summary>
                <totalTests>\(report.summary.totalTests)</totalTests>
                <passedTests>\(report.summary.passedTests)</passedTests>
                <failedTests>\(report.summary.failedTests)</failedTests>
                <successRate>\(report.summary.successRate)</successRate>
            </summary>
        </testReport>
        """
    }
}

// MARK: - Supporting Types

/// Test report structure
public struct TestReport {
    /// Unique identifier for the report
    public let id: String
    
    /// Title of the report
    public let title: String
    
    /// Description of the report
    public let description: String
    
    /// Timestamp when the report was generated
    public let timestamp: Date
    
    /// Test execution results
    public let results: TestExecutionResults
    
    /// Summary of the test execution
    public let summary: TestReportSummary
    
    /// Detailed information about each test
    public let details: TestReportDetails
    
    /// Metadata about the report
    public let metadata: TestReportMetadata
    
    public init(
        id: String,
        title: String,
        description: String,
        timestamp: Date,
        results: TestExecutionResults,
        summary: TestReportSummary,
        details: TestReportDetails,
        metadata: TestReportMetadata
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.timestamp = timestamp
        self.results = results
        self.summary = summary
        self.details = details
        self.metadata = metadata
    }
}

/// Test report summary
public struct TestReportSummary {
    /// Total number of tests
    public let totalTests: Int
    
    /// Number of tests that passed
    public let passedTests: Int
    
    /// Number of tests that failed
    public let failedTests: Int
    
    /// Success rate as percentage
    public let successRate: Double
    
    /// Total execution time in seconds
    public let totalExecutionTime: TimeInterval
    
    /// Average execution time in seconds
    public let averageExecutionTime: TimeInterval
    
    public init(
        totalTests: Int,
        passedTests: Int,
        failedTests: Int,
        successRate: Double,
        totalExecutionTime: TimeInterval,
        averageExecutionTime: TimeInterval
    ) {
        self.totalTests = totalTests
        self.passedTests = passedTests
        self.failedTests = failedTests
        self.successRate = successRate
        self.totalExecutionTime = totalExecutionTime
        self.averageExecutionTime = averageExecutionTime
    }
}

/// Test report details
public struct TestReportDetails {
    /// Detailed information about each test
    public var testDetails: [TestDetail] = []
    
    public init() {}
}

/// Individual test detail
public struct TestDetail {
    /// Name of the test
    public let name: String
    
    /// Description of the test
    public let description: String
    
    /// Category of the test
    public let category: TestCategory
    
    /// Priority of the test
    public let priority: TestPriority
    
    /// Status of the test
    public let status: TestStatus
    
    /// Execution time in seconds
    public let executionTime: TimeInterval
    
    /// Error message if the test failed
    public let error: String?
    
    /// Path to screenshot if available
    public let screenshotPath: String?
    
    public init(
        name: String,
        description: String,
        category: TestCategory,
        priority: TestPriority,
        status: TestStatus,
        executionTime: TimeInterval,
        error: String?,
        screenshotPath: String?
    ) {
        self.name = name
        self.description = description
        self.category = category
        self.priority = priority
        self.status = status
        self.executionTime = executionTime
        self.error = error
        self.screenshotPath = screenshotPath
    }
}

/// Test report metadata
public struct TestReportMetadata {
    /// Version of the testing framework
    public let frameworkVersion: String
    
    /// Platform where tests were executed
    public let platform: String
    
    /// Device information
    public let deviceInfo: String
    
    /// Execution environment
    public let executionEnvironment: String
    
    /// Timestamp of report generation
    public let timestamp: Date
    
    public init(
        frameworkVersion: String,
        platform: String,
        deviceInfo: String,
        executionEnvironment: String,
        timestamp: Date
    ) {
        self.frameworkVersion = frameworkVersion
        self.platform = platform
        self.deviceInfo = deviceInfo
        self.executionEnvironment = executionEnvironment
        self.timestamp = timestamp
    }
}

/// Configuration for report generation
public struct ReportConfiguration {
    /// Whether to include detailed information
    public let includeDetails: Bool
    
    /// Whether to include screenshots
    public let includeScreenshots: Bool
    
    /// Whether to include performance metrics
    public let includePerformanceMetrics: Bool
    
    /// Report format
    public let format: ExportFormat
    
    public init(
        includeDetails: Bool = true,
        includeScreenshots: Bool = true,
        includePerformanceMetrics: Bool = true,
        format: ExportFormat = .html
    ) {
        self.includeDetails = includeDetails
        self.includeScreenshots = includeScreenshots
        self.includePerformanceMetrics = includePerformanceMetrics
        self.format = format
    }
}

/// Report generation errors
public enum ReportGenerationError: Error, LocalizedError {
    case pdfExportNotSupported
    case invalidExportPath
    case encodingError
    
    public var errorDescription: String? {
        switch self {
        case .pdfExportNotSupported:
            return "PDF export is not supported"
        case .invalidExportPath:
            return "Invalid export path"
        case .encodingError:
            return "Error encoding report data"
        }
    }
} 