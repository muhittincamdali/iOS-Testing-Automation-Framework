import Foundation
import XCTest
import UIKit

/// Handles test execution with timeout and error handling
@available(iOS 15.0, macOS 12.0, *)
public class TestExecutor {
    
    // MARK: - Properties
    
    private let configuration: TestConfiguration
    private let logger = Logger(label: "TestExecutor")
    private let timeoutQueue = DispatchQueue(label: "test.timeout")
    
    // MARK: - Initialization
    
    public init(configuration: TestConfiguration) {
        self.configuration = configuration
        logger.info("TestExecutor initialized")
    }
    
    // MARK: - Public Methods
    
    /// Execute a test case with timeout handling
    public func execute(_ testCase: TestCase) async throws {
        logger.info("Executing test case: \(testCase.name)")
        
        return try await withThrowingTaskGroup(of: Void.self) { group in
            // Add the main test execution task
            group.addTask {
                try await self.executeTest(testCase)
            }
            
            // Add timeout task
            group.addTask {
                try await self.waitForTimeout()
            }
            
            // Wait for the first task to complete
            let result = try await group.next()
            
            // Cancel remaining tasks
            group.cancelAll()
            
            return result!
        }
    }
    
    /// Execute multiple test cases
    public func executeTests(_ testCases: [TestCase]) async throws -> [TestResult] {
        logger.info("Executing \(testCases.count) test cases")
        
        var results: [TestResult] = []
        
        for testCase in testCases {
            let startTime = Date()
            
            do {
                try await execute(testCase)
                let executionTime = Date().timeIntervalSince(startTime)
                
                let result = TestResult(
                    testCase: testCase,
                    status: .passed,
                    executionTime: executionTime,
                    error: nil
                )
                results.append(result)
                
            } catch {
                let executionTime = Date().timeIntervalSince(startTime)
                
                let result = TestResult(
                    testCase: testCase,
                    status: .failed,
                    executionTime: executionTime,
                    error: error
                )
                results.append(result)
            }
        }
        
        return results
    }
    
    // MARK: - Private Methods
    
    private func executeTest(_ testCase: TestCase) async throws {
        logger.debug("Starting execution of: \(testCase.name)")
        
        // Pre-execution validation
        try validateTestCase(testCase)
        
        // Execute the test
        try await testCase.executionBlock()
        
        // Post-execution cleanup
        try await cleanupAfterTest(testCase)
        
        logger.debug("Completed execution of: \(testCase.name)")
    }
    
    private func validateTestCase(_ testCase: TestCase) throws {
        guard !testCase.name.isEmpty else {
            throw TestExecutionError.invalidTestCase("Test case name cannot be empty")
        }
        
        guard !testCase.description.isEmpty else {
            throw TestExecutionError.invalidTestCase("Test case description cannot be empty")
        }
        
        logger.debug("Test case validation passed for: \(testCase.name)")
    }
    
    private func cleanupAfterTest(_ testCase: TestCase) async throws {
        // Reset any global state
        // Clear caches if needed
        // Reset UI state
        logger.debug("Cleanup completed for: \(testCase.name)")
    }
    
    private func waitForTimeout() async throws {
        try await Task.sleep(nanoseconds: UInt64(configuration.timeoutInterval * 1_000_000_000))
        throw TestExecutionError.timeout("Test execution timed out after \(configuration.timeoutInterval) seconds")
    }
}

// MARK: - Test Execution Errors

public enum TestExecutionError: Error, LocalizedError {
    case timeout(String)
    case invalidTestCase(String)
    case executionFailed(String)
    case configurationError(String)
    
    public var errorDescription: String? {
        switch self {
        case .timeout(let message):
            return "Timeout Error: \(message)"
        case .invalidTestCase(let message):
            return "Invalid Test Case: \(message)"
        case .executionFailed(let message):
            return "Execution Failed: \(message)"
        case .configurationError(let message):
            return "Configuration Error: \(message)"
        }
    }
}

// MARK: - Test Execution Context

public struct TestExecutionContext {
    public let testCase: TestCase
    public let startTime: Date
    public let configuration: TestConfiguration
    public let environment: TestEnvironment
    
    public init(testCase: TestCase, configuration: TestConfiguration, environment: TestEnvironment) {
        self.testCase = testCase
        self.startTime = Date()
        self.configuration = configuration
        self.environment = environment
    }
    
    public var elapsedTime: TimeInterval {
        return Date().timeIntervalSince(startTime)
    }
}

// MARK: - Test Environment

public struct TestEnvironment {
    public let deviceType: String
    public let osVersion: String
    public let appVersion: String
    public let isSimulator: Bool
    public let availableMemory: UInt64
    public let cpuUsage: Double
    
    public init(deviceType: String = "iPhone",
                osVersion: String = "15.0",
                appVersion: String = "1.0.0",
                isSimulator: Bool = true,
                availableMemory: UInt64 = 0,
                cpuUsage: Double = 0.0) {
        
        self.deviceType = deviceType
        self.osVersion = osVersion
        self.appVersion = appVersion
        self.isSimulator = isSimulator
        self.availableMemory = availableMemory
        self.cpuUsage = cpuUsage
    }
} 