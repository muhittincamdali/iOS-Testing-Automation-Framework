<!-- i18n-source: README.md@f538d6e779afe3cd003645722b6571419027f952 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/banner-fr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/banner-fr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/banner-fr-light.svg" alt="iOS Testing Automation: Robots, localisateurs auto-réparés, écarts de captures, audits d’accessibilité et rapports CI pour XCUITest."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/actions/workflows/ci.yml/badge.svg" alt="État de la CI"></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-version-light.svg" alt="Dernière version: v2.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-platforms-light.svg" alt="Plateformes prises en charge: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-language-light.svg" alt="Version du langage: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-license-light.svg" alt="Licence: MIT"></picture></a>
</p>

<p align="center">
<a href="#démarrage-rapide"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-start-fr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-start-fr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-start-fr-light.svg" alt="Commencer"></picture></a>
<a href="https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-docs-fr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-docs-fr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-docs-fr-light.svg" alt="Documentation"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-examples-fr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-examples-fr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-examples-fr-light.svg" alt="Exemples"></picture></a>
</p>

> Ceci est une traduction du README anglais. En cas de différence, la version anglaise fait foi.

<!-- brand:end -->

Un paquet Swift pour les tests d’interface et les tests unitaires des apps iOS et macOS. Dans XCUITest, il ajoute des robots
(une classe par écran dont les méthodes attendent, consignent une étape et signalent les échecs à votre ligne), des recherches
d’éléments qui fonctionnent encore après le changement d’un identifiant d’accessibilité, un audit d’accessibilité,
une comparaison de captures avec une image de différences, et des rapports JUnit et Markdown pour la CI. Dans n’importe quel
test, Swift Testing ou XCTest, il ajoute des instantanés SwiftUI, des attentes par interrogation, des nouvelles tentatives, des spies et
des données de test à graine fixe. Il s’adresse aux équipes dont les tests d’interface cassent à la moindre modification de l’UI ou sont difficiles à lire
dans un journal de CI. Le paquet n’a aucune dépendance et s’ajoute uniquement à vos cibles de test.

## Points forts

- **Des tests d’interface lisibles** — les robots transforment des séquences comme `app.buttons["signIn.submit"].tap()` en
  `app.on(SignInRobot.self).signIn(email:password:)`. Chaque étape attend que son élément soit
  touchable et apparaît comme une étape nommée dans le rapport de test de Xcode.
- **Des localisateurs qui se réparent** — quand un identifiant est renommé, la recherche retrouve l’élément par son
  libellé, son texte indicatif ou un identifiant proche, consigne la correction à apporter et refuse de deviner quand deux
  éléments correspondent aussi bien l’un que l’autre.
- **Des régressions visuelles visibles** — les captures et les vues SwiftUI sont comparées à un
  PNG de référence, avec une tolérance, des zones ignorées (une horloge, une date) et une image de différences dans
  laquelle chaque pixel modifié est bleu.
- **L’accessibilité à chaque exécution** — un seul appel vérifie à l’écran la présence de contrôles sans libellé, de zones tactiles
  inférieures à 44 × 44 points, de libellés qui répètent le type d’élément et d’identifiants en double,
  et peut ajouter `performAccessibilityAudit()` d’Apple.
- **Des sorties prêtes pour la CI** — `junit.xml` et un résumé de tâche Markdown pour chaque bundle de test, avec les
  mots de passe et jetons saisis masqués, plus une analyse des tests instables sur plusieurs exécutions.
- **Des règles testées** — le réparateur, l’audit, la comparaison d’images, les rapports et le masquage
  sont du Swift pur, couverts par 118 tests Swift Testing sur macOS et sur un simulateur d’iPhone ; 9 tests d’interface
  de l’[app d’exemple](Examples/AutomationShowcase) exécutent la couche XCUITest de bout en bout en CI.

### Contenu

