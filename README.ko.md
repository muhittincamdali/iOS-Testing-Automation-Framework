<!-- i18n-source: README.md@f538d6e779afe3cd003645722b6571419027f952 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/banner-ko-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/banner-ko-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/banner-ko-light.svg" alt="iOS Testing Automation: XCUITest용 로봇, 자가 복구 로케이터, 스크린샷 비교, 접근성 감사, CI 보고서."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/actions/workflows/ci.yml/badge.svg" alt="CI 상태"></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-version-light.svg" alt="최신 버전: v2.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-platforms-light.svg" alt="지원 플랫폼: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-language-light.svg" alt="언어 버전: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-license-light.svg" alt="라이선스: MIT"></picture></a>
</p>

<p align="center">
<a href="#빠른-시작"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-start-ko-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-start-ko-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-start-ko-light.svg" alt="시작하기"></picture></a>
<a href="https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-docs-ko-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-docs-ko-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-docs-ko-light.svg" alt="문서"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-examples-ko-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-examples-ko-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-examples-ko-light.svg" alt="예제"></picture></a>
</p>

> 이 문서는 영어 README의 번역본입니다. 내용이 다를 경우 영어 버전이 최신입니다.

<!-- brand:end -->

iOS와 macOS 앱의 UI 테스트와 단위 테스트를 위한 Swift 패키지입니다. XCUITest에서는 로봇(화면마다 클래스 하나를 두며, 메서드가 대기하고, 단계를 기록하고, 실패를 사용자의 코드 줄에서 보고합니다), 접근성 식별자가 바뀌어도 계속 동작하는 요소 조회, 접근성 감사, 차이 이미지를 포함한 스크린샷 비교, CI용 JUnit 및 Markdown 보고서를 추가합니다. Swift Testing이든 XCTest든 모든 테스트에서 SwiftUI 스냅샷, 폴링 대기, 재시도, 스파이, 시드가 지정된 테스트 데이터를 사용할 수 있습니다. 작은 UI 변경에도 UI 테스트가 깨지거나 CI 로그에서 읽기 어려운 팀을 위한 패키지입니다. 의존성이 없으며 테스트 타깃에만 추가합니다.

## 주요 기능

- **읽기 쉬운 UI 테스트** — 로봇은 `app.buttons["signIn.submit"].tap()` 같은 호출 나열을
  `app.on(SignInRobot.self).signIn(email:password:)`로 바꿔 줍니다. 모든 단계는 요소를 탭할 수 있을 때까지 기다리며, Xcode의 테스트 보고서에 이름이 있는 단계로 표시됩니다.
- **스스로 복구하는 로케이터** — 식별자 이름이 바뀌면 레이블, 플레이스홀더 또는 비슷한 식별자로 요소를 찾고, 해야 할 수정 사항을 로그에 남깁니다. 두 요소가 똑같이 잘 맞으면 추측하지 않습니다.
- **눈으로 확인하는 시각적 회귀** — 스크린샷과 SwiftUI 뷰를 기준 PNG와 비교합니다. 허용 오차, 무시할 영역(시계, 날짜), 바뀐 픽셀이 모두 파란색으로 표시되는 차이 이미지를 지원합니다.
- **실행할 때마다 접근성 점검** — 호출 한 번으로 화면에서 레이블이 없는 컨트롤, 44 × 44 포인트보다 작은 터치 대상, 요소 종류를 반복하는 레이블, 중복된 식별자를 검사하며, Apple의 `performAccessibilityAudit()`도 추가할 수 있습니다.
- **CI에 바로 쓰는 출력** — 테스트 번들마다 `junit.xml`과 Markdown 작업 요약을 만들고, 입력한 비밀번호와 토큰은 가려집니다. 여러 번 실행한 결과로 불안정한 테스트도 분석합니다.
- **검증된 규칙** — 복구, 감사, 이미지 비교, 보고서, 마스킹은 순수 Swift이며, macOS와 iPhone 시뮬레이터에서 Swift Testing 테스트 118개로 검증합니다. [예제 앱](Examples/AutomationShowcase)의 UI 테스트 9개는 CI에서 XCUITest 계층을 처음부터 끝까지 실행합니다.

