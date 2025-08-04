import Foundation
import iOSTestingAutomationFramework

/// Performance Testing Example
/// This example demonstrates how to create and run performance tests using the iOS Testing Automation Framework
@available(iOS 15.0, macOS 12.0, *)
public class PerformanceTestExample {
    
    // MARK: - Properties
    
    /// Test automation framework instance
    private let testFramework = TestAutomationFramework()
    
    /// Test suite for performance tests
    private var performanceTestSuite: TestSuite!
    
    // MARK: - Initialization
    
    public init() {
        setupTestFramework()
        createPerformanceTestSuite()
    }
    
    // MARK: - Setup
    
    /// Setup the test framework with performance monitoring
    private func setupTestFramework() {
        testFramework.configure(
            enableParallelExecution: false, // Disable parallel execution for accurate performance measurement
            enableVisualTesting: false,
            enablePerformanceMonitoring: true,
            enableSecurityTesting: false,
            maxRetryCount: 1, // Single run for performance tests
            timeoutInterval: 60.0,
            screenshotOnFailure: false,
            videoRecording: false
        )
        
        // Enable performance monitoring
        testFramework.enablePerformanceMonitoring()
        
        print("✅ Performance test framework configured successfully")
    }
    
    /// Create performance test suite with various test cases
    private func createPerformanceTestSuite() {
        let appLaunchTest = TestCase(
            name: "App Launch Performance Test",
            description: "Test app launch time and performance",
            category: .performance,
            priority: .critical,
            tags: ["launch", "performance", "critical"],
            executionBlock: {
                try await self.testAppLaunchPerformance()
            },
            expectedExecutionTime: 30.0,
            isEnabled: true
        )
        
        let memoryUsageTest = TestCase(
            name: "Memory Usage Performance Test",
            description: "Test memory usage and memory leaks",
            category: .performance,
            priority: .high,
            tags: ["memory", "performance", "leaks"],
            executionBlock: {
                try await self.testMemoryUsagePerformance()
            },
            expectedExecutionTime: 45.0,
            isEnabled: true
        )
        
        let cpuUsageTest = TestCase(
            name: "CPU Usage Performance Test",
            description: "Test CPU usage and performance",
            category: .performance,
            priority: .high,
            tags: ["cpu", "performance"],
            executionBlock: {
                try await self.testCPUUsagePerformance()
            },
            expectedExecutionTime: 40.0,
            isEnabled: true
        )
        
        let networkPerformanceTest = TestCase(
            name: "Network Performance Test",
            description: "Test network request performance and latency",
            category: .performance,
            priority: .medium,
            tags: ["network", "performance", "latency"],
            executionBlock: {
                try await self.testNetworkPerformance()
            },
            expectedExecutionTime: 35.0,
            isEnabled: true
        )
        
        let databasePerformanceTest = TestCase(
            name: "Database Performance Test",
            description: "Test database operations performance",
            category: .performance,
            priority: .medium,
            tags: ["database", "performance", "operations"],
            executionBlock: {
                try await self.testDatabasePerformance()
            },
            expectedExecutionTime: 50.0,
            isEnabled: true
        )
        
        let uiResponsivenessTest = TestCase(
            name: "UI Responsiveness Test",
            description: "Test UI responsiveness and frame rate",
            category: .performance,
            priority: .high,
            tags: ["ui", "responsiveness", "fps"],
            executionBlock: {
                try await self.testUIResponsiveness()
            },
            expectedExecutionTime: 25.0,
            isEnabled: true
        )
        
        performanceTestSuite = TestSuite(
            name: "Performance Test Suite",
            description: "Comprehensive performance testing suite for app optimization",
            testCases: [appLaunchTest, memoryUsageTest, cpuUsageTest, networkPerformanceTest, databasePerformanceTest, uiResponsivenessTest],
            configuration: TestSuiteConfiguration(
                enableParallelExecution: false,
                maxConcurrentExecutions: 1,
                stopOnFirstFailure: false,
                retryFailedTests: false,
                maxRetryCount: 1,
                timeout: 600.0,
                generateDetailedReports: true,
                captureScreenshotsOnFailure: false,
                recordVideo: false
            ),
            tags: ["performance", "optimization", "automation"],
            isEnabled: true
        )
        
        print("✅ Performance test suite created with \(performanceTestSuite.testCaseCount) test cases")
    }
    
    // MARK: - Test Execution
    
