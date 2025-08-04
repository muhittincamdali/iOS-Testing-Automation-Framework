import Foundation
import UIKit
import os.log

/// Monitors and tracks performance metrics during test execution
@available(iOS 15.0, macOS 12.0, *)
public class PerformanceMonitor {
    
    // MARK: - Properties
    
    private let logger = Logger(label: "PerformanceMonitor")
    private var isMonitoring = false
    private var startTime: Date?
    private var metrics: PerformanceMetrics
    private let displayLink: CADisplayLink?
    
    // MARK: - Initialization
    
    public init() {
        self.metrics = PerformanceMetrics()
        self.displayLink = CADisplayLink(target: self, selector: #selector(updateMetrics))
        self.displayLink?.add(to: .main, forMode: .common)
        self.displayLink?.isPaused = true
        
        logger.info("PerformanceMonitor initialized")
    }
    
    deinit {
        displayLink?.invalidate()
    }
    
    // MARK: - Public Methods
    
    /// Start performance monitoring
    public func startMonitoring() {
        guard !isMonitoring else { return }
        
        isMonitoring = true
        startTime = Date()
        metrics = PerformanceMetrics()
        displayLink?.isPaused = false
        
        logger.info("Performance monitoring started")
    }
    
    /// Stop performance monitoring
    public func stopMonitoring() {
        guard isMonitoring else { return }
        
        isMonitoring = false
        displayLink?.isPaused = true
        
        if let startTime = startTime {
            metrics.totalExecutionTime = Date().timeIntervalSince(startTime)
        }
        
        logger.info("Performance monitoring stopped")
    }
    
    /// Get current performance metrics
    public func getMetrics() -> PerformanceMetrics {
        return metrics
    }
    
    /// Reset performance metrics
    public func resetMetrics() {
        metrics = PerformanceMetrics()
        logger.info("Performance metrics reset")
    }
    
    /// Record a custom metric
    public func recordMetric(name: String, value: Double) {
        metrics.customMetrics[name] = value
        logger.debug("Recorded metric: \(name) = \(value)")
    }
    
    /// Record memory usage
    public func recordMemoryUsage(_ usage: UInt64) {
        metrics.memoryUsage = usage
        metrics.peakMemoryUsage = max(metrics.peakMemoryUsage, usage)
        logger.debug("Memory usage recorded: \(usage) bytes")
    }
    
    /// Record CPU usage
    public func recordCPUUsage(_ usage: Double) {
        metrics.cpuUsage = usage
        metrics.peakCPUUsage = max(metrics.peakCPUUsage, usage)
        logger.debug("CPU usage recorded: \(usage)%")
    }
    
    /// Record frame rate
    public func recordFrameRate(_ fps: Double) {
        metrics.frameRate = fps
        metrics.averageFrameRate = calculateAverageFrameRate(fps)
        logger.debug("Frame rate recorded: \(fps) FPS")
    }
    
    // MARK: - Private Methods
    
    @objc private func updateMetrics() {
        guard isMonitoring else { return }
        
        // Update current metrics
        updateSystemMetrics()
        
        // Check for performance warnings
        checkPerformanceWarnings()
    }
    
    private func updateSystemMetrics() {
        // Get current memory usage
        let memoryUsage = getCurrentMemoryUsage()
        recordMemoryUsage(memoryUsage)
        
        // Get current CPU usage
        let cpuUsage = getCurrentCPUUsage()
        recordCPUUsage(cpuUsage)
        
        // Get current frame rate
        let frameRate = getCurrentFrameRate()
        recordFrameRate(frameRate)
    }
    
    private func getCurrentMemoryUsage() -> UInt64 {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }
        
        return kerr == KERN_SUCCESS ? UInt64(info.resident_size) : 0
    }
    
    private func getCurrentCPUUsage() -> Double {
        // Simplified CPU usage calculation
        // In a real implementation, you would use more sophisticated methods
        return Double.random(in: 0...100) // Placeholder
    }
    
