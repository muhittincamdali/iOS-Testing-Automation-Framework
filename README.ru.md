<!-- i18n-source: README.md@e359efcbf2fd2cbac05fd38b031a929942168a20 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/banner-ru-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/banner-ru-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/banner-ru-light.svg" alt="iOS Testing Automation: Роботы, самовосстанавливающиеся локаторы, сравнение скриншотов, доступность и отчёты CI для XCUITest."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/actions/workflows/ci.yml/badge.svg" alt="Статус CI"></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-version-light.svg" alt="Последняя версия: v2.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-platforms-light.svg" alt="Поддерживаемые платформы: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-language-light.svg" alt="Версия языка: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-license-light.svg" alt="Лицензия: MIT"></picture></a>
</p>

<p align="center">
<a href="#быстрый-старт"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-start-ru-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-start-ru-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-start-ru-light.svg" alt="Начать"></picture></a>
<a href="https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-docs-ru-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-docs-ru-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-docs-ru-light.svg" alt="Документация"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-examples-ru-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-examples-ru-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-examples-ru-light.svg" alt="Примеры"></picture></a>
</p>

> Это перевод README на английском языке. Если они расходятся, актуальна английская версия.

<!-- brand:end -->

Пакет Swift для UI-тестов и модульных тестов приложений iOS и macOS. В XCUITest он добавляет роботов
(по одному классу на экран; их методы ждут, записывают шаг и сообщают о сбоях на вашей строке), поиск
элементов, который продолжает работать после смены идентификатора доступности, аудит доступности,
сравнение скриншотов с изображением различий, а также отчёты JUnit и Markdown для CI. В любом
тесте, на Swift Testing или XCTest, он добавляет снимки SwiftUI, ожидание с опросом, повторные попытки, шпионы (spy) и
тестовые данные с фиксированным seed. Он рассчитан на команды, у которых UI-тесты ломаются от небольших изменений интерфейса или плохо читаются
в логе CI. У пакета нет зависимостей, и подключается он только к вашим тестовым таргетам.

## Основные возможности

- **Читаемые UI-тесты** — роботы превращают цепочки вроде `app.buttons["signIn.submit"].tap()` в
  `app.on(SignInRobot.self).signIn(email:password:)`. Каждый шаг ждёт, пока элемент можно будет
  нажать, и отображается как именованный шаг в отчёте о тестах Xcode.
- **Самовосстанавливающиеся локаторы** — если идентификатор переименован, поиск находит элемент по его
  подписи, подсказке в поле или похожему идентификатору, записывает в лог нужное исправление и отказывается гадать, если два
  элемента подходят одинаково хорошо.
- **Визуальные регрессии, которые видно** — скриншоты и представления SwiftUI сравниваются с
  эталонным PNG с учётом допуска, игнорируемых областей (часы, дата) и изображения различий,
  на котором каждый изменившийся пиксель окрашен в синий.
- **Доступность в каждом запуске** — один вызов проверяет экран на элементы без подписи, области касания
  меньше 44 × 44 пунктов, подписи, повторяющие тип элемента, и дублирующиеся идентификаторы,
  и может добавить `performAccessibilityAudit()` от Apple.
- **Вывод, готовый для CI** — `junit.xml` и сводка задания в Markdown для каждого тестового бандла; введённые
  пароли и токены маскируются. Дополнительно есть анализ нестабильных тестов по нескольким запускам.
- **Протестированные правила** — восстановление локаторов, аудит, сравнение изображений, отчёты и маскирование
  написаны на чистом Swift и покрыты 118 тестами Swift Testing на macOS и в симуляторе iPhone; 9 UI-тестов
  в [демонстрационном приложении](Examples/AutomationShowcase) прогоняют слой XCUITest целиком в CI.

### Что входит в пакет

