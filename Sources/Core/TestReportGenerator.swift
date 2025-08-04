import Foundation
import Logging

/// Generates comprehensive test reports and analytics
@available(iOS 15.0, macOS 12.0, *)
public class TestReportGenerator {
    
    // MARK: - Properties
    
    private let logger = Logger(label: "TestReportGenerator")
    private let dateFormatter: DateFormatter
    
    // MARK: - Initialization
    
    public init() {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        logger.info("TestReportGenerator initialized")
    }
    
    // MARK: - Public Methods
    
    /// Generate a comprehensive test report from test suite results
    public func generateReport(from results: [TestSuiteResults]) -> TestReport {
        logger.info("Generating test report from \(results.count) test suites")
        
        let allResults = results.flatMap { $0.results }
        let totalTests = allResults.count
        let passedTests = allResults.filter { $0.status == .passed }.count
        let failedTests = allResults.filter { $0.status == .failed }.count
        let successRate = totalTests > 0 ? Double(passedTests) / Double(totalTests) * 100.0 : 0.0
        let totalExecutionTime = allResults.reduce(0) { $0 + $1.executionTime }
        
        // Calculate performance metrics
        let performanceMetrics = calculatePerformanceMetrics(from: allResults)
        
        let report = TestReport(
            totalTests: totalTests,
            passedTests: passedTests,
            failedTests: failedTests,
            successRate: successRate,
            totalExecutionTime: totalExecutionTime,
            performanceMetrics: performanceMetrics,
            detailedResults: allResults
        )
        
        logger.info("Test report generated: \(passedTests)/\(totalTests) passed (\(String(format: "%.1f", successRate))%)")
        return report
    }
    
    /// Generate a detailed HTML report
    public func generateHTMLReport(from report: TestReport) -> String {
        logger.info("Generating HTML report")
        
        let html = """
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>iOS Testing Automation Framework - Test Report</title>
            <style>
                body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; margin: 0; padding: 20px; background: #f5f5f7; }
                .container { max-width: 1200px; margin: 0 auto; background: white; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); overflow: hidden; }
                .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; }
                .header h1 { margin: 0; font-size: 2.5em; font-weight: 300; }
                .header p { margin: 10px 0 0; opacity: 0.9; font-size: 1.1em; }
                .summary { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; padding: 30px; }
                .metric { background: #f8f9fa; padding: 20px; border-radius: 8px; text-align: center; }
                .metric h3 { margin: 0 0 10px; color: #333; font-size: 1.2em; }
                .metric .value { font-size: 2em; font-weight: bold; color: #007AFF; }
                .metric .label { color: #666; font-size: 0.9em; margin-top: 5px; }
                .success { color: #34C759; }
                .failure { color: #FF3B30; }
                .details { padding: 30px; }
                .details h2 { color: #333; margin-bottom: 20px; }
                .test-result { padding: 15px; margin: 10px 0; border-radius: 6px; border-left: 4px solid; }
                .test-result.passed { background: #f0fff4; border-left-color: #34C759; }
                .test-result.failed { background: #fff5f5; border-left-color: #FF3B30; }
                .test-result h4 { margin: 0 0 5px; color: #333; }
                .test-result p { margin: 0; color: #666; font-size: 0.9em; }
                .performance { background: #f8f9fa; padding: 20px; margin: 20px 0; border-radius: 8px; }
                .performance h3 { margin: 0 0 15px; color: #333; }
                .performance-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 15px; }
                .performance-item { text-align: center; }
                .performance-item .value { font-size: 1.5em; font-weight: bold; color: #007AFF; }
                .performance-item .label { color: #666; font-size: 0.8em; margin-top: 5px; }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="header">
                    <h1>🧪 iOS Testing Automation Framework</h1>
                    <p>Comprehensive Test Report</p>
                </div>
                
                <div class="summary">
                    <div class="metric">
                        <h3>Total Tests</h3>
                        <div class="value">\(report.totalTests)</div>
                        <div class="label">Executed</div>
                    </div>
                    <div class="metric">
                        <h3>Passed</h3>
                        <div class="value success">\(report.passedTests)</div>
                        <div class="label">Successful</div>
                    </div>
                    <div class="metric">
                        <h3>Failed</h3>
                        <div class="value failure">\(report.failedTests)</div>
                        <div class="label">Errors</div>
                    </div>
                    <div class="metric">
                        <h3>Success Rate</h3>
                        <div class="value">\(String(format: "%.1f", report.successRate))%</div>
                        <div class="label">Overall</div>
                    </div>
                    <div class="metric">
                        <h3>Execution Time</h3>
                        <div class="value">\(String(format: "%.2f", report.totalExecutionTime))s</div>
                        <div class="label">Total</div>
                    </div>
                    <div class="metric">
                        <h3>Performance Score</h3>
                        <div class="value">\(String(format: "%.0f", report.performanceMetrics.performanceScore))</div>
                        <div class="label">Out of 100</div>
                    </div>
                </div>
                
                <div class="details">
                    <h2>Performance Metrics</h2>
                    <div class="performance">
                        <h3>System Performance</h3>
                        <div class="performance-grid">
                            <div class="performance-item">
                                <div class="value">\(String(format: "%.1f", report.performanceMetrics.memoryUsageMB))</div>
                                <div class="label">Memory (MB)</div>
                            </div>
                            <div class="performance-item">
                                <div class="value">\(String(format: "%.1f", report.performanceMetrics.cpuUsage))%</div>
                                <div class="label">CPU Usage</div>
                            </div>
                            <div class="performance-item">
                                <div class="value">\(String(format: "%.1f", report.performanceMetrics.frameRate))</div>
                                <div class="label">Frame Rate (FPS)</div>
                            </div>
                            <div class="performance-item">
                                <div class="value">\(report.performanceMetrics.isPerformanceAcceptable ? "✅" : "❌")</div>
                                <div class="label">Performance OK</div>
                            </div>
                        </div>
                    </div>
                    
                    <h2>Test Results</h2>
                    \(generateTestResultsHTML(from: report.detailedResults))
                </div>
            </div>
        </body>
        </html>
        """
        
        return html
    }
    
