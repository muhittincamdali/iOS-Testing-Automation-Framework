<!-- i18n-source: README.md@96afd867c60fbff34acfc396cf2b8d69f0d0f58f status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/banner-de-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/banner-de-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/banner-de-light.svg" alt="iOS Testing Automation: Robots, selbstheilende Locators, Screenshot-Diffs, Barrierefreiheitsprüfung und CI-Berichte für XCUITest."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/actions/workflows/ci.yml/badge.svg" alt="CI-Status"></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-version-light.svg" alt="Aktuelle Version: v1.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-platforms-light.svg" alt="Unterstützte Plattformen: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-language-light.svg" alt="Sprachversion: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-license-light.svg" alt="Lizenz: MIT"></picture></a>
</p>

<p align="center">
<a href="#schnellstart"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-start-de-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-start-de-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-start-de-light.svg" alt="Loslegen"></picture></a>
<a href="https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-docs-de-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-docs-de-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-docs-de-light.svg" alt="Dokumentation"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-examples-de-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-examples-de-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-examples-de-light.svg" alt="Beispiele"></picture></a>
</p>

> Dies ist eine Übersetzung der englischen README. Bei Abweichungen gilt die englische Fassung.

<!-- brand:end -->

Ein Swift-Paket für UI-Tests und Unit-Tests von iOS- und macOS-Apps. In XCUITest ergänzt es Robots
(eine Klasse pro Bildschirm, deren Methoden warten, einen Schritt protokollieren und Fehler in deiner Zeile melden),
Elementsuchen, die nach der Änderung eines Accessibility-Identifiers weiter funktionieren, eine Barrierefreiheitsprüfung,
Screenshot-Vergleiche mit einem Differenzbild sowie JUnit- und Markdown-Berichte für CI. In jedem
Test, ob Swift Testing oder XCTest, ergänzt es SwiftUI-Snapshots, Polling-Wartezeiten, Wiederholungen, Spies und
Testdaten mit festem Seed. Es richtet sich an Teams, deren UI-Tests bei kleinen UI-Änderungen brechen oder in einem CI-Log
schwer zu lesen sind. Das Paket hat keine Abhängigkeiten und kommt nur in deine Test-Targets.

## Highlights

- **Lesbare UI-Tests** — Robots machen aus Abfolgen wie `app.buttons["signIn.submit"].tap()` einen Aufruf wie
  `app.on(SignInRobot.self).signIn(email:password:)`. Jeder Schritt wartet, bis sein Element angetippt werden kann,
  und erscheint als benannter Schritt im Testbericht von Xcode.
- **Locators, die sich selbst heilen** — wird ein Identifier umbenannt, findet die Suche das Element über sein
  Label, seinen Platzhalter oder einen ähnlichen Identifier, protokolliert die nötige Korrektur und verweigert das Raten, wenn zwei
  Elemente gleich gut passen.
- **Visuelle Regressionen, die du siehst** — Screenshots und SwiftUI-Views werden mit einem
  PNG als Referenz verglichen, mit Toleranz, ignorierten Bereichen (Uhr, Datum) und einem Differenzbild,
  in dem jedes geänderte Pixel blau ist.
- **Barrierefreiheit in jedem Lauf** — ein Aufruf prüft den Bildschirm auf Bedienelemente ohne Label, Touch-Ziele
  unter 44 × 44 Punkten, Labels, die den Elementtyp wiederholen, und doppelte Identifier
  und kann Apples `performAccessibilityAudit()` hinzunehmen.
- **Ausgabe für CI** — `junit.xml` und eine Markdown-Jobzusammenfassung für jedes Test-Bundle, wobei eingegebene
  Passwörter und Tokens maskiert werden, dazu eine Analyse instabiler Tests über mehrere Läufe.
- **Getestete Regeln** — der Healer, die Prüfung, der Bildvergleich, die Berichte und die Maskierung
  sind reines Swift und werden von 112 Swift-Testing-Tests auf macOS und einem iPhone-Simulator abgedeckt; 9 UI-Tests
  in der [Beispiel-App](Examples/AutomationShowcase) führen die XCUITest-Schicht in CI durchgängig aus.

### Was enthalten ist