    /// Run all performance tests
    public func runAllPerformanceTests() async throws {
        print("🚀 Starting performance test execution...")
        
        let startTime = Date()
        
        do {
            let results = try await testFramework.runTests(performanceTestSuite)
            
            let executionTime = Date().timeIntervalSince(startTime)
            
            print("📊 Performance Test Results:")
            print("   Total Tests: \(results.totalCount)")
            print("   Passed: \(results.passedCount)")
            print("   Failed: \(results.failedCount)")
            print("   Success Rate: \(String(format: "%.1f", results.successRate))%")
            print("   Total Execution Time: \(String(format: "%.2f", executionTime))s")
            
            // Get performance metrics
            let metrics = testFramework.getPerformanceMetrics()
            printPerformanceMetrics(metrics)
            
            if results.failedCount > 0 {
                print("❌ Some performance tests failed. Check the detailed report for more information.")
            } else {
                print("✅ All performance tests passed successfully!")
            }
            
            // Generate and export report
            let report = testFramework.generateReport(for: results)
            try testFramework.exportResults(results, format: .html, to: "performance_test_report.html")
            
            print("📄 Performance test report generated: performance_test_report.html")
            
        } catch {
            print("❌ Performance test execution failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    /// Run specific performance test by name
    /// - Parameter testName: Name of the test to run
    public func runPerformanceTest(named testName: String) async throws {
        guard let testCase = performanceTestSuite.testCases.first(where: { $0.name == testName }) else {
            print("❌ Performance test '\(testName)' not found")
            return
        }
        
        print("🎯 Running specific performance test: \(testName)")
        
        do {
            let result = try await testFramework.runTest(testCase)
            
            print("📊 Performance Test Result:")
            print("   Test: \(result.testCase.name)")
            print("   Status: \(result.status)")
            print("   Execution Time: \(String(format: "%.2f", result.executionTime))s")
            
            if result.status == .passed {
                print("✅ Performance test passed successfully!")
            } else {
                print("❌ Performance test failed: \(result.error?.localizedDescription ?? "Unknown error")")
            }
            
        } catch {
            print("❌ Performance test execution failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Individual Performance Test Implementations
    
    /// Test app launch performance
    private func testAppLaunchPerformance() async throws {
        print("   🚀 Testing app launch performance...")
        
        let launchStartTime = Date()
        
        // Simulate app launch
        try await simulateAppLaunch()
        
        let launchTime = Date().timeIntervalSince(launchStartTime)
        
        // Record performance metrics
        testFramework.getPerformanceMetrics().testExecutionTimes.append(launchTime)
        
        // Validate launch time
        if launchTime > 3.0 {
            throw PerformanceTestError.launchTimeExceeded(launchTime)
        }
        
        print("   ✅ App launch performance test completed - Launch time: \(String(format: "%.2f", launchTime))s")
    }
    
    /// Test memory usage performance
    private func testMemoryUsagePerformance() async throws {
        print("   💾 Testing memory usage performance...")
        
        let initialMemory = getCurrentMemoryUsage()
        
        // Simulate memory-intensive operations
        try await simulateMemoryIntensiveOperations()
        
        let finalMemory = getCurrentMemoryUsage()
        let memoryIncrease = finalMemory - initialMemory
        
        // Record memory metrics
        testFramework.getPerformanceMetrics().memoryUsageSamples.append(finalMemory)
        
        // Validate memory usage
        if memoryIncrease > 100.0 { // 100MB threshold
            throw PerformanceTestError.memoryUsageExceeded(memoryIncrease)
        }
        
        print("   ✅ Memory usage performance test completed - Memory increase: \(String(format: "%.2f", memoryIncrease))MB")
    }
    
    /// Test CPU usage performance
    private func testCPUUsagePerformance() async throws {
        print("   🔥 Testing CPU usage performance...")
        
        let initialCPU = getCurrentCPUUsage()
        
        // Simulate CPU-intensive operations
        try await simulateCPUIntensiveOperations()
        
        let finalCPU = getCurrentCPUUsage()
        let averageCPU = (initialCPU + finalCPU) / 2.0
        
        // Record CPU metrics
        testFramework.getPerformanceMetrics().cpuUsageSamples.append(averageCPU)
        
        // Validate CPU usage
        if averageCPU > 80.0 { // 80% threshold
            throw PerformanceTestError.cpuUsageExceeded(averageCPU)
        }
        
        print("   ✅ CPU usage performance test completed - Average CPU: \(String(format: "%.1f", averageCPU))%")
    }
    
    /// Test network performance
    private func testNetworkPerformance() async throws {
        print("   🌐 Testing network performance...")
        
        let networkStartTime = Date()
        
        // Simulate network requests
        try await simulateNetworkRequests()
        
        let networkTime = Date().timeIntervalSince(networkStartTime)
        
        // Record network metrics
        testFramework.getPerformanceMetrics().networkRequestTimes.append(networkTime)
        
        // Validate network performance
        if networkTime > 5.0 { // 5 second threshold
            throw PerformanceTestError.networkTimeout(networkTime)
        }
        
        print("   ✅ Network performance test completed - Network time: \(String(format: "%.2f", networkTime))s")
    }
    
    /// Test database performance
    private func testDatabasePerformance() async throws {
        print("   🗄️ Testing database performance...")
        
        let dbStartTime = Date()
        
        // Simulate database operations
        try await simulateDatabaseOperations()
        
        let dbTime = Date().timeIntervalSince(dbStartTime)
        
        // Record database metrics
        testFramework.getPerformanceMetrics().testExecutionTimes.append(dbTime)
        
        // Validate database performance
        if dbTime > 10.0 { // 10 second threshold
            throw PerformanceTestError.databaseTimeout(dbTime)
        }
        
        print("   ✅ Database performance test completed - Database time: \(String(format: "%.2f", dbTime))s")
    }
    
    /// Test UI responsiveness
    private func testUIResponsiveness() async throws {
        print("   🎨 Testing UI responsiveness...")
        
        let uiStartTime = Date()
        
        // Simulate UI interactions
        try await simulateUIInteractions()
        
        let uiTime = Date().timeIntervalSince(uiStartTime)
        
        // Record UI metrics
        testFramework.getPerformanceMetrics().testExecutionTimes.append(uiTime)
        
        // Validate UI responsiveness
        if uiTime > 2.0 { // 2 second threshold
            throw PerformanceTestError.uiResponsivenessExceeded(uiTime)
        }
        
        print("   ✅ UI responsiveness test completed - UI time: \(String(format: "%.2f", uiTime))s")
    }
    
    // MARK: - Simulation Methods
    
    private func simulateAppLaunch() async throws {
        // Simulate app launch process
        try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
    }
    
    private func simulateMemoryIntensiveOperations() async throws {
        // Simulate memory-intensive operations
        for _ in 0..<10 {
            try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
        }
    }
    
    private func simulateCPUIntensiveOperations() async throws {
        // Simulate CPU-intensive operations
        for _ in 0..<5 {
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        }
    }
    
    private func simulateNetworkRequests() async throws {
        // Simulate network requests
        for _ in 0..<3 {
            try await Task.sleep(nanoseconds: 800_000_000) // 0.8 seconds
        }
    }
    
    private func simulateDatabaseOperations() async throws {
        // Simulate database operations
        for _ in 0..<5 {
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        }
    }
    
    private func simulateUIInteractions() async throws {
        // Simulate UI interactions
        for _ in 0..<3 {
            try await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
        }
    }
    
    // MARK: - Utility Methods
    
    private func getCurrentMemoryUsage() -> Double {
        // Simulate memory usage measurement
        return Double.random(in: 50.0...200.0)
    }
    
    private func getCurrentCPUUsage() -> Double {
        // Simulate CPU usage measurement
        return Double.random(in: 10.0...60.0)
    }
    
    private func printPerformanceMetrics(_ metrics: PerformanceMetrics) {
        print("📈 Performance Metrics:")
        print("   Total Tests Executed: \(metrics.totalTestsExecuted)")
        print("   Average Execution Time: \(String(format: "%.2f", metrics.averageExecutionTime))ms")
        print("   Min Execution Time: \(String(format: "%.2f", metrics.minExecutionTime))ms")
        print("   Max Execution Time: \(String(format: "%.2f", metrics.maxExecutionTime))ms")
        print("   Average Memory Usage: \(String(format: "%.2f", metrics.averageMemoryUsage))MB")
        print("   Average CPU Usage: \(String(format: "%.1f", metrics.averageCPUUsage))%")
        print("   Average Network Request Time: \(String(format: "%.2f", metrics.averageNetworkRequestTime))ms")
    }
}

// MARK: - Performance Test Errors

public enum PerformanceTestError: Error, LocalizedError {
    case launchTimeExceeded(TimeInterval)
    case memoryUsageExceeded(Double)
    case cpuUsageExceeded(Double)
    case networkTimeout(TimeInterval)
    case databaseTimeout(TimeInterval)
    case uiResponsivenessExceeded(TimeInterval)
    
    public var errorDescription: String? {
        switch self {
        case .launchTimeExceeded(let time):
            return "App launch time exceeded threshold: \(String(format: "%.2f", time))s"
        case .memoryUsageExceeded(let usage):
            return "Memory usage exceeded threshold: \(String(format: "%.2f", usage))MB"
        case .cpuUsageExceeded(let usage):
            return "CPU usage exceeded threshold: \(String(format: "%.1f", usage))%"
        case .networkTimeout(let time):
            return "Network request timeout: \(String(format: "%.2f", time))s"
        case .databaseTimeout(let time):
            return "Database operation timeout: \(String(format: "%.2f", time))s"
        case .uiResponsivenessExceeded(let time):
            return "UI responsiveness exceeded threshold: \(String(format: "%.2f", time))s"
        }
    }
}

// MARK: - Usage Example

/// Example usage of the PerformanceTestExample
@available(iOS 15.0, macOS 12.0, *)
public func runPerformanceTestExample() async {
    print("🎯 Performance Test Example")
    print("===========================")
    
    let example = PerformanceTestExample()
    
    do {
        // Run all performance tests
        try await example.runAllPerformanceTests()
        
        // Run specific performance test
        try await example.runPerformanceTest(named: "App Launch Performance Test")
        
    } catch {
        print("❌ Performance test example execution failed: \(error.localizedDescription)")
    }
} 