    /// Generate a JSON report
    public func generateJSONReport(from report: TestReport) -> Data? {
        logger.info("Generating JSON report")
        
        let reportData: [String: Any] = [
            "report": [
                "totalTests": report.totalTests,
                "passedTests": report.passedTests,
                "failedTests": report.failedTests,
                "successRate": report.successRate,
                "totalExecutionTime": report.totalExecutionTime,
                "generatedAt": dateFormatter.string(from: Date()),
                "performanceMetrics": [
                    "memoryUsageMB": report.performanceMetrics.memoryUsageMB,
                    "cpuUsage": report.performanceMetrics.cpuUsage,
                    "frameRate": report.performanceMetrics.frameRate,
                    "performanceScore": report.performanceMetrics.performanceScore,
                    "isPerformanceAcceptable": report.performanceMetrics.isPerformanceAcceptable
                ],
                "testResults": report.detailedResults.map { result in
                    [
                        "name": result.testCase.name,
                        "description": result.testCase.description,
                        "status": result.status == .passed ? "passed" : "failed",
                        "executionTime": result.executionTime,
                        "error": result.error?.localizedDescription ?? ""
                    ]
                }
            ]
        ]
        
        return try? JSONSerialization.data(withJSONObject: reportData, options: .prettyPrinted)
    }
    
    /// Save report to file
    public func saveReport(_ report: TestReport, to path: String, format: ReportFormat = .html) throws {
        logger.info("Saving report to: \(path)")
        
        let content: String
        
        switch format {
        case .html:
            content = generateHTMLReport(from: report)
        case .json:
            guard let jsonData = generateJSONReport(from: report),
                  let jsonString = String(data: jsonData, encoding: .utf8) else {
                throw ReportGenerationError.jsonSerializationFailed
            }
            content = jsonString
        case .text:
            content = generateTextReport(from: report)
        }
        
        try content.write(toFile: path, atomically: true, encoding: .utf8)
        logger.info("Report saved successfully to: \(path)")
    }
    
    // MARK: - Private Methods
    
