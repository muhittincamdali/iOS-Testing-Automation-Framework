<!-- i18n-source: README.md@e359efcbf2fd2cbac05fd38b031a929942168a20 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/banner-zh-CN-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/banner-zh-CN-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/banner-zh-CN-light.svg" alt="iOS Testing Automation: 面向 XCUITest 的 Robot、自愈定位、截图对比、无障碍审查和 CI 报告。"></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/actions/workflows/ci.yml/badge.svg" alt="CI 状态"></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-version-light.svg" alt="最新版本: v2.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-platforms-light.svg" alt="支持的平台: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-language-light.svg" alt="语言版本: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-license-light.svg" alt="许可证: MIT"></picture></a>
</p>

<p align="center">
<a href="#快速开始"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-start-zh-CN-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-start-zh-CN-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-start-zh-CN-light.svg" alt="开始使用"></picture></a>
<a href="https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-docs-zh-CN-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-docs-zh-CN-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-docs-zh-CN-light.svg" alt="文档"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-examples-zh-CN-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-examples-zh-CN-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-examples-zh-CN-light.svg" alt="示例"></picture></a>
</p>

> 本文是英文 README 的译文。如两者内容不一致，以英文版为准。

<!-- brand:end -->

这是一个用于 iOS 和 macOS 应用 UI 测试与单元测试的 Swift 软件包。在 XCUITest 中，它提供 Robot（每个界面对应一个类，其方法会等待、记录步骤，并在你的代码行上报告失败）、在无障碍标识符变更后依然有效的元素查找、无障碍审查、带差异图的截图对比，以及面向 CI 的 JUnit 和 Markdown 报告。在任何测试中（无论是 Swift Testing 还是 XCTest），它还提供 SwiftUI 快照、轮询等待、重试、spy 和带种子的测试数据。它适合这样的团队：UI 测试会因细小的界面改动而失败，或者在 CI 日志里难以阅读。该软件包没有任何依赖，只需添加到你的测试 target 中。

## 亮点

- **可读的 UI 测试** — Robot 把 `app.buttons["signIn.submit"].tap()` 这样的操作序列变成
  `app.on(SignInRobot.self).signIn(email:password:)`。每一步都会等到对应元素可以点击，并在 Xcode 的测试报告中显示为一个有名称的步骤。
- **会自愈的定位** — 标识符被重命名后，查找会通过元素的标签、占位符或相似的标识符找到它，记录需要做的修复；当两个元素匹配程度相同时，它会拒绝猜测。
- **看得见的视觉回归** — 截图和 SwiftUI 视图会与基准 PNG 对比，支持容差、忽略区域（时钟、日期），并生成差异图，其中每个变化的像素都显示为蓝色。
- **每次运行都做无障碍检查** — 一次调用即可检查界面上没有标签的控件、小于 44 × 44 点的触控目标、重复元素类型的标签以及重复的标识符，还可以加入 Apple 的 `performAccessibilityAudit()`。
- **适合 CI 的输出** — 为每个测试包生成 `junit.xml` 和 Markdown 作业摘要，输入的密码和令牌会被遮蔽，还能对多次运行做不稳定测试分析。
- **经过测试的规则** — 自愈、审查、图像对比、报告和遮蔽都是纯 Swift 实现，在 macOS 和 iPhone 模拟器上由 118 个 Swift Testing 测试覆盖；[示例应用](Examples/AutomationShowcase)中的 9 个 UI 测试在 CI 上端到端运行 XCUITest 层。

### 包含的内容

| 领域         | 类型                                                                                                                                                                     |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| UI 测试      | `Robot`, `Locator`, `LocatorHealer`, `HealingLog`, `XCUIElement.element(_:)`, `waitForHittable`, `waitForDisappearance`, `waitForLabel`, `waitForValue`, `descriptors()` |
| 无障碍       | `AccessibilityAudit`, `Robot.assertAccessible()`, `XCUIElement.accessibilityIssues()`, `ContrastRatio`                                                                   |
| 图像         | `assertSnapshot(of:)`, `Robot.assertScreenshot(named:)`, `SnapshotStore`, `ImageComparator`, `Bitmap`, `ViewRenderer`                                                    |
| 报告         | `TestResultCollector`, `TestReport` (JUnit XML, Markdown), `TestResult`, `Redactor`, `FlakinessAnalyzer`                                                                 |
| 单元测试辅助 | `Wait`, `RetryPolicy`, `Spy`, `ThrowingSpy`, `Fixtures`, `Benchmark`                                                                                                     |

## 快速开始

**1. 添加软件包**

在 Xcode 中选择 **File › Add Package Dependencies…**，然后输入仓库地址：

```text
https://github.com/muhittincamdali/iOS-Testing-Automation-Framework.git
```

将它粘贴到窗口右上角的搜索框中。保持 **Dependency Rule** 为从 `2.0.0` 开始的 **Up to Next Major Version**，然后点击 **Add Package**。在下一个窗口中，在 **iOSTestingAutomationFramework** 旁选择你的 **UI 测试 target**（不是应用 target：该软件包会链接 XCTest），再次点击 **Add Package**。

