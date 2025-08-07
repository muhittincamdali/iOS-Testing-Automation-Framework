# 🚀 Quick Start Tutorial

<div align="center">

**Get started with iOS Testing Automation Framework in 5 minutes!**

</div>

---

## 📋 Table of Contents

- [Prerequisites](#-prerequisites)
- [Installation](#-installation)
- [Basic Setup](#-basic-setup)
- [Your First Test](#-your-first-test)
- [Running Tests](#-running-tests)
- [Next Steps](#-next-steps)

---

## 🛠️ Prerequisites

Before you begin, ensure you have the following installed:

| **Component** | **Version** | **Description** |
|---------------|-------------|-----------------|
| 🖥️ **macOS** | 12.0+ | Monterey or later |
| 📱 **iOS** | 15.0+ | Minimum deployment target |
| 🛠️ **Xcode** | 15.0+ | Latest stable version |
| ⚡ **Swift** | 5.9+ | Latest Swift version |
| 📦 **CocoaPods** | Latest | For dependency management |

### Verify Your Setup

```bash
# Check Xcode version
xcodebuild -version

# Check Swift version
swift --version

# Check CocoaPods version
pod --version
```

---

## 📦 Installation

### Option 1: Swift Package Manager (Recommended)

1. **Open your Xcode project**
2. **Go to File → Add Package Dependencies**
3. **Enter the repository URL:**
   ```
   https://github.com/muhittincamdali/iOS-Testing-Automation-Framework.git
   ```
4. **Select version:** Choose the latest stable version
5. **Add to target:** Select your main app target

### Option 2: CocoaPods

1. **Add to your Podfile:**
   ```ruby
   pod 'iOSTestingAutomationFramework'
   ```

2. **Install dependencies:**
   ```bash
   pod install
   ```

3. **Open the workspace:**
   ```bash
   open YourApp.xcworkspace
   ```

### Option 3: Manual Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/muhittincamdali/iOS-Testing-Automation-Framework.git
   ```

2. **Add the framework to your project:**
   - Drag `Sources` folder to your Xcode project
   - Ensure "Copy items if needed" is checked
   - Add to your target

---

## ⚡ Basic Setup

### 1. Import the Framework

```swift
import iOSTestingAutomationFramework
```

### 2. Create Test Configuration

```swift
// Create basic configuration
let config = TestConfiguration()

// Enable parallel execution
config.enableParallelExecution = true
config.maxConcurrentTests = 4

// Enable performance monitoring
config.enablePerformanceMonitoring = true

// Set timeout
config.timeoutInterval = 30.0
```

### 3. Initialize the Framework

```swift
// Initialize with configuration
let testFramework = TestAutomationFramework(configuration: config)

// Or use default configuration
let testFramework = TestAutomationFramework()
```

---

## 🧪 Your First Test

### Create a Simple Unit Test

```swift
import XCTest
@testable import iOSTestingAutomationFramework

class MyFirstTests: XCTestCase {
    
    var testFramework: TestAutomationFramework!
    
    override func setUp() {
        super.setUp()
        testFramework = TestAutomationFramework()
    }
    
    override func tearDown() {
        testFramework = nil
        super.tearDown()
    }
    
    func testFrameworkInitialization() async throws {
        // Given
        let config = TestConfiguration()
        config.enableParallelExecution = true
        
        // When
        let framework = TestAutomationFramework(configuration: config)
        
        // Then
        XCTAssertNotNil(framework)
        XCTAssertTrue(framework.configuration.enableParallelExecution)
    }
    
    func testSimpleTestExecution() async throws {
        // Given
        let testCase = TestCase(
            name: "My First Test",
            description: "A simple test case"
        ) {
            // Test implementation
            XCTAssertTrue(true)
        }
        
        // When
        let result = try await testFramework.runTest(testCase)
        
        // Then
        XCTAssertEqual(result.status, .passed)
        XCTAssertGreaterThan(result.duration, 0)
    }
}
```

### Create a UI Test

```swift
import XCTest

class MyUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testLoginFlow() throws {
        // Given
        let emailField = app.textFields["email"]
        let passwordField = app.secureTextFields["password"]
        let loginButton = app.buttons["login"]
        
        // When
        emailField.tap()
        emailField.typeText("test@example.com")
        
        passwordField.tap()
        passwordField.typeText("password123")
        
        loginButton.tap()
        
        // Then
        let dashboard = app.otherElements["dashboard"]
        XCTAssertTrue(dashboard.waitForExistence(timeout: 5))
    }
}
```

---

## 🚀 Running Tests

### Run Tests in Xcode

1. **Select your test target**
2. **Press ⌘+U** to run all tests
3. **Or select specific tests** and press ⌘+U

### Run Tests from Command Line

```bash
# Run all tests
xcodebuild test -scheme YourApp -destination 'platform=iOS Simulator,name=iPhone 15'

# Run specific test class
xcodebuild test -scheme YourApp -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:YourAppTests/MyFirstTests

# Run specific test method
xcodebuild test -scheme YourApp -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:YourAppTests/MyFirstTests/testFrameworkInitialization
```

### Run Tests Programmatically

```swift
// Run tests programmatically
let testSuite = TestSuite(name: "My Test Suite")
testSuite.addTest(MyFirstTest())

let results = try await testFramework.runTests(testSuite)

// Print results
for result in results {
    print("Test: \(result.name), Status: \(result.status), Duration: \(result.duration)s")
}
```

---

## 📊 Test Reports

### Generate HTML Report

```swift
// Create report generator
let reportGenerator = TestReportGenerator()

// Generate HTML report
let htmlReport = reportGenerator.generateHTMLReport(results)
try htmlReport.write(to: URL(fileURLWithPath: "test-report.html"))
```

### Generate JSON Report

```swift
// Generate JSON report
let jsonReport = reportGenerator.generateJSONReport(results)
try jsonReport.write(to: URL(fileURLWithPath: "test-report.json"))
```

### View Reports

- **HTML Report**: Open `test-report.html` in your browser
- **JSON Report**: Use for CI/CD integration
- **Xcode Test Navigator**: View results directly in Xcode

---

## 🔧 Advanced Configuration

### Performance Testing

```swift
// Configure performance testing
let config = TestConfiguration()
config.enablePerformanceMonitoring = true
config.memoryThreshold = 200 * 1024 * 1024 // 200MB
config.cpuThreshold = 80.0 // 80%

// Run performance test
func testPerformance() {
    measure {
        // Code to measure
        let result = performExpensiveOperation()
        XCTAssertNotNil(result)
    }
}
```

### Security Testing

```swift
// Configure security testing
let config = TestConfiguration()
config.enableSecurityScanning = true
config.securityScanLevel = .comprehensive

// Run security test
func testSecurity() async throws {
    let securityTest = SecurityTest()
    let result = try await testFramework.runSecurityTest(securityTest)
    XCTAssertTrue(result.isSecure)
}
```

### Accessibility Testing

```swift
// Configure accessibility testing
let config = TestConfiguration()
config.enableAccessibilityTesting = true
config.accessibilityLevel = .strict

// Run accessibility test
func testAccessibility() async throws {
    let accessibilityTest = AccessibilityTest()
    let result = try await testFramework.runAccessibilityTest(accessibilityTest)
    XCTAssertTrue(result.isAccessible)
}
```

---

## 🎯 Next Steps

### Explore Advanced Features

1. **Parallel Execution**: Run tests in parallel for faster feedback
2. **Custom Reporters**: Create custom test reporters
3. **CI/CD Integration**: Set up automated testing in your CI/CD pipeline
4. **Performance Monitoring**: Monitor app performance during tests
5. **Security Validation**: Add security testing to your test suite

### Read the Documentation

- 📚 **[API Documentation](API.md)** - Complete API reference
- 🏗️ **[Architecture Guide](Architecture.md)** - Framework architecture
- �� **[Testing Best Practices](BestPractices.md)** - Testing guidelines
- 🔧 **[Configuration Guide](TestConfiguration.md)** - Configuration options

### Join the Community

- 🌟 **Star the repository** if it helped you
- 💬 **Ask questions** in GitHub Discussions
- 🐛 **Report bugs** in GitHub Issues
- 💡 **Suggest features** in GitHub Issues
- 🤝 **Contribute** to the project

---

## 🆘 Troubleshooting

### Common Issues

#### Build Errors

```bash
# Clean build folder
xcodebuild clean -scheme YourApp

# Reset package cache
rm -rf ~/Library/Developer/Xcode/DerivedData
```

#### Test Failures

```bash
# Run tests with verbose output
xcodebuild test -scheme YourApp -destination 'platform=iOS Simulator,name=iPhone 15' -verbose

# Check test logs
tail -f ~/Library/Logs/Xcode/Test/*.log
```

#### Performance Issues

```swift
// Increase timeout for slow tests
config.timeoutInterval = 60.0

// Disable parallel execution for debugging
config.enableParallelExecution = false
```

### Getting Help

- 📚 **Check the documentation** first
- 🔍 **Search existing issues** on GitHub
- 💬 **Ask in GitHub Discussions**
- 📧 **Contact the maintainers**

---

<div align="center">

**🎉 Congratulations! You've successfully set up iOS Testing Automation Framework!**

**🌟 Happy testing!**

</div>