| Domaine                        | Types                                                                                                                                                                    |
| ------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Tests d’interface              | `Robot`, `Locator`, `LocatorHealer`, `HealingLog`, `XCUIElement.element(_:)`, `waitForHittable`, `waitForDisappearance`, `waitForLabel`, `waitForValue`, `descriptors()` |
| Accessibilité                  | `AccessibilityAudit`, `Robot.assertAccessible()`, `XCUIElement.accessibilityIssues()`, `ContrastRatio`                                                                   |
| Images                         | `assertSnapshot(of:)`, `Robot.assertScreenshot(named:)`, `SnapshotStore`, `ImageComparator`, `Bitmap`, `ViewRenderer`                                                    |
| Rapports                       | `TestResultCollector`, `TestReport` (JUnit XML, Markdown), `TestResult`, `Redactor`, `FlakinessAnalyzer`                                                                 |
| Aides pour les tests unitaires | `Wait`, `RetryPolicy`, `Spy`, `ThrowingSpy`, `Fixtures`, `Benchmark`                                                                                                     |

## Démarrage rapide

**1. Ajouter le paquet**

Dans Xcode, choisissez **File › Add Package Dependencies…** et saisissez l’URL du dépôt :

```text
https://github.com/muhittincamdali/iOS-Testing-Automation-Framework.git
```

Collez-la dans le champ de recherche en haut à droite de la fenêtre. Laissez **Dependency Rule** sur
**Up to Next Major Version** à partir de `2.0.0`, puis cliquez sur **Add Package**. Dans la fenêtre suivante, choisissez
votre **cible de tests d’interface** à côté de **iOSTestingAutomationFramework** (pas la cible de l’app : le
paquet lie XCTest) et cliquez de nouveau sur **Add Package**.

Pas encore de cible de tests d’interface ? Choisissez **File › New › Target… › UI Testing Bundle**.

**2. Importer le module**

```swift
import iOSTestingAutomationFramework
```

Placez cette ligne en haut de votre fichier de tests d’interface, sous `import XCTest`.

**3. L’utiliser**

Dans une nouvelle app Xcode (**File › New › Project… › App**, avec **Include Tests** coché), remplacez
tout le contenu de `ContentView.swift` par :

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

Remplacez ensuite le contenu du fichier de tests d’interface (celui qui se termine par `UITests.swift`) par :

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

Appuyez sur **⌘U**. Le test lance l’app dans le simulateur, touche deux fois le bouton et réussit. Dans
le rapport de test, chaque toucher et la vérification du libellé apparaissent comme une étape distincte.

## Installation

### Swift Package Manager

Dans Xcode, choisissez **File › Add Package Dependencies…** et saisissez l’URL du dépôt :

```text
https://github.com/muhittincamdali/iOS-Testing-Automation-Framework.git
```

Dans un `Package.swift`, ajoutez la dépendance et indiquez le produit dans vos cibles de test :

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

## Utilisation

Les exemples de tests d’interface viennent des [tests d’interface de l’app d’exemple](Examples/AutomationShowcase/AutomationShowcaseUITests)
et ceux de tests unitaires de
[`ReadmeExamples.swift`](Tests/iOSTestingAutomationFrameworkTests/ReadmeExamples.swift) ; la CI exécute
les deux.

### Écrire un robot pour chaque écran

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

Les tests se lisent alors comme les étapes d’un cas de test :

```swift
app.on(SignInRobot.self)
    .signIn(email: "ada@example.com", password: "correct-horse-battery")
    .assertCart(contains: 0)
    .open("grinder")
    .addToCart(times: 2)
    .goBack()
    .assertCart(contains: 2)
```

`typeSecret(_:into:)` enregistre le mot de passe, qui est donc masqué sous la forme `••••` dans les noms d’étapes, les messages d’échec
et les rapports. Il colle le mot de passe au lieu de le saisir, car XCTest consigne le texte saisi
dans ses propres étapes, qu’aucun masquage n’atteint. Le presse-papiers est vidé ensuite.

### Garder les tests fonctionnels quand un identifiant change

Un `Locator` porte l’identifiant ainsi que le libellé ou le texte indicatif qu’une personne voit. Ici, le test
utilise encore l’identifiant d’avant une refonte :

```swift
// "loginButton" was the identifier before the redesign; the app now uses "signIn.submit".
let button = app.element(Locator("loginButton", label: "Sign In", kind: .button), timeout: 1)
XCTAssertTrue(button.exists)
XCTAssertEqual(button.identifier, "signIn.submit")
```