### 포함된 항목

| 영역               | 타입                                                                                                                                                                     |
| ------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| UI 테스트          | `Robot`, `Locator`, `LocatorHealer`, `HealingLog`, `XCUIElement.element(_:)`, `waitForHittable`, `waitForDisappearance`, `waitForLabel`, `waitForValue`, `descriptors()` |
| 접근성             | `AccessibilityAudit`, `Robot.assertAccessible()`, `XCUIElement.accessibilityIssues()`, `ContrastRatio`                                                                   |
| 이미지             | `assertSnapshot(of:)`, `Robot.assertScreenshot(named:)`, `SnapshotStore`, `ImageComparator`, `Bitmap`, `ViewRenderer`                                                    |
| 보고서             | `TestResultCollector`, `TestReport` (JUnit XML, Markdown), `TestResult`, `Redactor`, `FlakinessAnalyzer`                                                                 |
| 단위 테스트 도우미 | `Wait`, `RetryPolicy`, `Spy`, `ThrowingSpy`, `Fixtures`, `Benchmark`                                                                                                     |

## 빠른 시작

**1. 패키지 추가**

Xcode에서 **File › Add Package Dependencies…** 메뉴를 선택하고 저장소 URL을 입력하세요.

```text
https://github.com/muhittincamdali/iOS-Testing-Automation-Framework.git
```

창 오른쪽 위의 검색란에 붙여 넣으세요. **Dependency Rule**은 `2.0.0`부터 **Up to Next Major Version**으로 그대로 두고 **Add Package**를 클릭합니다. 다음 창에서 **iOSTestingAutomationFramework** 옆에 **UI 테스트 타깃**을 선택하고(앱 타깃이 아닙니다. 이 패키지는 XCTest에 링크됩니다) **Add Package**를 다시 클릭하세요.

아직 UI 테스트 타깃이 없나요? **File › New › Target… › UI Testing Bundle**을 선택하세요.

**2. 모듈 가져오기**

```swift
import iOSTestingAutomationFramework
```

이 줄을 UI 테스트 파일 맨 위, `import XCTest` 아래에 넣으세요.

**3. 사용하기**

새 Xcode 앱(**File › New › Project… › App**, **Include Tests** 체크)에서 `ContentView.swift`의 내용을 모두 다음으로 바꾸세요.

```swift
import SwiftUI

struct ContentView: View {
    @State private var count = 0

    var body: some View {
        VStack(spacing: 16) {
            Text("Tapped \(count) times")
                .accessibilityIdentifier("counter.label")
            Button("Tap me") { count += 1 }
                .buttonStyle(.borderedProminent)
                .accessibilityIdentifier("counter.button")
        }
    }
}
```

그런 다음 UI 테스트 파일(이름이 `UITests.swift`로 끝나는 파일)의 내용을 다음으로 바꾸세요.

```swift
import XCTest
import iOSTestingAutomationFramework

final class CounterRobot: Robot {
    var label: XCUIElement { app.staticTexts["counter.label"] }
    var button: XCUIElement { app.buttons["counter.button"] }
}

final class CounterUITests: XCTestCase {
    @MainActor
    func testTappingCounts() {
        let app = XCUIApplication()
        app.launch()

        let counter = app.on(CounterRobot.self)
        counter
            .tap(counter.button)
            .tap(counter.button)
            .assertLabel(of: counter.label, equals: "Tapped 2 times")
    }
}
```

**⌘U**를 누르세요. 테스트가 시뮬레이터에서 앱을 실행하고 버튼을 두 번 탭한 뒤 통과합니다. 테스트 보고서에서는 각 탭과 레이블 확인이 별도의 단계로 표시됩니다.

## 설치

### Swift Package Manager

Xcode에서 **File › Add Package Dependencies…** 메뉴를 선택하고 저장소 URL을 입력하세요.

```text
https://github.com/muhittincamdali/iOS-Testing-Automation-Framework.git
```

