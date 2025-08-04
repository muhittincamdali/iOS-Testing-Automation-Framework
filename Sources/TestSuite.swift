import Foundation

/// Test suite for organizing multiple test cases
public struct TestSuite {
    public let name: String
    public let description: String
    public let testCases: [TestCase]
    
    public init(
        name: String,
        description: String,
        testCases: [TestCase] = []
    ) {
        self.name = name
        self.description = description
        self.testCases = testCases
    }
    
    public func addTestCase(_ testCase: TestCase) -> TestSuite {
        return TestSuite(
            name: name,
            description: description,
            testCases: testCases + [testCase]
        )
    }
    
    public var testCaseCount: Int {
        return testCases.count
    }
}

/// Test suite results
public struct TestSuiteResults {
    public let results: [TestResult]
    
    public var passedCount: Int {
        results.filter { $0.status == .passed }.count
    }
    
    public var failedCount: Int {
        results.filter { $0.status == .failed }.count
    }
    
    public var totalCount: Int {
        results.count
    }
    
    public var successRate: Double {
        guard totalCount > 0 else { return 0.0 }
        return Double(passedCount) / Double(totalCount) * 100.0
    }
    
    public init(results: [TestResult]) {
        self.results = results
    }
} 