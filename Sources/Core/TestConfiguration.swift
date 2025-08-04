import Foundation
import XCTest

/// Comprehensive test configuration for iOS Testing Automation Framework
public class TestConfiguration {
    
    // MARK: - Properties
    
    /// Enable parallel test execution
    public var enableParallelExecution: Bool = false
    
    /// Maximum number of concurrent tests
    public var maxConcurrentTests: Int = 4
    
    /// Test timeout interval in seconds
    public var timeoutInterval: TimeInterval = 30.0
    
    /// Enable performance monitoring
    public var enablePerformanceMonitoring: Bool = true
    
    /// Enable memory leak detection
    public var enableMemoryLeakDetection: Bool = true
    
    /// Enable network monitoring
    public var enableNetworkMonitoring: Bool = true
    
    /// Enable accessibility testing
    public var enableAccessibilityTesting: Bool = true
    
    /// Enable visual regression testing
    public var enableVisualRegressionTesting: Bool = true
    
    /// Enable security testing
    public var enableSecurityTesting: Bool = true
    
    /// Test environment configuration
    public var environment: TestEnvironment = .development
    
    /// Device configuration for testing
    public var deviceConfiguration: DeviceConfiguration = DeviceConfiguration()
    
    /// Reporting configuration
    public var reportingConfiguration: ReportingConfiguration = ReportingConfiguration()
    
    /// Performance thresholds
    public var performanceThresholds: PerformanceThresholds = PerformanceThresholds()
    
    // MARK: - Initialization
    
    public init() {}
    
    public init(enableParallelExecution: Bool = false,
                maxConcurrentTests: Int = 4,
                timeoutInterval: TimeInterval = 30.0,
                enablePerformanceMonitoring: Bool = true,
                enableMemoryLeakDetection: Bool = true,
                enableNetworkMonitoring: Bool = true,
                enableAccessibilityTesting: Bool = true,
                enableVisualRegressionTesting: Bool = true,
                enableSecurityTesting: Bool = true,
                environment: TestEnvironment = .development,
                deviceConfiguration: DeviceConfiguration = DeviceConfiguration(),
                reportingConfiguration: ReportingConfiguration = ReportingConfiguration(),
                performanceThresholds: PerformanceThresholds = PerformanceThresholds()) {
        
        self.enableParallelExecution = enableParallelExecution
        self.maxConcurrentTests = maxConcurrentTests
        self.timeoutInterval = timeoutInterval
        self.enablePerformanceMonitoring = enablePerformanceMonitoring
        self.enableMemoryLeakDetection = enableMemoryLeakDetection
        self.enableNetworkMonitoring = enableNetworkMonitoring
        self.enableAccessibilityTesting = enableAccessibilityTesting
        self.enableVisualRegressionTesting = enableVisualRegressionTesting
        self.enableSecurityTesting = enableSecurityTesting
        self.environment = environment
        self.deviceConfiguration = deviceConfiguration
        self.reportingConfiguration = reportingConfiguration
        self.performanceThresholds = performanceThresholds
    }
    
    // MARK: - Validation
    
    /// Validate configuration settings
    public func validate() throws {
        guard maxConcurrentTests > 0 else {
            throw TestConfigurationError.invalidConcurrentTests
        }
        
        guard timeoutInterval > 0 else {
            throw TestConfigurationError.invalidTimeoutInterval
        }
        
        guard deviceConfiguration.isValid else {
            throw TestConfigurationError.invalidDeviceConfiguration
        }
        
        guard performanceThresholds.isValid else {
            throw TestConfigurationError.invalidPerformanceThresholds
        }
    }
    
    // MARK: - Configuration Methods
    
    /// Configure for unit testing
    public func configureForUnitTesting() {
        enableParallelExecution = true
        maxConcurrentTests = 8
        timeoutInterval = 10.0
        enablePerformanceMonitoring = false
        enableMemoryLeakDetection = true
        enableNetworkMonitoring = false
        enableAccessibilityTesting = false
        enableVisualRegressionTesting = false
        enableSecurityTesting = false
        environment = .unitTesting
    }
    