| Bereich               | Typen                                                                                                                                                                    |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| UI-Tests              | `Robot`, `Locator`, `LocatorHealer`, `HealingLog`, `XCUIElement.element(_:)`, `waitForHittable`, `waitForDisappearance`, `waitForLabel`, `waitForValue`, `descriptors()` |
| Barrierefreiheit      | `AccessibilityAudit`, `Robot.assertAccessible()`, `XCUIElement.accessibilityIssues()`, `ContrastRatio`                                                                   |
| Bilder                | `assertSnapshot(of:)`, `Robot.assertScreenshot(named:)`, `SnapshotStore`, `ImageComparator`, `Bitmap`, `ViewRenderer`                                                    |
| Berichte              | `TestResultCollector`, `TestReport` (JUnit XML, Markdown), `TestResult`, `Redactor`, `FlakinessAnalyzer`                                                                 |
| Hilfen für Unit-Tests | `Wait`, `RetryPolicy`, `Spy`, `ThrowingSpy`, `Fixtures`, `Benchmark`                                                                                                     |

## Schnellstart

**1. Paket hinzufügen**

Wähle in Xcode **File › Add Package Dependencies…** und gib die Repository-URL ein:

```text
https://github.com/muhittincamdali/iOS-Testing-Automation-Framework.git
```

Füge sie in das Suchfeld oben rechts im Fenster ein. Lass **Dependency Rule** auf
**Up to Next Major Version** ab `2.0.0` stehen und klicke auf **Add Package**. Wähle im nächsten Fenster
neben **iOSTestingAutomationFramework** dein **UI-Test-Target** (nicht das App-Target: Das
Paket linkt XCTest) und klicke erneut auf **Add Package**.

Noch kein UI-Test-Target? Wähle **File › New › Target… › UI Testing Bundle**.

**2. Modul importieren**

```swift
import iOSTestingAutomationFramework
```

Setze diese Zeile an den Anfang deiner UI-Testdatei, unter `import XCTest`.

**3. Verwenden**

Ersetze in einer neuen Xcode-App (**File › New › Project… › App**, mit aktiviertem **Include Tests**)
den gesamten Inhalt von `ContentView.swift` durch:

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

Ersetze dann den Inhalt der UI-Testdatei (die auf `UITests.swift` endet) durch:

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

Drücke **⌘U**. Der Test startet die App im Simulator, tippt zweimal auf den Button und besteht. Im
Testbericht erscheinen jeder Tipp und die Label-Prüfung als eigener Schritt.

## Installation

### Swift Package Manager

Wähle in Xcode **File › Add Package Dependencies…** und gib die Repository-URL ein:

```text
https://github.com/muhittincamdali/iOS-Testing-Automation-Framework.git
```

Füge in einer `Package.swift` die Abhängigkeit hinzu und trage das Produkt unter deinen Test-Targets ein:

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

## Verwendung

Die UI-Test-Beispiele stammen aus den [UI-Tests der Beispiel-App](Examples/AutomationShowcase/AutomationShowcaseUITests)
und die Unit-Test-Beispiele aus
[`ReadmeExamples.swift`](Tests/iOSTestingAutomationFrameworkTests/ReadmeExamples.swift); CI führt
beide aus.

### Schreibe für jeden Bildschirm einen Robot

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

Tests lesen sich dann wie die Schritte eines Testfalls:

```swift
app.on(SignInRobot.self)
    .signIn(email: "ada@example.com", password: "correct-horse-battery")
    .assertCart(contains: 0)
    .open("grinder")
    .addToCart(times: 2)
    .goBack()
    .assertCart(contains: 2)
```

`typeSecret(_:into:)` registriert das Passwort, sodass es in Schrittnamen, Fehlermeldungen
und Berichten als `••••` maskiert wird.

### Tests lauffähig halten, wenn sich ein Identifier ändert

Ein `Locator` trägt den Identifier sowie das Label oder den Platzhalter, den ein Mensch sieht. Hier verwendet der Test
noch den Identifier von vor einem Redesign:

```swift
// "loginButton" was the identifier before the redesign; the app now uses "signIn.submit".
let button = app.element(Locator("loginButton", label: "Sign In", kind: .button), timeout: 1)
XCTAssertTrue(button.exists)
XCTAssertEqual(button.identifier, "signIn.submit")
```

Die geheilte Suche wird mit der Korrektur in `HealingLog` und im Markdown-Bericht protokolliert:
`Update the locator "loginButton" to "signIn.submit"`.