还没有 UI 测试 target？请选择 **File › New › Target… › UI Testing Bundle**。

**2. 导入模块**

```swift
import iOSTestingAutomationFramework
```

把这一行放在 UI 测试文件的顶部，`import XCTest` 的下面。

**3. 开始使用**

在新建的 Xcode 应用中（**File › New › Project… › App**，并勾选 **Include Tests**），把 `ContentView.swift` 的全部内容替换为：

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

然后把 UI 测试文件（以 `UITests.swift` 结尾的那个）的内容替换为：

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

按下 **⌘U**。测试会在模拟器上启动应用，点击按钮两次并通过。在测试报告中，每次点击和标签检查都会显示为单独的步骤。

## 安装

### Swift Package Manager

在 Xcode 中选择 **File › Add Package Dependencies…**，然后输入仓库地址：

```text
https://github.com/muhittincamdali/iOS-Testing-Automation-Framework.git
```

在 `Package.swift` 中，添加依赖，并把产品列在你的测试 target 下：

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

## 使用方法

UI 测试示例来自[示例应用的 UI 测试](Examples/AutomationShowcase/AutomationShowcaseUITests)，单元测试示例来自
[`ReadmeExamples.swift`](Tests/iOSTestingAutomationFrameworkTests/ReadmeExamples.swift)；CI 会运行这两部分。

### 为每个界面编写一个 Robot

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

这样，测试读起来就像测试用例的步骤：

```swift
app.on(SignInRobot.self)
    .signIn(email: "ada@example.com", password: "correct-horse-battery")
    .assertCart(contains: 0)
    .open("grinder")
    .addToCart(times: 2)
    .goBack()
    .assertCart(contains: 2)
```

`typeSecret(_:into:)` 会登记密码，因此密码在步骤名称、失败信息和报告中都会显示为 `••••`。它会粘贴密码而不是逐字输入，因为 XCTest 会把输入的文本记录在它自己的步骤中，任何遮蔽器都触及不到那里。粘贴后剪贴板会被清空。

### 标识符变更后让测试继续可用

`Locator` 同时携带标识符，以及用户看到的标签或占位符。下面的测试仍在使用改版之前的标识符：

```swift
// "loginButton" was the identifier before the redesign; the app now uses "signIn.submit".
let button = app.element(Locator("loginButton", label: "Sign In", kind: .button), timeout: 1)
XCTAssertTrue(button.exists)
XCTAssertEqual(button.identifier, "signIn.submit")
```

自愈后的查找会连同修复建议一起记录在 `HealingLog` 和 Markdown 报告中：
`Update the locator "loginButton" to "signIn.submit"`。

### 审查无障碍

```swift
app.on(SignInRobot.self).assertAccessible()
```

每个问题都会变成一次测试失败。如果想自己检查这些问题：

```swift
let issues = try app.accessibilityIssues()
let favoriteIssues = issues.filter { $0.element.identifier == "audit.favorite" }.map(\.rule)
XCTAssertEqual(Set(favoriteIssues), [.missingLabel, .smallTouchTarget])
```

### 对比截图

`assertScreenshot(named:of:ignoring:)` 会把应用（或某个元素）与保存在测试文件旁 `__Snapshots__/` 中的基准 PNG 对比，并排除会自行变化的元素：

```swift
catalog.assertScreenshot(named: "catalog", ignoring: [catalog.lastUpdated], comparator: comparator, store: store)
```

首次运行会记录基准图并判定失败，因此缺失基准图的情况不会被悄悄放过。出现不一致时，基准图、实际截图和差异图都会附加到测试报告中。

### 在单元测试中为 SwiftUI 视图做快照

```swift
@Test @MainActor func signalBarsLookRight() throws {
    try assertSnapshot(of: SignalBars(level: 3), named: "signal-bars-3", size: CGSize(width: 44, height: 32))
}
```

`assertSnapshot` 会抛出错误而不是记录问题，因此它在 Swift Testing 和 XCTest 中的行为一致。

### 等待异步状态并检查测试替身

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

### 在 CI 上报告结果

在 UI 测试包中安装一次收集器：

```swift
override class func setUp() {
    super.setUp()
    // Writes junit.xml and summary.md when TESTING_AUTOMATION_REPORT_DIR is set.
    TestResultCollector.install(reportName: "AutomationShowcase UI tests")
}
```

并在运行测试时指定报告目录：

```sh
TEST_RUNNER_TESTING_AUTOMATION_REPORT_DIR="$PWD/reports" xcodebuild test \
  -scheme AutomationShowcase -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
cat reports/summary.md >> "$GITHUB_STEP_SUMMARY"   # on GitHub Actions
```

要根据你自己的结果生成报告：

```swift
let report = TestReport(name: "Nightly", results: results)
let xml = report.junitXML()
```

## 演示

