import Foundation
import Logging

/// Basic test framework for iOS applications
@available(iOS 15.0, macOS 12.0, *)
public class TestFramework {
    
    private let logger = Logger(label: "TestFramework")
    
    public init() {
        logger.info("Test framework initialized")
    }
    
    public func runTest(_ testName: String, testBlock: () async throws -> Void) async throws {
        logger.info("Running test: \(testName)")
        
        do {
            try await testBlock()
            logger.info("Test passed: \(testName)")
        } catch {
            logger.error("Test failed: \(testName) - \(error)")
            throw error
        }
    }
} 