### Barrierefreiheit prüfen

```swift
app.on(SignInRobot.self).assertAccessible()
```

Jedes Problem wird zu einem Testfehler. Um die Probleme selbst zu untersuchen:

```swift
let issues = try app.accessibilityIssues()
let favoriteIssues = issues.filter { $0.element.identifier == "audit.favorite" }.map(\.rule)
XCTAssertEqual(Set(favoriteIssues), [.missingLabel, .smallTouchTarget])
```

### Screenshots vergleichen

`assertScreenshot(named:of:ignoring:)` vergleicht die App (oder ein Element) mit einem Referenz-PNG,
das neben der Testdatei in `__Snapshots__/` liegt, und lässt Elemente aus, die sich von selbst ändern:

```swift
catalog.assertScreenshot(named: "catalog", ignoring: [catalog.lastUpdated], comparator: comparator, store: store)
```

Der erste Lauf zeichnet die Referenz auf und schlägt fehl, damit eine fehlende Referenz nie unbemerkt durchgeht. Bei einer
Abweichung werden die Referenz, der tatsächliche Screenshot und das Differenzbild an den Testbericht angehängt.

### SwiftUI-View in einem Unit-Test als Snapshot erfassen

```swift
@Test @MainActor func signalBarsLookRight() throws {
    try assertSnapshot(of: SignalBars(level: 3), named: "signal-bars-3", size: CGSize(width: 44, height: 32))
}
```

`assertSnapshot` wirft einen Fehler, statt ein Problem zu melden, und funktioniert daher in Swift Testing und
XCTest gleich.

### Auf asynchronen Zustand warten und ein Fake prüfen

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

### Ergebnisse in CI berichten

Installiere den Collector einmal in deinem UI-Test-Bundle:

```swift
override class func setUp() {
    super.setUp()
    // Writes junit.xml and summary.md when TESTING_AUTOMATION_REPORT_DIR is set.
    TestResultCollector.install(reportName: "AutomationShowcase UI tests")
}
```

und gib den Berichtsordner an, wenn du die Tests ausführst:

```sh
TEST_RUNNER_TESTING_AUTOMATION_REPORT_DIR="$PWD/reports" xcodebuild test \
  -scheme AutomationShowcase -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
cat reports/summary.md >> "$GITHUB_STEP_SUMMARY"   # on GitHub Actions
```

So erstellst du einen Bericht aus eigenen Ergebnissen:

```swift
let report = TestReport(name: "Nightly", results: results)
let xml = report.junitXML()
```

## Demo

Die App [AutomationShowcase](Examples/AutomationShowcase) in einem iPhone-17-Pro-Simulator. Ihr
visueller Regressionstest blendet die Preise aus und vergleicht den Bildschirm mit der Referenz; das dritte
Bild ist das Differenzbild, das das Paket gezeichnet hat, mit jedem geänderten Pixel in Blau. Die Bilder
speichert dieser Test, und
[`scripts/generate-screenshots.sh`](scripts/generate-screenshots.sh) skaliert sie.

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/visual-diff-dark.png"><img src="docs/images/visual-diff-light.png" alt="Drei Handy-Screenshots nebeneinander: der Katalog mit Preisen, der Katalog mit ausgeblendeten Preisen und ein abgeblendetes Differenzbild, in dem nur die Preise und der Schalter blau hervorgehoben sind" width="840"></picture></p>

Um die UI-Tests selbst auszuführen, öffne `AutomationShowcase.xcodeproj` in
[`Examples/AutomationShowcase`](Examples/AutomationShowcase), wähle einen iPhone-Simulator und drücke
**⌘U**. [Examples/README.md](Examples/README.md) listet auf, was jeder Test zeigt.

## Dokumentation

API-Referenz und Artikel:

- [API-Referenz](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/)
  (DocC, von `main` auf GitHub Pages veröffentlicht)
- Baue sie lokal in Xcode mit **Product › Build Documentation** oder auf der Kommandozeile:

```sh
xcodebuild docbuild -scheme iOSTestingAutomationFramework -destination 'generic/platform=iOS Simulator'
```

## Anleitungen