La recherche réparée est consignée dans `HealingLog` et dans le rapport Markdown, avec la correction :
`Update the locator "loginButton" to "signIn.submit"`.

### Auditer l’accessibilité

```swift
app.on(SignInRobot.self).assertAccessible()
```

Chaque problème devient un échec de test. Pour examiner vous-même les problèmes :

```swift
let issues = try app.accessibilityIssues()
let favoriteIssues = issues.filter { $0.element.identifier == "audit.favorite" }.map(\.rule)
XCTAssertEqual(Set(favoriteIssues), [.missingLabel, .smallTouchTarget])
```

### Comparer des captures d’écran

`assertScreenshot(named:of:ignoring:)` compare l’app (ou un élément) à un PNG de référence
stocké dans `__Snapshots__/` à côté du fichier de test, en écartant les éléments qui changent d’eux-mêmes :

```swift
catalog.assertScreenshot(named: "catalog", ignoring: [catalog.lastUpdated], comparator: comparator, store: store)
```

La première exécution enregistre la référence et échoue, si bien qu’une référence manquante ne passe jamais en silence. En cas de
différence, la référence, la capture réelle et l’image de différences sont jointes au rapport de test.

### Prendre l’instantané d’une vue SwiftUI dans un test unitaire

```swift
@Test @MainActor func signalBarsLookRight() throws {
    try assertSnapshot(of: SignalBars(level: 3), named: "signal-bars-3", size: CGSize(width: 44, height: 32))
}
```

`assertSnapshot` lève une erreur au lieu d’enregistrer un problème, il fonctionne donc de la même façon dans Swift Testing et
dans XCTest.

### Attendre un état asynchrone et vérifier un faux

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

### Rapporter les résultats en CI

Installez le collecteur une seule fois dans votre bundle de tests d’interface :

```swift
override class func setUp() {
    super.setUp()
    // Writes junit.xml and summary.md when TESTING_AUTOMATION_REPORT_DIR is set.
    TestResultCollector.install(reportName: "AutomationShowcase UI tests")
}
```

et indiquez le dossier du rapport quand vous lancez les tests :

```sh
TEST_RUNNER_TESTING_AUTOMATION_REPORT_DIR="$PWD/reports" xcodebuild test \
  -scheme AutomationShowcase -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
cat reports/summary.md >> "$GITHUB_STEP_SUMMARY"   # on GitHub Actions
```

Pour construire un rapport à partir de vos propres résultats :

```swift
let report = TestReport(name: "Nightly", results: results)
let xml = report.junitXML()
```

## Démo

L’app [AutomationShowcase](Examples/AutomationShowcase) sur un simulateur d’iPhone 17 Pro. Son
test de régression visuelle masque les prix et compare l’écran à la référence ; la troisième
image est l’image de différences dessinée par le paquet, avec chaque pixel modifié en bleu. Les images
sont enregistrées par ce test et redimensionnées par
[`scripts/generate-screenshots.sh`](scripts/generate-screenshots.sh).

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/visual-diff-dark.png"><img src="docs/images/visual-diff-light.png" alt="Trois captures de téléphone côte à côte : le catalogue avec les prix, le catalogue sans les prix et une image de différences atténuée où seuls les prix et le commutateur sont surlignés en bleu" width="840"></picture></p>

Pour lancer vous-même les tests d’interface, ouvrez `AutomationShowcase.xcodeproj` dans
[`Examples/AutomationShowcase`](Examples/AutomationShowcase), choisissez un simulateur d’iPhone et appuyez sur
**⌘U**. [Examples/README.md](Examples/README.md) indique ce que montre chaque test.

## Documentation

Référence de l’API et articles :

- [Référence de l’API](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/)
  (DocC, publiée sur GitHub Pages depuis `main`)
- Générez-la en local dans Xcode avec **Product › Build Documentation**, ou en ligne de commande :

```sh
xcodebuild docbuild -scheme iOSTestingAutomationFramework -destination 'generic/platform=iOS Simulator'
```

## Guides

