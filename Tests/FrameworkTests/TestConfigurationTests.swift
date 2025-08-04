import XCTest
@testable import iOSTestingAutomationFramework

final class TestConfigurationTests: XCTestCase {
    
    var configuration: TestConfiguration!
    
    override func setUp() {
        super.setUp()
        configuration = TestConfiguration()
    }
    
    override func tearDown() {
        configuration = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testDefaultConfiguration() {
        XCTAssertFalse(configuration.enableParallelExecution)
        XCTAssertEqual(configuration.maxConcurrentTests, 4)
        XCTAssertEqual(configuration.timeoutInterval, 30.0)
        XCTAssertTrue(configuration.enablePerformanceMonitoring)
        XCTAssertTrue(configuration.enableMemoryLeakDetection)
        XCTAssertTrue(configuration.enableNetworkMonitoring)
        XCTAssertTrue(configuration.enableAccessibilityTesting)
        XCTAssertTrue(configuration.enableVisualRegressionTesting)
        XCTAssertTrue(configuration.enableSecurityTesting)
        XCTAssertEqual(configuration.environment, .development)
    }
    
    func testCustomConfiguration() {
        let customConfig = TestConfiguration(
            enableParallelExecution: true,
            maxConcurrentTests: 8,
            timeoutInterval: 60.0,
            enablePerformanceMonitoring: false,
            enableMemoryLeakDetection: false,
            enableNetworkMonitoring: false,
            enableAccessibilityTesting: false,
            enableVisualRegressionTesting: false,
            enableSecurityTesting: false,
            environment: .production
        )
        
        XCTAssertTrue(customConfig.enableParallelExecution)
        XCTAssertEqual(customConfig.maxConcurrentTests, 8)
        XCTAssertEqual(customConfig.timeoutInterval, 60.0)
        XCTAssertFalse(customConfig.enablePerformanceMonitoring)
        XCTAssertFalse(customConfig.enableMemoryLeakDetection)
        XCTAssertFalse(customConfig.enableNetworkMonitoring)
        XCTAssertFalse(customConfig.enableAccessibilityTesting)
        XCTAssertFalse(customConfig.enableVisualRegressionTesting)
        XCTAssertFalse(customConfig.enableSecurityTesting)
        XCTAssertEqual(customConfig.environment, .production)
    }
    
    // MARK: - Validation Tests
    
    func testValidConfiguration() {
        XCTAssertNoThrow(try configuration.validate())
    }
    
    func testInvalidConcurrentTests() {
        configuration.maxConcurrentTests = 0
        XCTAssertThrowsError(try configuration.validate()) { error in
            XCTAssertEqual(error as? TestConfigurationError, .invalidConcurrentTests)
        }
    }
    
    func testInvalidTimeoutInterval() {
        configuration.timeoutInterval = 0
        XCTAssertThrowsError(try configuration.validate()) { error in
            XCTAssertEqual(error as? TestConfigurationError, .invalidTimeoutInterval)
        }
    }
    
    func testInvalidDeviceConfiguration() {
        configuration.deviceConfiguration.iOSVersion = ""
        XCTAssertThrowsError(try configuration.validate()) { error in
            XCTAssertEqual(error as? TestConfigurationError, .invalidDeviceConfiguration)
        }
    }
    
    func testInvalidPerformanceThresholds() {
        configuration.performanceThresholds.maxMemoryUsage = 0
        XCTAssertThrowsError(try configuration.validate()) { error in
            XCTAssertEqual(error as? TestConfigurationError, .invalidPerformanceThresholds)
        }
    }
    
    // MARK: - Configuration Methods Tests
    
    func testConfigureForUnitTesting() {
        configuration.configureForUnitTesting()
        
        XCTAssertTrue(configuration.enableParallelExecution)
        XCTAssertEqual(configuration.maxConcurrentTests, 8)
        XCTAssertEqual(configuration.timeoutInterval, 10.0)
        XCTAssertFalse(configuration.enablePerformanceMonitoring)
        XCTAssertTrue(configuration.enableMemoryLeakDetection)
        XCTAssertFalse(configuration.enableNetworkMonitoring)
        XCTAssertFalse(configuration.enableAccessibilityTesting)
        XCTAssertFalse(configuration.enableVisualRegressionTesting)
        XCTAssertFalse(configuration.enableSecurityTesting)
        XCTAssertEqual(configuration.environment, .unitTesting)
    }
    
    func testConfigureForUITesting() {
        configuration.configureForUITesting()
        
        XCTAssertTrue(configuration.enableParallelExecution)
        XCTAssertEqual(configuration.maxConcurrentTests, 4)
        XCTAssertEqual(configuration.timeoutInterval, 60.0)
        XCTAssertTrue(configuration.enablePerformanceMonitoring)
        XCTAssertTrue(configuration.enableMemoryLeakDetection)
        XCTAssertTrue(configuration.enableNetworkMonitoring)
        XCTAssertTrue(configuration.enableAccessibilityTesting)
        XCTAssertTrue(configuration.enableVisualRegressionTesting)
        XCTAssertFalse(configuration.enableSecurityTesting)
        XCTAssertEqual(configuration.environment, .uiTesting)
    }
    
    func testConfigureForPerformanceTesting() {
        configuration.configureForPerformanceTesting()
        
        XCTAssertFalse(configuration.enableParallelExecution)
        XCTAssertEqual(configuration.maxConcurrentTests, 1)
        XCTAssertEqual(configuration.timeoutInterval, 300.0)
        XCTAssertTrue(configuration.enablePerformanceMonitoring)
        XCTAssertTrue(configuration.enableMemoryLeakDetection)
        XCTAssertTrue(configuration.enableNetworkMonitoring)
        XCTAssertFalse(configuration.enableAccessibilityTesting)
        XCTAssertFalse(configuration.enableVisualRegressionTesting)
        XCTAssertFalse(configuration.enableSecurityTesting)
        XCTAssertEqual(configuration.environment, .performanceTesting)
    }
    
    func testConfigureForIntegrationTesting() {
        configuration.configureForIntegrationTesting()
        
        XCTAssertTrue(configuration.enableParallelExecution)
        XCTAssertEqual(configuration.maxConcurrentTests, 2)
        XCTAssertEqual(configuration.timeoutInterval, 120.0)
        XCTAssertTrue(configuration.enablePerformanceMonitoring)
        XCTAssertTrue(configuration.enableMemoryLeakDetection)
        XCTAssertTrue(configuration.enableNetworkMonitoring)
        XCTAssertTrue(configuration.enableAccessibilityTesting)
        XCTAssertTrue(configuration.enableVisualRegressionTesting)
        XCTAssertTrue(configuration.enableSecurityTesting)
        XCTAssertEqual(configuration.environment, .integrationTesting)
    }
    
    // MARK: - Device Configuration Tests
    
    func testDeviceConfigurationValidation() {
        XCTAssertTrue(configuration.deviceConfiguration.isValid)
        
        configuration.deviceConfiguration.iOSVersion = ""
        XCTAssertFalse(configuration.deviceConfiguration.isValid)
        
        configuration.deviceConfiguration.iOSVersion = "15.0"
        configuration.deviceConfiguration.screenSize = CGSize.zero
        XCTAssertFalse(configuration.deviceConfiguration.isValid)
    }
    
    func testDeviceConfigurationDefaults() {
        let deviceConfig = DeviceConfiguration()
        
        XCTAssertEqual(deviceConfig.deviceType, .iPhone)
        XCTAssertEqual(deviceConfig.iOSVersion, "15.0")
        XCTAssertEqual(deviceConfig.screenSize, CGSize(width: 390, height: 844))
        XCTAssertEqual(deviceConfig.orientation, .portrait)
        XCTAssertEqual(deviceConfig.language, "en")
        XCTAssertEqual(deviceConfig.region, "US")
    }
    
    // MARK: - Performance Thresholds Tests
    
    func testPerformanceThresholdsValidation() {
        XCTAssertTrue(configuration.performanceThresholds.isValid)
        
        configuration.performanceThresholds.maxMemoryUsage = 0
        XCTAssertFalse(configuration.performanceThresholds.isValid)
        
        configuration.performanceThresholds.maxMemoryUsage = 200 * 1024 * 1024
        configuration.performanceThresholds.maxCPUUsage = 0
        XCTAssertFalse(configuration.performanceThresholds.isValid)
        
        configuration.performanceThresholds.maxCPUUsage = 80.0
        configuration.performanceThresholds.maxCPUUsage = 101.0
        XCTAssertFalse(configuration.performanceThresholds.isValid)
    }
    
    func testPerformanceThresholdsDefaults() {
        let thresholds = PerformanceThresholds()
        
        XCTAssertEqual(thresholds.maxMemoryUsage, 200 * 1024 * 1024) // 200MB
        XCTAssertEqual(thresholds.maxCPUUsage, 80.0) // 80%
        XCTAssertEqual(thresholds.maxBatteryDrain, 5.0) // 5% per hour
        XCTAssertEqual(thresholds.maxNetworkLatency, 2.0) // 2 seconds
        XCTAssertEqual(thresholds.maxAppLaunchTime, 3.0) // 3 seconds
        XCTAssertEqual(thresholds.maxUITestExecutionTime, 30.0) // 30 seconds
    }
    
    // MARK: - Reporting Configuration Tests
    
    func testReportingConfigurationDefaults() {
        let reportingConfig = ReportingConfiguration()
        
        XCTAssertTrue(reportingConfig.enableHTMLReports)
        XCTAssertTrue(reportingConfig.enableJSONReports)
        XCTAssertTrue(reportingConfig.enableJUnitReports)
        XCTAssertTrue(reportingConfig.enableCoverageReports)
        XCTAssertEqual(reportingConfig.reportDirectory, "TestReports")
        XCTAssertTrue(reportingConfig.includeScreenshots)
        XCTAssertFalse(reportingConfig.includeVideos)
        XCTAssertTrue(reportingConfig.includePerformanceData)
    }
    
    // MARK: - Test Environment Tests
    
    func testTestEnvironmentCases() {
        let environments = TestEnvironment.allCases
        
        XCTAssertTrue(environments.contains(.development))
        XCTAssertTrue(environments.contains(.staging))
        XCTAssertTrue(environments.contains(.production))
        XCTAssertTrue(environments.contains(.unitTesting))
        XCTAssertTrue(environments.contains(.uiTesting))
        XCTAssertTrue(environments.contains(.performanceTesting))
        XCTAssertTrue(environments.contains(.integrationTesting))
    }
    
    func testDeviceTypeCases() {
        let deviceTypes = DeviceType.allCases
        
        XCTAssertTrue(deviceTypes.contains(.iPhone))
        XCTAssertTrue(deviceTypes.contains(.iPad))
        XCTAssertTrue(deviceTypes.contains(.mac))
        XCTAssertTrue(deviceTypes.contains(.tv))
        XCTAssertTrue(deviceTypes.contains(.watch))
    }
    
    // MARK: - Error Handling Tests
    
    func testTestConfigurationErrorDescriptions() {
        let concurrentTestsError = TestConfigurationError.invalidConcurrentTests
        let timeoutError = TestConfigurationError.invalidTimeoutInterval
        let deviceConfigError = TestConfigurationError.invalidDeviceConfiguration
        let performanceError = TestConfigurationError.invalidPerformanceThresholds
        
        XCTAssertEqual(concurrentTestsError.errorDescription, "Maximum concurrent tests must be greater than 0")
        XCTAssertEqual(timeoutError.errorDescription, "Timeout interval must be greater than 0")
        XCTAssertEqual(deviceConfigError.errorDescription, "Device configuration is invalid")
        XCTAssertEqual(performanceError.errorDescription, "Performance thresholds are invalid")
    }
} 