- [Getting Started](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/gettingstarted)
  — das Paket zu Test-Targets hinzufügen, einen ersten Robot-Test und einen ersten Unit-Test schreiben
  ([Quelle](Sources/iOSTestingAutomationFramework/iOSTestingAutomationFramework.docc/GettingStarted.md)).
- [Writing UI Tests with Robots](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/writinguitestswithrobots)
  — Robot-Ketten, heilende Locators, Wartezeiten und die Barrierefreiheitsprüfung
  ([Quelle](Sources/iOSTestingAutomationFramework/iOSTestingAutomationFramework.docc/WritingUITestsWithRobots.md)).
- [Comparing Screenshots](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/comparingscreenshots)
  — SwiftUI-Snapshots, Screenshots aus UI-Tests, Toleranzen und Aufnahmemodi
  ([Quelle](Sources/iOSTestingAutomationFramework/iOSTestingAutomationFramework.docc/ComparingScreenshots.md)).
- [Reporting on CI](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/reportingonci)
  — JUnit XML, Jobzusammenfassungen, Maskierung und instabile Tests
  ([Quelle](Sources/iOSTestingAutomationFramework/iOSTestingAutomationFramework.docc/ReportingOnCI.md)).

## Voraussetzungen

| Plattform | Mindestversion        |
| --------- | --------------------- |
| iOS       | 17                    |
| macOS     | 14                    |
| Toolchain | Swift 6.2 · Xcode 26+ |

Die XCUITest-Helfer brauchen ein UI-Test-Target; die übrigen Helfer funktionieren in jedem Test-Target. CI baut
mit dem Standard-Xcode des `macos-26`-Runner-Images von GitHub. Das Paket wird mit
Xcode 27 entwickelt.

## Architektur

- `Sources/iOSTestingAutomationFramework/` hat pro Bereich einen Ordner: `Core`, `Reporting`,
  `Waiting`, `Resilience`, `Locators`, `Accessibility`, `Visual`, `Doubles`, `Fixtures`,
  `Performance` und `XCUI`.
- Alles außerhalb von `XCUI` ist reines Swift. Die Regeln (Heilung, Prüfung, Bildvergleich,
  Berichte, Maskierung) arbeiten mit Werten wie `ElementDescriptor` und `Bitmap`, sodass Unit-Tests
  sie ohne laufende App abdecken. `XCUI` ist eine dünne Schicht, die eine Momentaufnahme des Bildschirms
  in Deskriptoren umwandelt und Fehler über XCTest meldet.
- Das Paket importiert Swift Testing nicht: Xcode baut UI-Test-Bundles ohne verfügbares Swift Testing,
  eine Abhängigkeit davon würde also jedes UI-Test-Target brechen. Assertions für Unit-Tests
  werfen Fehler, die beide Frameworks als Fehlschlag melden.
- Eingaben von außerhalb des Tests sind begrenzt: Bildgrößen werden vor dem Dekodieren geprüft, Snapshot-Namen
  werden zu sicheren Dateinamen, NaN und unendliche Zahlen werden begrenzt statt konvertiert, und jede
  Liste, die mit der Eingabe wächst, hat ein Limit.
- CI führt `swift test` auf macOS und `xcodebuild test` auf einem iPhone-Simulator aus, baut für iOS und
  macOS, führt die UI-Tests der Beispiel-App aus und veröffentlicht die DocC-Dokumentation.

Tests lokal ausführen:

```sh
swift test                                    # macOS
xcodebuild test -scheme iOSTestingAutomationFramework \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
cd Examples/AutomationShowcase                # the UI tests
xcodebuild test -scheme AutomationShowcase \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

## Roadmap

- Text- und JSON-Snapshot-Strategien neben dem Bildvergleich.
- Eine wahrnehmungsbasierte Farbtoleranz für Screenshots, die auf verschiedenen Rechnern entstanden sind.
- Das Paket zum Swift Package Index hinzufügen; `.spi.yml` liegt bereits im Repository.

## Mitwirken

Beiträge sind willkommen. Lies vor einem Pull Request den [Leitfaden für Beiträge](https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/CONTRIBUTING.md) und den [Verhaltenskodex](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md). Sicherheitsprobleme meldest du vertraulich, wie in der [Sicherheitsrichtlinie](https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/SECURITY.md) beschrieben.

## Lizenz

Veröffentlicht unter der MIT-Lizenz. Siehe [LICENSE](LICENSE).
