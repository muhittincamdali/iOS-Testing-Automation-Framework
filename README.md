# iOS Testing Automation Framework

<p align="center">
  <a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-5.9+-F05138?style=flat&logo=swift&logoColor=white" alt="Swift"></a>
  <a href="https://developer.apple.com/ios/"><img src="https://img.shields.io/badge/iOS-15.0+-000000?style=flat&logo=apple&logoColor=white" alt="iOS"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License"></a>
</p>

<p align="center">
  <b>Comprehensive testing tools for iOS: unit tests, UI tests, snapshot testing, and CI/CD integration.</b>
</p>

---

## Features

- **Unit Testing** — Enhanced XCTest utilities and mocks
- **UI Testing** — Page object pattern and accessibility testing
- **Snapshot Testing** — Visual regression testing
- **Performance Testing** — Benchmarks and memory profiling
- **CI/CD Integration** — GitHub Actions, Bitrise, Xcode Cloud

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/iOS-Testing-Automation-Framework.git", from: "1.0.0")
]
```

## Unit Testing

```swift
import XCTest
import iOSTestingFramework

final class UserServiceTests: XCTestCase {
    var sut: UserService!
    var mockAPI: MockAPIClient!
    
    override func setUp() {
        mockAPI = MockAPIClient()
        sut = UserService(api: mockAPI)
    }
    
    func testFetchUser_Success() async throws {
        // Given
        let expectedUser = User(id: 1, name: "John")
        mockAPI.stub(.getUser(id: 1), with: expectedUser)
        
        // When
        let user = try await sut.fetchUser(id: 1)
        
        // Then
        XCTAssertEqual(user, expectedUser)
        XCTAssertTrue(mockAPI.verify(.getUser(id: 1), called: .once))
    }
}
```

## UI Testing

```swift
// Page Object Pattern
class LoginPage: Page {
    var emailField: XCUIElement { app.textFields["emailField"] }
    var passwordField: XCUIElement { app.secureTextFields["passwordField"] }
    var loginButton: XCUIElement { app.buttons["loginButton"] }
    
    func login(email: String, password: String) -> HomePage {
        emailField.tap()
        emailField.typeText(email)
        passwordField.tap()
        passwordField.typeText(password)
        loginButton.tap()
        return HomePage(app: app)
    }
}

// Test
func testLoginFlow() {
    let loginPage = LoginPage(app: app)
    let homePage = loginPage.login(email: "test@example.com", password: "password")
    XCTAssertTrue(homePage.welcomeLabel.exists)
}
```

## Snapshot Testing

```swift
func testProfileView_Snapshot() {
    let view = ProfileView(user: mockUser)
    assertSnapshot(of: view, as: .image)
}

func testProfileView_DarkMode() {
    let view = ProfileView(user: mockUser)
        .preferredColorScheme(.dark)
    assertSnapshot(of: view, as: .image, named: "dark")
}
```

## Performance Testing

```swift
func testDataProcessing_Performance() {
    measure(metrics: [XCTClockMetric(), XCTMemoryMetric()]) {
        _ = processor.process(largeDataSet)
    }
}
```

## Requirements

- iOS 15.0+
- Xcode 15.0+
- Swift 5.9+

## License

MIT License. See [LICENSE](LICENSE).

## Author

**Muhittin Camdali** — [@muhittincamdali](https://github.com/muhittincamdali)
