import Foundation
import Metrics

/// Performance monitoring system for tracking test execution metrics
@available(iOS 15.0, macOS 12.0, *)
public class PerformanceMonitor {
    
    // MARK: - Properties
    
    /// Whether performance monitoring is enabled
    private var isEnabled: Bool = false
    
    /// Start time of monitoring
    private var startTime: Date?
    
    /// Performance metrics collection
    private var metrics: PerformanceMetrics
    
    /// Logger for performance monitoring
    private let logger = Logger(label: "PerformanceMonitor")
    
    // MARK: - Initialization
    
    /// Initialize the performance monitor
    public init() {
        self.metrics = PerformanceMetrics()
        setupMetrics()
    }
    
    // MARK: - Public Methods
    
    /// Enable performance monitoring
    public func enable() {
        isEnabled = true
        startTime = Date()
        logger.info("Performance monitoring enabled")
    }
    
    /// Disable performance monitoring
    public func disable() {
        isEnabled = false
        startTime = nil
        logger.info("Performance monitoring disabled")
    }
    
    /// Start monitoring performance
    public func startMonitoring() {
        guard isEnabled else {
            logger.warning("Performance monitoring is not enabled")
            return
        }
        
        startTime = Date()
        resetMetrics()
        logger.info("Performance monitoring started")
    }
    
    /// Stop monitoring performance
    public func stopMonitoring() {
        guard isEnabled else {
            logger.warning("Performance monitoring is not enabled")
            return
        }
        
        updateMetrics()
        startTime = nil
        logger.info("Performance monitoring stopped")
    }
    
    /// Get current performance metrics
    /// - Returns: Performance metrics object
    public func getMetrics() -> PerformanceMetrics {
        updateMetrics()
        return metrics
    }
    
    /// Record a test execution time
    /// - Parameter executionTime: Time taken to execute the test
    public func recordTestExecutionTime(_ executionTime: TimeInterval) {
        guard isEnabled else { return }
        
        metrics.testExecutionTimes.append(executionTime)
        metrics.totalTestsExecuted += 1
        
        if executionTime > metrics.maxExecutionTime {
            metrics.maxExecutionTime = executionTime
        }
        
        if executionTime < metrics.minExecutionTime || metrics.minExecutionTime == 0 {
            metrics.minExecutionTime = executionTime
        }
        
        updateAverageExecutionTime()
    }
    
    /// Record memory usage
    /// - Parameter memoryUsage: Memory usage in MB
    public func recordMemoryUsage(_ memoryUsage: Double) {
        guard isEnabled else { return }
        
        metrics.memoryUsageSamples.append(memoryUsage)
        
        if memoryUsage > metrics.maxMemoryUsage {
            metrics.maxMemoryUsage = memoryUsage
        }
        
        if memoryUsage < metrics.minMemoryUsage || metrics.minMemoryUsage == 0 {
            metrics.minMemoryUsage = memoryUsage
        }
        
        updateAverageMemoryUsage()
    }
    
    /// Record CPU usage
    /// - Parameter cpuUsage: CPU usage percentage
    public func recordCPUUsage(_ cpuUsage: Double) {
        guard isEnabled else { return }
        
        metrics.cpuUsageSamples.append(cpuUsage)
        
        if cpuUsage > metrics.maxCPUUsage {
            metrics.maxCPUUsage = cpuUsage
        }
        
        if cpuUsage < metrics.minCPUUsage || metrics.minCPUUsage == 0 {
            metrics.minCPUUsage = cpuUsage
        }
        
        updateAverageCPUUsage()
    }
    
    /// Record cache hit rate
    /// - Parameter hitRate: Cache hit rate percentage
    public func recordCacheHitRate(_ hitRate: Double) {
        guard isEnabled else { return }
        
        metrics.cacheHitRateSamples.append(hitRate)
        updateAverageCacheHitRate()
    }
    
    /// Record network request time
    /// - Parameter requestTime: Network request time in seconds
    public func recordNetworkRequestTime(_ requestTime: TimeInterval) {
        guard isEnabled else { return }
        
        metrics.networkRequestTimes.append(requestTime)
        
        if requestTime > metrics.maxNetworkRequestTime {
            metrics.maxNetworkRequestTime = requestTime
        }
        
        if requestTime < metrics.minNetworkRequestTime || metrics.minNetworkRequestTime == 0 {
            metrics.minNetworkRequestTime = requestTime
        }
        
        updateAverageNetworkRequestTime()
    }
    