| Область                        | Типы                                                                                                                                                                     |
| ------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| UI-тесты                       | `Robot`, `Locator`, `LocatorHealer`, `HealingLog`, `XCUIElement.element(_:)`, `waitForHittable`, `waitForDisappearance`, `waitForLabel`, `waitForValue`, `descriptors()` |
| Доступность                    | `AccessibilityAudit`, `Robot.assertAccessible()`, `XCUIElement.accessibilityIssues()`, `ContrastRatio`                                                                   |
| Изображения                    | `assertSnapshot(of:)`, `Robot.assertScreenshot(named:)`, `SnapshotStore`, `ImageComparator`, `Bitmap`, `ViewRenderer`                                                    |
| Отчёты                         | `TestResultCollector`, `TestReport` (JUnit XML, Markdown), `TestResult`, `Redactor`, `FlakinessAnalyzer`                                                                 |
| Помощники для модульных тестов | `Wait`, `RetryPolicy`, `Spy`, `ThrowingSpy`, `Fixtures`, `Benchmark`                                                                                                     |

## Быстрый старт

**1. Добавьте пакет**

В Xcode выберите **File › Add Package Dependencies…** и введите адрес репозитория:

```text
https://github.com/muhittincamdali/iOS-Testing-Automation-Framework.git
```

Вставьте его в поле поиска в правом верхнем углу окна. Оставьте **Dependency Rule** равным
**Up to Next Major Version** начиная с `2.0.0` и нажмите **Add Package**. В следующем окне выберите
свой **таргет UI-тестов** напротив **iOSTestingAutomationFramework** (не таргет приложения: пакет
подключает XCTest) и снова нажмите **Add Package**.

Ещё нет таргета UI-тестов? Выберите **File › New › Target… › UI Testing Bundle**.

**2. Импортируйте модуль**

```swift
import iOSTestingAutomationFramework
```

Поместите эту строку в начало файла UI-тестов, под `import XCTest`.

**3. Используйте**

В новом приложении Xcode (**File › New › Project… › App**, с включённым **Include Tests**) замените
всё содержимое `ContentView.swift` на:

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

Затем замените содержимое файла UI-тестов (того, имя которого оканчивается на `UITests.swift`) на:

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

Нажмите **⌘U**. Тест запустит приложение в симуляторе, дважды нажмёт кнопку и завершится успешно. В
отчёте о тестах каждое нажатие и проверка подписи отображаются отдельным шагом.

## Установка

### Swift Package Manager

В Xcode выберите **File › Add Package Dependencies…** и введите адрес репозитория:

```text
https://github.com/muhittincamdali/iOS-Testing-Automation-Framework.git
```

В `Package.swift` добавьте зависимость и укажите продукт в своих тестовых таргетах:

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

## Использование

Примеры UI-тестов взяты из [UI-тестов демонстрационного приложения](Examples/AutomationShowcase/AutomationShowcaseUITests),
а примеры модульных тестов — из
[`ReadmeExamples.swift`](Tests/iOSTestingAutomationFrameworkTests/ReadmeExamples.swift); CI запускает
и те, и другие.

### Напишите робота для каждого экрана

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

Тогда тесты читаются как шаги тест-кейса:

```swift
app.on(SignInRobot.self)
    .signIn(email: "ada@example.com", password: "correct-horse-battery")
    .assertCart(contains: 0)
    .open("grinder")
    .addToCart(times: 2)
    .goBack()
    .assertCart(contains: 2)
```

`typeSecret(_:into:)` регистрирует пароль, поэтому он маскируется как `••••` в названиях шагов, сообщениях о сбоях
и отчётах. Пароль вставляется, а не вводится, потому что XCTest записывает введённый текст в свои
собственные шаги, куда не доходит никакое маскирование. После вставки буфер обмена очищается.

### Сохраните работоспособность тестов при смене идентификатора

`Locator` хранит идентификатор вместе с подписью или подсказкой в поле, которые видит человек. Здесь тест
всё ещё использует идентификатор, действовавший до редизайна:

```swift
// "loginButton" was the identifier before the redesign; the app now uses "signIn.submit".
let button = app.element(Locator("loginButton", label: "Sign In", kind: .button), timeout: 1)
XCTAssertTrue(button.exists)
XCTAssertEqual(button.identifier, "signIn.submit")
```

