import XCTest
@testable import iOSTestingAutomationFramework

@available(iOS 15.0, macOS 12.0, *)
final class TestFrameworkTests: XCTestCase {
    
    var testFramework: TestFramework!
    
    override func setUp() {
        super.setUp()
        testFramework = TestFramework()
    }
    
    override func tearDown() {
        testFramework = nil
        super.tearDown()
    }
    
    func testFrameworkInitialization() {
        XCTAssertNotNil(testFramework)
    }
    
    func testSuccessfulTestExecution() async throws {
        var testExecuted = false
        
        try await testFramework.runTest("Successful Test") {
            testExecuted = true
        }
        
        XCTAssertTrue(testExecuted)
    }
    
    func testFailedTestExecution() async throws {
        do {
            try await testFramework.runTest("Failed Test") {
                throw TestError.testFailure
            }
            XCTFail("Test should have failed")
        } catch {
            XCTAssertEqual(error as? TestError, .testFailure)
        }
    }
}

enum TestError: Error {
    case testFailure
}