`Package.swift`에서는 의존성을 추가하고, 테스트 타깃 아래에 제품을 나열하세요.

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/iOS-Testing-Automation-Framework.git", from: "2.0.0")
],
targets: [
    .testTarget(name: "YourAppTests", dependencies: [
        .product(name: "iOSTestingAutomationFramework", package: "iOS-Testing-Automation-Framework")
    ])
]
```

## 사용법

UI 테스트 예제는 [예제 앱의 UI 테스트](Examples/AutomationShowcase/AutomationShowcaseUITests)에서, 단위 테스트 예제는
[`ReadmeExamples.swift`](Tests/iOSTestingAutomationFrameworkTests/ReadmeExamples.swift)에서 가져왔으며, CI가 둘 다 실행합니다.

### 화면마다 로봇 작성하기

```swift
final class SignInRobot: Robot {
    var email: XCUIElement { app.textFields["signIn.email"] }
    var password: XCUIElement { app.secureTextFields["signIn.password"] }
    var submit: XCUIElement { app.element(Locator("signIn.submit", label: "Sign In", kind: .button)) }
    var error: XCUIElement { app.staticTexts["signIn.error"] }

    @discardableResult
    func signIn(email address: String, password secret: String) -> CatalogRobot {
        type(address, into: email)
        typeSecret(secret, into: password)
        tap(submit)
        return on(CatalogRobot.self)
    }
}
```

그러면 테스트가 테스트 케이스의 단계처럼 읽힙니다.

```swift
app.on(SignInRobot.self)
    .signIn(email: "ada@example.com", password: "correct-horse-battery")
    .assertCart(contains: 0)
    .open("grinder")
    .addToCart(times: 2)
    .goBack()
    .assertCart(contains: 2)
```

`typeSecret(_:into:)`는 비밀번호를 등록하므로 단계 이름, 실패 메시지, 보고서에서 `••••`로 가려집니다. XCTest는 입력한 텍스트를 자체 단계에 기록하고 그곳에는 어떤 마스킹도 닿지 않으므로, 비밀번호를 입력하지 않고 붙여 넣습니다. 붙여 넣은 뒤 페이스트보드는 비워집니다.

### 식별자가 바뀌어도 테스트 유지하기

`Locator`는 식별자와 함께 사용자가 보는 레이블이나 플레이스홀더를 담고 있습니다. 다음 테스트는 리디자인 이전의 식별자를 그대로 사용합니다.

```swift
// "loginButton" was the identifier before the redesign; the app now uses "signIn.submit".
let button = app.element(Locator("loginButton", label: "Sign In", kind: .button), timeout: 1)
XCTAssertTrue(button.exists)
XCTAssertEqual(button.identifier, "signIn.submit")
```

복구된 조회는 수정 방법과 함께 `HealingLog`와 Markdown 보고서에 기록됩니다.
`Update the locator "loginButton" to "signIn.submit"`

### 접근성 감사하기

```swift
app.on(SignInRobot.self).assertAccessible()
```

발견된 문제는 각각 테스트 실패가 됩니다. 문제를 직접 확인하려면 다음과 같이 하세요.

```swift
let issues = try app.accessibilityIssues()
let favoriteIssues = issues.filter { $0.element.identifier == "audit.favorite" }.map(\.rule)
XCTAssertEqual(Set(favoriteIssues), [.missingLabel, .smallTouchTarget])
```

### 스크린샷 비교하기

`assertScreenshot(named:of:ignoring:)`은 앱(또는 요소 하나)을 테스트 파일 옆의 `__Snapshots__/`에 저장된 기준 PNG와 비교하며, 저절로 바뀌는 요소는 제외할 수 있습니다.

```swift
catalog.assertScreenshot(named: "catalog", ignoring: [catalog.lastUpdated], comparator: comparator, store: store)
```

첫 실행에서는 기준 이미지를 기록하고 실패하므로, 기준 이미지가 없는데 조용히 통과하는 일은 없습니다. 일치하지 않으면 기준 이미지, 실제 스크린샷, 차이 이미지가 테스트 보고서에 첨부됩니다.

### 단위 테스트에서 SwiftUI 뷰 스냅샷 찍기

```swift
@Test @MainActor func signalBarsLookRight() throws {
    try assertSnapshot(of: SignalBars(level: 3), named: "signal-bars-3", size: CGSize(width: 44, height: 32))
}
```

`assertSnapshot`은 문제를 기록하는 대신 오류를 던지므로 Swift Testing과 XCTest에서 똑같이 동작합니다.

### 비동기 상태를 기다리고 가짜 객체 확인하기

```swift
struct FakeUserService: UserService {
    let fetchUser = ThrowingSpy<Int, String>(returning: "Ada")