Восстановленный поиск записывается в `HealingLog` и в отчёт Markdown вместе с исправлением:
`Update the locator "loginButton" to "signIn.submit"`.

### Проверьте доступность

```swift
app.on(SignInRobot.self).assertAccessible()
```

Каждая проблема становится сбоем теста. Чтобы изучить проблемы самостоятельно:

```swift
let issues = try app.accessibilityIssues()
let favoriteIssues = issues.filter { $0.element.identifier == "audit.favorite" }.map(\.rule)
XCTAssertEqual(Set(favoriteIssues), [.missingLabel, .smallTouchTarget])
```

### Сравните скриншоты

`assertScreenshot(named:of:ignoring:)` сравнивает приложение (или один элемент) с эталонным PNG,
который лежит в `__Snapshots__/` рядом с файлом теста; элементы, которые меняются сами по себе, можно исключить:

```swift
catalog.assertScreenshot(named: "catalog", ignoring: [catalog.lastUpdated], comparator: comparator, store: store)
```

Первый запуск записывает эталон и завершается сбоем, поэтому отсутствующий эталон никогда не проходит незаметно. При
расхождении эталон, фактический скриншот и изображение различий прикрепляются к отчёту о тестах.

### Снимок представления SwiftUI в модульном тесте

```swift
@Test @MainActor func signalBarsLookRight() throws {
    try assertSnapshot(of: SignalBars(level: 3), named: "signal-bars-3", size: CGSize(width: 44, height: 32))
}
```

`assertSnapshot` выбрасывает ошибку, а не записывает проблему, поэтому одинаково работает в Swift Testing и
в XCTest.

### Дождитесь асинхронного состояния и проверьте подставную реализацию

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

### Отчёты о результатах в CI

Один раз установите коллектор в своём бандле UI-тестов:

```swift
override class func setUp() {
    super.setUp()
    // Writes junit.xml and summary.md when TESTING_AUTOMATION_REPORT_DIR is set.
    TestResultCollector.install(reportName: "AutomationShowcase UI tests")
}
```

и укажите папку отчёта при запуске тестов:

```sh
TEST_RUNNER_TESTING_AUTOMATION_REPORT_DIR="$PWD/reports" xcodebuild test \
  -scheme AutomationShowcase -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
cat reports/summary.md >> "$GITHUB_STEP_SUMMARY"   # on GitHub Actions
```

Чтобы построить отчёт из собственных результатов:

```swift
let report = TestReport(name: "Nightly", results: results)
let xml = report.junitXML()
```

## Демо

Приложение [AutomationShowcase](Examples/AutomationShowcase) в симуляторе iPhone 17 Pro. Его
тест визуальной регрессии скрывает цены и сравнивает экран с эталоном; третье
изображение — изображение различий, нарисованное пакетом, где каждый изменившийся пиксель синий. Изображения
сохраняет этот тест, а масштабирует их
[`scripts/generate-screenshots.sh`](scripts/generate-screenshots.sh).

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/visual-diff-dark.png"><img src="docs/images/visual-diff-light.png" alt="Три скриншота телефона рядом: каталог с ценами, каталог со скрытыми ценами и приглушённое изображение различий, где синим выделены только цены и переключатель" width="840"></picture></p>

Чтобы запустить UI-тесты самостоятельно, откройте `AutomationShowcase.xcodeproj` в
[`Examples/AutomationShowcase`](Examples/AutomationShowcase), выберите симулятор iPhone и нажмите
**⌘U**. В [Examples/README.md](Examples/README.md) перечислено, что показывает каждый тест.

## Документация

Справочник API и статьи:

- [Справочник API](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/)
  (DocC, публикуется на GitHub Pages из ветки `main`)
- Соберите его локально в Xcode через **Product › Build Documentation** или из командной строки:

```sh
xcodebuild docbuild -scheme iOSTestingAutomationFramework -destination 'generic/platform=iOS Simulator'
```

## Руководства