    private func calculatePerformanceMetrics(from results: [TestResult]) -> PerformanceMetrics {
        let totalExecutionTime = results.reduce(0) { $0 + $1.executionTime }
        let averageExecutionTime = results.isEmpty ? 0 : totalExecutionTime / Double(results.count)
        
        // Calculate performance score based on execution times
        let performanceScore = calculatePerformanceScore(from: results)
        
        return PerformanceMetrics(
            memoryUsage: 0, // Will be updated by PerformanceMonitor
            peakMemoryUsage: 0,
            cpuUsage: 0,
            peakCPUUsage: 0,
            frameRate: 60.0, // Default frame rate
            averageFrameRate: 60.0,
            totalExecutionTime: totalExecutionTime,
            customMetrics: [
                "averageExecutionTime": averageExecutionTime,
                "performanceScore": performanceScore
            ]
        )
    }
    
    private func calculatePerformanceScore(from results: [TestResult]) -> Double {
        guard !results.isEmpty else { return 0.0 }
        
        let executionTimes = results.map { $0.executionTime }
        let averageTime = executionTimes.reduce(0, +) / Double(executionTimes.count)
        let maxTime = executionTimes.max() ?? 0
        
        // Score based on execution efficiency
        var score = 100.0
        
        // Penalty for slow execution
        if averageTime > 5.0 {
            score -= min(30, (averageTime - 5.0) * 5)
        }
        
        // Penalty for very slow individual tests
        if maxTime > 10.0 {
            score -= min(20, (maxTime - 10.0) * 2)
        }
        
        // Bonus for fast execution
        if averageTime < 1.0 {
            score += min(10, (1.0 - averageTime) * 10)
        }
        
        return max(0, min(100, score))
    }
    
    private func generateTestResultsHTML(from results: [TestResult]) -> String {
        var html = ""
        
        for result in results {
            let statusClass = result.status == .passed ? "passed" : "failed"
            let statusIcon = result.status == .passed ? "✅" : "❌"
            
            html += """
            <div class="test-result \(statusClass)">
                <h4>\(statusIcon) \(result.testCase.name)</h4>
                <p>\(result.testCase.description)</p>
                <p>Execution time: \(String(format: "%.2f", result.executionTime))s</p>
                \(result.error != nil ? "<p>Error: \(result.error!.localizedDescription)</p>" : "")
            </div>
            """
        }
        
        return html
    }
    
    private func generateTextReport(from report: TestReport) -> String {
        return """
        iOS Testing Automation Framework - Test Report
        =============================================
        
        Summary:
        - Total Tests: \(report.totalTests)
        - Passed: \(report.passedTests)
        - Failed: \(report.failedTests)
        - Success Rate: \(String(format: "%.1f", report.successRate))%
        - Total Execution Time: \(String(format: "%.2f", report.totalExecutionTime))s
        - Performance Score: \(String(format: "%.0f", report.performanceMetrics.performanceScore))/100
        
        Performance Metrics:
        - Memory Usage: \(String(format: "%.1f", report.performanceMetrics.memoryUsageMB)) MB
        - CPU Usage: \(String(format: "%.1f", report.performanceMetrics.cpuUsage))%
        - Frame Rate: \(String(format: "%.1f", report.performanceMetrics.frameRate)) FPS
        - Performance Acceptable: \(report.performanceMetrics.isPerformanceAcceptable ? "Yes" : "No")
        
        Detailed Results:
        \(report.detailedResults.map { result in
            let status = result.status == .passed ? "PASS" : "FAIL"
            return "- [\(status)] \(result.testCase.name) (\(String(format: "%.2f", result.executionTime))s)"
        }.joined(separator: "\n"))
        
        Generated at: \(dateFormatter.string(from: Date()))
        """
    }
}

// MARK: - Report Format

public enum ReportFormat {
    case html
    case json
    case text
}

// MARK: - Report Generation Errors

public enum ReportGenerationError: Error, LocalizedError {
    case jsonSerializationFailed
    case fileWriteFailed
    
    public var errorDescription: String? {
        switch self {
        case .jsonSerializationFailed:
            return "Failed to serialize JSON report"
        case .fileWriteFailed:
            return "Failed to write report to file"
        }
    }
} 