[AutomationShowcase](Examples/AutomationShowcase) 应用在 iPhone 17 Pro 模拟器上的效果。它的视觉回归测试会隐藏价格，并将界面与基准图对比；第三张图是软件包绘制的差异图，每个变化的像素都显示为蓝色。这些图片由该测试保存，并由
[`scripts/generate-screenshots.sh`](scripts/generate-screenshots.sh) 缩放。

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/visual-diff-dark.png"><img src="docs/images/visual-diff-light.png" alt="并排的三张手机截图：带价格的目录页、隐藏价格后的目录页，以及一张淡化的差异图，其中只有价格和开关以蓝色高亮" width="840"></picture></p>

要自己运行这些 UI 测试，请打开 [`Examples/AutomationShowcase`](Examples/AutomationShowcase) 中的 `AutomationShowcase.xcodeproj`，选择一个 iPhone 模拟器，然后按下 **⌘U**。[Examples/README.md](Examples/README.md) 列出了每个测试演示的内容。

## 文档

API 参考文档与文章：

- [API 参考](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/)
  （DocC，从 `main` 发布到 GitHub Pages）
- 可以在 Xcode 中通过 **Product › Build Documentation** 在本地构建，也可以使用命令行：

```sh
xcodebuild docbuild -scheme iOSTestingAutomationFramework -destination 'generic/platform=iOS Simulator'
```

## 指南

- [Getting Started](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/gettingstarted)
  — 将软件包添加到测试 target，编写第一个 Robot 测试和第一个单元测试
  （[源文件](Sources/iOSTestingAutomationFramework/iOSTestingAutomationFramework.docc/GettingStarted.md)）。
- [Writing UI Tests with Robots](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/writinguitestswithrobots)
  — Robot 链式调用、自愈定位、等待和无障碍审查
  （[源文件](Sources/iOSTestingAutomationFramework/iOSTestingAutomationFramework.docc/WritingUITestsWithRobots.md)）。
- [Comparing Screenshots](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/comparingscreenshots)
  — SwiftUI 快照、UI 测试截图、容差和记录模式
  （[源文件](Sources/iOSTestingAutomationFramework/iOSTestingAutomationFramework.docc/ComparingScreenshots.md)）。
- [Reporting on CI](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/reportingonci)
  — JUnit XML、作业摘要、遮蔽和不稳定测试
  （[源文件](Sources/iOSTestingAutomationFramework/iOSTestingAutomationFramework.docc/ReportingOnCI.md)）。

## 系统要求

| 平台   | 最低版本              |
| ------ | --------------------- |
| iOS    | 17                    |
| macOS  | 14                    |
| 工具链 | Swift 6.2 · Xcode 26+ |

XCUITest 辅助功能需要 UI 测试 target；其他辅助功能可在任何测试 target 中使用。CI 使用 GitHub `macos-26` 运行器镜像的默认 Xcode 构建。该软件包使用 Xcode 27 开发。

## 架构

- `Sources/iOSTestingAutomationFramework/` 下每个领域一个文件夹：`Core`、`Reporting`、`Waiting`、`Resilience`、`Locators`、`Accessibility`、`Visual`、`Doubles`、`Fixtures`、`Performance` 和 `XCUI`。
- `XCUI` 之外的所有内容都是纯 Swift。各项规则（自愈、审查、图像对比、报告、遮蔽）作用于 `ElementDescriptor` 和 `Bitmap` 等值，因此单元测试无需运行应用就能覆盖它们。`XCUI` 是一个很薄的层：它把界面的一次快照转换为描述符，并通过 XCTest 报告失败。
- 该软件包不导入 Swift Testing：Xcode 构建 UI 测试包时无法使用 Swift Testing，依赖它会让所有 UI 测试 target 构建失败。面向单元测试的断言会抛出错误，两种框架都会把它报告为失败。
- 来自测试之外的输入都有限制：图像尺寸在解码前检查，快照名称会变成安全的文件名，NaN 和无穷大会被截断而不是转换；Spy、修复日志、审查和编辑距离搜索都有固定上限。收集到的测试结果和登记的机密会在整个运行期间完整保留。
- CI 会在 macOS 上运行 `swift test`，在 iPhone 模拟器上运行 `xcodebuild test`，为 iOS 和 macOS 构建，运行示例应用的 UI 测试，并发布 DocC 文档。

在本地运行测试：

```sh
swift test                                    # macOS
xcodebuild test -scheme iOSTestingAutomationFramework \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
cd Examples/AutomationShowcase                # the UI tests
xcodebuild test -scheme AutomationShowcase \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

## 路线图

- 在图像对比之外，增加文本和 JSON 快照策略。
- 为在不同机器上截取的截图提供基于感知的颜色容差。
- 将该软件包添加到 Swift Package Index；`.spi.yml` 已在仓库中。

## 参与贡献

欢迎参与贡献。提交 pull request 之前，请先阅读[贡献指南](https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/CONTRIBUTING.md)和[行为准则](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md)。如发现安全问题，请按照[安全策略](https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/SECURITY.md)私下报告。

## 许可证

基于 MIT 许可证发布。详见 [LICENSE](LICENSE)。