    private func getCurrentFrameRate() -> Double {
        // Get current frame rate from CADisplayLink
        guard let displayLink = displayLink else { return 0.0 }
        return 1.0 / displayLink.duration
    }
    
    private func calculateAverageFrameRate(_ currentFPS: Double) -> Double {
        let alpha = 0.1 // Smoothing factor
        return metrics.averageFrameRate * (1.0 - alpha) + currentFPS * alpha
    }
    
    private func checkPerformanceWarnings() {
        // Check for memory warnings
        if metrics.memoryUsage > 500 * 1024 * 1024 { // 500MB
            logger.warning("High memory usage detected: \(metrics.memoryUsage) bytes")
        }
        
        // Check for CPU warnings
        if metrics.cpuUsage > 80.0 {
            logger.warning("High CPU usage detected: \(metrics.cpuUsage)%")
        }
        
        // Check for frame rate warnings
        if metrics.frameRate < 30.0 {
            logger.warning("Low frame rate detected: \(metrics.frameRate) FPS")
        }
    }
}

// MARK: - Performance Metrics

public struct PerformanceMetrics {
    public var memoryUsage: UInt64
    public var peakMemoryUsage: UInt64
    public var cpuUsage: Double
    public var peakCPUUsage: Double
    public var frameRate: Double
    public var averageFrameRate: Double
    public var totalExecutionTime: TimeInterval
    public var customMetrics: [String: Double]
    
    public init(memoryUsage: UInt64 = 0,
                peakMemoryUsage: UInt64 = 0,
                cpuUsage: Double = 0.0,
                peakCPUUsage: Double = 0.0,
                frameRate: Double = 0.0,
                averageFrameRate: Double = 0.0,
                totalExecutionTime: TimeInterval = 0.0,
                customMetrics: [String: Double] = [:]) {
        
        self.memoryUsage = memoryUsage
        self.peakMemoryUsage = peakMemoryUsage
        self.cpuUsage = cpuUsage
        self.peakCPUUsage = peakCPUUsage
        self.frameRate = frameRate
        self.averageFrameRate = averageFrameRate
        self.totalExecutionTime = totalExecutionTime
        self.customMetrics = customMetrics
    }
    
    /// Get memory usage in MB
    public var memoryUsageMB: Double {
        return Double(memoryUsage) / (1024 * 1024)
    }
    
    /// Get peak memory usage in MB
    public var peakMemoryUsageMB: Double {
        return Double(peakMemoryUsage) / (1024 * 1024)
    }
    
    /// Check if performance is within acceptable limits
    public var isPerformanceAcceptable: Bool {
        return memoryUsageMB < 500 && // Less than 500MB
               cpuUsage < 80.0 && // Less than 80% CPU
               frameRate >= 30.0 // At least 30 FPS
    }
    
    /// Get performance score (0-100)
    public var performanceScore: Double {
        var score = 100.0
        
        // Memory penalty
        if memoryUsageMB > 500 {
            score -= min(30, (memoryUsageMB - 500) / 10)
        }
        
        // CPU penalty
        if cpuUsage > 80 {
            score -= min(30, (cpuUsage - 80) * 0.5)
        }
        
        // Frame rate penalty
        if frameRate < 30 {
            score -= min(40, (30 - frameRate) * 2)
        }
        
        return max(0, score)
    }
}

// MARK: - Performance Warnings

public enum PerformanceWarning {
    case highMemoryUsage(UInt64)
    case highCPUUsage(Double)
    case lowFrameRate(Double)
    case longExecutionTime(TimeInterval)
    
    public var description: String {
        switch self {
        case .highMemoryUsage(let usage):
            return "High memory usage: \(usage / (1024 * 1024)) MB"
        case .highCPUUsage(let usage):
            return "High CPU usage: \(usage)%"
        case .lowFrameRate(let fps):
            return "Low frame rate: \(fps) FPS"
        case .longExecutionTime(let time):
            return "Long execution time: \(time) seconds"
        }
    }
} 