    func user(id: Int) async throws -> String {
        try fetchUser(id)
    }
}

@Test @MainActor func profileLoadsTheUser() async throws {
    let service = FakeUserService()
    let model = ProfileModel(service: service)

    model.load(id: 42)

    try await Wait.until("the name to load") { model.name == "Ada" }
    #expect(service.fetchUser.inputs == [42])
}
```

### CI에서 결과 보고하기

UI 테스트 번들에 수집기를 한 번 설치하세요.

```swift
override class func setUp() {
    super.setUp()
    // Writes junit.xml and summary.md when TESTING_AUTOMATION_REPORT_DIR is set.
    TestResultCollector.install(reportName: "AutomationShowcase UI tests")
}
```

그리고 테스트를 실행할 때 보고서 폴더를 지정하세요.

```sh
TEST_RUNNER_TESTING_AUTOMATION_REPORT_DIR="$PWD/reports" xcodebuild test \
  -scheme AutomationShowcase -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
cat reports/summary.md >> "$GITHUB_STEP_SUMMARY"   # on GitHub Actions
```

직접 만든 결과로 보고서를 만들려면 다음과 같이 하세요.

```swift
let report = TestReport(name: "Nightly", results: results)
let xml = report.junitXML()
```

## 데모

iPhone 17 Pro 시뮬레이터에서 실행한 [AutomationShowcase](Examples/AutomationShowcase) 앱입니다. 시각적 회귀 테스트는 가격을 숨기고 화면을 기준 이미지와 비교하며, 세 번째 이미지는 패키지가 그린 차이 이미지로 바뀐 픽셀이 모두 파란색입니다. 이미지는 해당 테스트가 저장하고
[`scripts/generate-screenshots.sh`](scripts/generate-screenshots.sh)가 크기를 조정합니다.

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/visual-diff-dark.png"><img src="docs/images/visual-diff-light.png" alt="휴대폰 스크린샷 세 장을 나란히 배치한 그림: 가격이 있는 카탈로그, 가격을 숨긴 카탈로그, 가격과 스위치만 파란색으로 강조된 흐린 차이 이미지" width="840"></picture></p>

UI 테스트를 직접 실행하려면 [`Examples/AutomationShowcase`](Examples/AutomationShowcase)에서 `AutomationShowcase.xcodeproj`를 열고 iPhone 시뮬레이터를 선택한 뒤 **⌘U**를 누르세요. 각 테스트가 보여 주는 내용은 [Examples/README.md](Examples/README.md)에 정리되어 있습니다.

## 문서

API 레퍼런스와 문서:

- [API 레퍼런스](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/)
  (DocC, `main`에서 GitHub Pages로 게시)
- 로컬에서는 Xcode의 **Product › Build Documentation**으로 빌드하거나 명령줄에서 빌드하세요.

```sh
xcodebuild docbuild -scheme iOSTestingAutomationFramework -destination 'generic/platform=iOS Simulator'
```

## 가이드

- [Getting Started](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/gettingstarted)
  — 테스트 타깃에 패키지를 추가하고, 첫 로봇 테스트와 첫 단위 테스트를 작성합니다
  ([소스](Sources/iOSTestingAutomationFramework/iOSTestingAutomationFramework.docc/GettingStarted.md)).
- [Writing UI Tests with Robots](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/writinguitestswithrobots)
  — 로봇 체인, 스스로 복구하는 로케이터, 대기, 접근성 감사
  ([소스](Sources/iOSTestingAutomationFramework/iOSTestingAutomationFramework.docc/WritingUITestsWithRobots.md)).
- [Comparing Screenshots](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/comparingscreenshots)
  — SwiftUI 스냅샷, UI 테스트 스크린샷, 허용 오차, 기록 모드
  ([소스](Sources/iOSTestingAutomationFramework/iOSTestingAutomationFramework.docc/ComparingScreenshots.md)).
- [Reporting on CI](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/reportingonci)
  — JUnit XML, 작업 요약, 마스킹, 불안정한 테스트
  ([소스](Sources/iOSTestingAutomationFramework/iOSTestingAutomationFramework.docc/ReportingOnCI.md)).

## 요구 사항

| 플랫폼 | 최소 버전             |
| ------ | --------------------- |
| iOS    | 17                    |
| macOS  | 14                    |
| 툴체인 | Swift 6.2 · Xcode 26+ |

XCUITest 도우미에는 UI 테스트 타깃이 필요하며, 나머지 도우미는 어떤 테스트 타깃에서도 동작합니다. CI는 GitHub `macos-26` 러너 이미지의 기본 Xcode로 빌드합니다. 이 패키지는 Xcode 27로 개발합니다.

## 아키텍처

- `Sources/iOSTestingAutomationFramework/`에는 영역마다 폴더가 하나씩 있습니다: `Core`, `Reporting`, `Waiting`, `Resilience`, `Locators`, `Accessibility`, `Visual`, `Doubles`, `Fixtures`, `Performance`, `XCUI`.
- `XCUI`를 제외한 모든 것은 순수 Swift입니다. 규칙(복구, 감사, 이미지 비교, 보고서, 마스킹)은 `ElementDescriptor`와 `Bitmap` 같은 값을 대상으로 동작하므로, 단위 테스트가 실행 중인 앱 없이도 이를 검증할 수 있습니다. `XCUI`는 얇은 계층으로, 화면의 스냅샷 한 장을 디스크립터로 바꾸고 XCTest를 통해 실패를 보고합니다.
- 이 패키지는 Swift Testing을 가져오지 않습니다. Xcode는 UI 테스트 번들을 Swift Testing 없이 빌드하므로, 이를 의존하면 모든 UI 테스트 타깃이 깨집니다. 단위 테스트용 어서션은 오류를 던지며, 두 프레임워크 모두 이를 실패로 보고합니다.
- 테스트 외부에서 들어오는 입력에는 한도가 있습니다. 이미지 크기는 디코딩 전에 확인하고, 스냅샷 이름은 안전한 파일 이름으로 바꾸며, NaN과 무한대 값은 변환하지 않고 범위 안으로 제한하며, 스파이, 복구 로그, 감사, 편집 거리 탐색에는 고정 상한이 있습니다. 수집한 테스트 결과와 등록한 비밀 값은 실행하는 동안 모두 유지됩니다.
- CI는 macOS에서 `swift test`를, iPhone 시뮬레이터에서 `xcodebuild test`를 실행하고, iOS와 macOS용으로 빌드하며, 예제 앱의 UI 테스트를 실행하고 DocC 문서를 게시합니다.

로컬에서 테스트를 실행하려면 다음과 같이 하세요.

```sh
swift test                                    # macOS
xcodebuild test -scheme iOSTestingAutomationFramework \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
cd Examples/AutomationShowcase                # the UI tests
xcodebuild test -scheme AutomationShowcase \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

## 로드맵

- 이미지 비교와 함께 쓸 텍스트 및 JSON 스냅샷 방식.
- 서로 다른 기기에서 찍은 스크린샷을 위한 지각 기반 색상 허용 오차.
- 패키지를 Swift Package Index에 추가하기. `.spi.yml`은 이미 저장소에 있습니다.

## 기여하기

기여를 환영합니다. pull request를 열기 전에 [기여 가이드](https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/CONTRIBUTING.md)와 [행동 강령](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md)을 읽어 주세요. 보안 문제는 [보안 정책](https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/SECURITY.md)에 따라 비공개로 제보해 주세요.

## 라이선스

MIT 라이선스로 배포됩니다. 자세한 내용은 [LICENSE](LICENSE)를 참고하세요.