    /// Configure for UI testing
    public func configureForUITesting() {
        enableParallelExecution = true
        maxConcurrentTests = 4
        timeoutInterval = 60.0
        enablePerformanceMonitoring = true
        enableMemoryLeakDetection = true
        enableNetworkMonitoring = true
        enableAccessibilityTesting = true
        enableVisualRegressionTesting = true
        enableSecurityTesting = false
        environment = .uiTesting
    }
    
    /// Configure for performance testing
    public func configureForPerformanceTesting() {
        enableParallelExecution = false
        maxConcurrentTests = 1
        timeoutInterval = 300.0
        enablePerformanceMonitoring = true
        enableMemoryLeakDetection = true
        enableNetworkMonitoring = true
        enableAccessibilityTesting = false
        enableVisualRegressionTesting = false
        enableSecurityTesting = false
        environment = .performanceTesting
    }
    
    /// Configure for integration testing
    public func configureForIntegrationTesting() {
        enableParallelExecution = true
        maxConcurrentTests = 2
        timeoutInterval = 120.0
        enablePerformanceMonitoring = true
        enableMemoryLeakDetection = true
        enableNetworkMonitoring = true
        enableAccessibilityTesting = true
        enableVisualRegressionTesting = true
        enableSecurityTesting = true
        environment = .integrationTesting
    }
}

// MARK: - Supporting Types

public enum TestEnvironment: String, CaseIterable {
    case development = "development"
    case staging = "staging"
    case production = "production"
    case unitTesting = "unitTesting"
    case uiTesting = "uiTesting"
    case performanceTesting = "performanceTesting"
    case integrationTesting = "integrationTesting"
}

public struct DeviceConfiguration {
    public var deviceType: DeviceType = .iPhone
    public var iOSVersion: String = "15.0"
    public var screenSize: CGSize = CGSize(width: 390, height: 844)
    public var orientation: UIDeviceOrientation = .portrait
    public var language: String = "en"
    public var region: String = "US"
    
    public var isValid: Bool {
        return !iOSVersion.isEmpty && screenSize.width > 0 && screenSize.height > 0
    }
}

public enum DeviceType: String, CaseIterable {
    case iPhone = "iPhone"
    case iPad = "iPad"
    case mac = "mac"
    case tv = "tv"
    case watch = "watch"
}

public struct ReportingConfiguration {
    public var enableHTMLReports: Bool = true
    public var enableJSONReports: Bool = true
    public var enableJUnitReports: Bool = true
    public var enableCoverageReports: Bool = true
    public var reportDirectory: String = "TestReports"
    public var includeScreenshots: Bool = true
    public var includeVideos: Bool = false
    public var includePerformanceData: Bool = true
}

public struct PerformanceThresholds {
    public var maxMemoryUsage: Int64 = 200 * 1024 * 1024 // 200MB
    public var maxCPUUsage: Double = 80.0 // 80%
    public var maxBatteryDrain: Double = 5.0 // 5% per hour
    public var maxNetworkLatency: TimeInterval = 2.0 // 2 seconds
    public var maxAppLaunchTime: TimeInterval = 3.0 // 3 seconds
    public var maxUITestExecutionTime: TimeInterval = 30.0 // 30 seconds
    
    public var isValid: Bool {
        return maxMemoryUsage > 0 && maxCPUUsage > 0 && maxCPUUsage <= 100 &&
               maxBatteryDrain > 0 && maxNetworkLatency > 0 &&
               maxAppLaunchTime > 0 && maxUITestExecutionTime > 0
    }
}

public enum TestConfigurationError: Error, LocalizedError {
    case invalidConcurrentTests
    case invalidTimeoutInterval
    case invalidDeviceConfiguration
    case invalidPerformanceThresholds
    
    public var errorDescription: String? {
        switch self {
        case .invalidConcurrentTests:
            return "Maximum concurrent tests must be greater than 0"
        case .invalidTimeoutInterval:
            return "Timeout interval must be greater than 0"
        case .invalidDeviceConfiguration:
            return "Device configuration is invalid"
        case .invalidPerformanceThresholds:
            return "Performance thresholds are invalid"
        }
    }
} 