    /// Get performance summary
    /// - Returns: Performance summary string
    public func getPerformanceSummary() -> String {
        let metrics = getMetrics()
        
        return """
        Performance Summary:
        - Total Tests: \(metrics.totalTestsExecuted)
        - Average Execution Time: \(String(format: "%.2f", metrics.averageExecutionTime))ms
        - Min Execution Time: \(String(format: "%.2f", metrics.minExecutionTime))ms
        - Max Execution Time: \(String(format: "%.2f", metrics.maxExecutionTime))ms
        - Average Memory Usage: \(String(format: "%.2f", metrics.averageMemoryUsage))MB
        - Average CPU Usage: \(String(format: "%.2f", metrics.averageCPUUsage))%
        - Average Cache Hit Rate: \(String(format: "%.2f", metrics.averageCacheHitRate))%
        - Average Network Request Time: \(String(format: "%.2f", metrics.averageNetworkRequestTime))ms
        """
    }
    
    // MARK: - Private Methods
    
    private func setupMetrics() {
        // Initialize metrics system
        logger.info("Performance metrics system initialized")
    }
    
    private func resetMetrics() {
        metrics = PerformanceMetrics()
        logger.info("Performance metrics reset")
    }
    
    private func updateMetrics() {
        guard let startTime = startTime else { return }
        
        let currentTime = Date()
        metrics.totalMonitoringTime = currentTime.timeIntervalSince(startTime)
        
        logger.info("Performance metrics updated - Total monitoring time: \(metrics.totalMonitoringTime)s")
    }
    
    private func updateAverageExecutionTime() {
        guard !metrics.testExecutionTimes.isEmpty else { return }
        
        let sum = metrics.testExecutionTimes.reduce(0, +)
        metrics.averageExecutionTime = sum / Double(metrics.testExecutionTimes.count)
    }
    
    private func updateAverageMemoryUsage() {
        guard !metrics.memoryUsageSamples.isEmpty else { return }
        
        let sum = metrics.memoryUsageSamples.reduce(0, +)
        metrics.averageMemoryUsage = sum / Double(metrics.memoryUsageSamples.count)
    }
    
    private func updateAverageCPUUsage() {
        guard !metrics.cpuUsageSamples.isEmpty else { return }
        
        let sum = metrics.cpuUsageSamples.reduce(0, +)
        metrics.averageCPUUsage = sum / Double(metrics.cpuUsageSamples.count)
    }
    
    private func updateAverageCacheHitRate() {
        guard !metrics.cacheHitRateSamples.isEmpty else { return }
        
        let sum = metrics.cacheHitRateSamples.reduce(0, +)
        metrics.averageCacheHitRate = sum / Double(metrics.cacheHitRateSamples.count)
    }
    
    private func updateAverageNetworkRequestTime() {
        guard !metrics.networkRequestTimes.isEmpty else { return }
        
        let sum = metrics.networkRequestTimes.reduce(0, +)
        metrics.averageNetworkRequestTime = sum / Double(metrics.networkRequestTimes.count)
    }
}

/// Performance metrics data structure
public struct PerformanceMetrics {
    /// Total number of tests executed
    public var totalTestsExecuted: Int = 0
    
    /// Total monitoring time in seconds
    public var totalMonitoringTime: TimeInterval = 0
    
    /// Test execution times in seconds
    public var testExecutionTimes: [TimeInterval] = []
    
    /// Memory usage samples in MB
    public var memoryUsageSamples: [Double] = []
    
    /// CPU usage samples in percentage
    public var cpuUsageSamples: [Double] = []
    
    /// Cache hit rate samples in percentage
    public var cacheHitRateSamples: [Double] = []
    
    /// Network request times in seconds
    public var networkRequestTimes: [TimeInterval] = []
    
    /// Average execution time in seconds
    public var averageExecutionTime: TimeInterval = 0
    
    /// Minimum execution time in seconds
    public var minExecutionTime: TimeInterval = 0
    
    /// Maximum execution time in seconds
    public var maxExecutionTime: TimeInterval = 0
    
    /// Average memory usage in MB
    public var averageMemoryUsage: Double = 0
    
    /// Minimum memory usage in MB
    public var minMemoryUsage: Double = 0
    
    /// Maximum memory usage in MB
    public var maxMemoryUsage: Double = 0
    
    /// Average CPU usage in percentage
    public var averageCPUUsage: Double = 0
    
    /// Minimum CPU usage in percentage
    public var minCPUUsage: Double = 0
    
    /// Maximum CPU usage in percentage
    public var maxCPUUsage: Double = 0
    
    /// Average cache hit rate in percentage
    public var averageCacheHitRate: Double = 0
    
    /// Average network request time in seconds
    public var averageNetworkRequestTime: TimeInterval = 0
    
    /// Minimum network request time in seconds
    public var minNetworkRequestTime: TimeInterval = 0
    
    /// Maximum network request time in seconds
    public var maxNetworkRequestTime: TimeInterval = 0
    
    public init() {}
} 