- [Getting Started](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/gettingstarted)
  — ajouter le paquet aux cibles de test, écrire un premier test avec un robot et un premier test unitaire
  ([source](Sources/iOSTestingAutomationFramework/iOSTestingAutomationFramework.docc/GettingStarted.md)).
- [Writing UI Tests with Robots](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/writinguitestswithrobots)
  — chaînes de robots, localisateurs qui se réparent, attentes et audit d’accessibilité
  ([source](Sources/iOSTestingAutomationFramework/iOSTestingAutomationFramework.docc/WritingUITestsWithRobots.md)).
- [Comparing Screenshots](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/comparingscreenshots)
  — instantanés SwiftUI, captures des tests d’interface, tolérances et modes d’enregistrement
  ([source](Sources/iOSTestingAutomationFramework/iOSTestingAutomationFramework.docc/ComparingScreenshots.md)).
- [Reporting on CI](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/reportingonci)
  — JUnit XML, résumés de tâche, masquage et tests instables
  ([source](Sources/iOSTestingAutomationFramework/iOSTestingAutomationFramework.docc/ReportingOnCI.md)).

## Prérequis

| Plateforme      | Version minimale      |
| --------------- | --------------------- |
| iOS             | 17                    |
| macOS           | 14                    |
| Chaîne d’outils | Swift 6.2 · Xcode 26+ |

Les aides XCUITest nécessitent une cible de tests d’interface ; les autres fonctionnent dans n’importe quelle cible de test. La CI compile
avec le Xcode par défaut de l’image de runner `macos-26` de GitHub. Le paquet est développé avec
Xcode 27.

## Architecture

- `Sources/iOSTestingAutomationFramework/` contient un dossier par domaine : `Core`, `Reporting`,
  `Waiting`, `Resilience`, `Locators`, `Accessibility`, `Visual`, `Doubles`, `Fixtures`,
  `Performance` et `XCUI`.
- Tout ce qui est hors de `XCUI` est du Swift pur. Les règles (réparation, audit, comparaison d’images,
  rapports, masquage) travaillent sur des valeurs comme `ElementDescriptor` et `Bitmap`, si bien que les tests unitaires
  les couvrent sans app en cours d’exécution. `XCUI` est une couche mince qui transforme un instantané de l’écran
  en descripteurs et signale les échecs via XCTest.
- Le paquet n’importe pas Swift Testing : Xcode compile les bundles de tests d’interface sans Swift Testing
  disponible, donc en dépendre casserait toutes les cibles de tests d’interface. Les assertions destinées aux tests
  unitaires lèvent des erreurs, que les deux frameworks signalent comme un échec.
- Les entrées venant de l’extérieur du test sont bornées : les tailles d’image sont vérifiées avant le décodage, les noms
  d’instantanés deviennent des noms de fichier sûrs, les nombres NaN et infinis sont bornés au lieu d’être convertis, et les
  espions, le journal de réparation, l’audit et la recherche par distance d’édition ont des limites fixes.
  Les résultats de test collectés et les secrets enregistrés sont conservés en entier pendant toute l’exécution.
- La CI exécute `swift test` sur macOS et `xcodebuild test` sur un simulateur d’iPhone, compile pour iOS et
  macOS, lance les tests d’interface de l’app d’exemple et publie la documentation DocC.

Lancez les tests en local :

```sh
swift test                                    # macOS
xcodebuild test -scheme iOSTestingAutomationFramework \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
cd Examples/AutomationShowcase                # the UI tests
xcodebuild test -scheme AutomationShowcase \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

## Feuille de route

- Des stratégies d’instantanés de texte et de JSON à côté de la comparaison d’images.
- Une tolérance de couleur perceptuelle pour les captures prises sur des machines différentes.
- Ajouter le paquet au Swift Package Index ; `.spi.yml` est déjà dans le dépôt.

## Contribuer

Les contributions sont les bienvenues. Lisez le [guide de contribution](https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/CONTRIBUTING.md) et le [code de conduite](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md) avant d’ouvrir une pull request. Signalez les problèmes de sécurité en privé, comme indiqué dans la [politique de sécurité](https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/SECURITY.md).

## Licence

Publié sous licence MIT. Voir [LICENSE](LICENSE).