- [Getting Started](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/gettingstarted)
  — добавление пакета в тестовые таргеты, первый тест с роботом и первый модульный тест
  ([исходник](Sources/iOSTestingAutomationFramework/iOSTestingAutomationFramework.docc/GettingStarted.md)).
- [Writing UI Tests with Robots](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/writinguitestswithrobots)
  — цепочки роботов, самовосстанавливающиеся локаторы, ожидания и аудит доступности
  ([исходник](Sources/iOSTestingAutomationFramework/iOSTestingAutomationFramework.docc/WritingUITestsWithRobots.md)).
- [Comparing Screenshots](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/comparingscreenshots)
  — снимки SwiftUI, скриншоты UI-тестов, допуски и режимы записи
  ([исходник](Sources/iOSTestingAutomationFramework/iOSTestingAutomationFramework.docc/ComparingScreenshots.md)).
- [Reporting on CI](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/reportingonci)
  — JUnit XML, сводки заданий, маскирование и нестабильные тесты
  ([исходник](Sources/iOSTestingAutomationFramework/iOSTestingAutomationFramework.docc/ReportingOnCI.md)).

## Требования

| Платформа   | Минимальная версия    |
| ----------- | --------------------- |
| iOS         | 17                    |
| macOS       | 14                    |
| Инструменты | Swift 6.2 · Xcode 26+ |

Помощникам XCUITest нужен таргет UI-тестов; остальные помощники работают в любом тестовом таргете. CI собирает проект
в Xcode по умолчанию из образа раннера `macos-26` на GitHub. Пакет разрабатывается в
Xcode 27.

## Архитектура

- В `Sources/iOSTestingAutomationFramework/` для каждой области есть своя папка: `Core`, `Reporting`,
  `Waiting`, `Resilience`, `Locators`, `Accessibility`, `Visual`, `Doubles`, `Fixtures`,
  `Performance` и `XCUI`.
- Всё за пределами `XCUI` — чистый Swift. Правила (восстановление, аудит, сравнение изображений,
  отчёты, маскирование) работают со значениями вроде `ElementDescriptor` и `Bitmap`, поэтому модульные тесты
  покрывают их без запущенного приложения. `XCUI` — тонкий слой, который превращает один снимок экрана
  в дескрипторы и сообщает о сбоях через XCTest.
- Пакет не импортирует Swift Testing: Xcode собирает бандлы UI-тестов без доступного Swift Testing,
  поэтому зависимость от него сломала бы каждый таргет UI-тестов. Проверки, предназначенные для модульных
  тестов, выбрасывают ошибки, и оба фреймворка сообщают о них как о сбое.
- Входные данные извне теста ограничены: размеры изображений проверяются до декодирования, имена
  снимков превращаются в безопасные имена файлов, NaN и бесконечные числа ограничиваются, а не преобразуются, а у
  шпионов, журнала восстановления, аудита и поиска по расстоянию редактирования есть фиксированные пределы.
  Собранные результаты тестов и зарегистрированные секреты хранятся полностью до конца запуска.
- CI запускает `swift test` на macOS и `xcodebuild test` в симуляторе iPhone, собирает проект для iOS и
  macOS, запускает UI-тесты демонстрационного приложения и публикует документацию DocC.

Запустите тесты локально:

```sh
swift test                                    # macOS
xcodebuild test -scheme iOSTestingAutomationFramework \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
cd Examples/AutomationShowcase                # the UI tests
xcodebuild test -scheme AutomationShowcase \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

## План развития

- Стратегии текстовых и JSON-снимков рядом со сравнением изображений.
- Перцептивный допуск по цвету для скриншотов, сделанных на разных машинах.
- Добавить пакет в Swift Package Index; файл `.spi.yml` уже есть в репозитории.

## Участие в разработке

Мы рады вашему участию. Перед открытием pull request прочитайте [руководство для участников](https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/CONTRIBUTING.md) и [кодекс поведения](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md). О проблемах безопасности сообщайте конфиденциально, как описано в [политике безопасности](https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/SECURITY.md).

## Лицензия

Распространяется по лицензии MIT. Подробнее — в файле [LICENSE](LICENSE).
