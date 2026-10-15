<!-- i18n-source: README.md@e359efcbf2fd2cbac05fd38b031a929942168a20 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/banner-es-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/banner-es-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/banner-es-light.svg" alt="iOS Testing Automation: Robots, localizadores autorreparables, diferencias de capturas, accesibilidad e informes de CI para XCUITest."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/actions/workflows/ci.yml/badge.svg" alt="Estado de CI"></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-version-light.svg" alt="Última versión: v2.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-platforms-light.svg" alt="Plataformas compatibles: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-language-light.svg" alt="Versión del lenguaje: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-license-light.svg" alt="Licencia: MIT"></picture></a>
</p>

<p align="center">
<a href="#inicio-rápido"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-start-es-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-start-es-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-start-es-light.svg" alt="Empezar"></picture></a>
<a href="https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-docs-es-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-docs-es-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-docs-es-light.svg" alt="Documentación"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-examples-es-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-examples-es-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-examples-es-light.svg" alt="Ejemplos"></picture></a>
</p>

> Esta es una traducción del README en inglés. Si hay diferencias, la versión en inglés es la vigente.

<!-- brand:end -->

Un paquete de Swift para las pruebas de interfaz y las pruebas unitarias de apps de iOS y macOS. En XCUITest añade robots
(una clase por pantalla cuyos métodos esperan, registran un paso e informan de los fallos en tu línea), búsquedas
de elementos que siguen funcionando cuando cambia un identificador de accesibilidad, una auditoría de accesibilidad,
comparación de capturas con una imagen de diferencias e informes JUnit y Markdown para CI. En cualquier
prueba, con Swift Testing o XCTest, añade instantáneas de SwiftUI, esperas por sondeo, reintentos, spies y
datos de prueba con semilla. Está pensado para equipos cuyas pruebas de interfaz se rompen con cambios pequeños en la UI o son difíciles de leer
en un registro de CI. El paquete no tiene dependencias y se añade solo a tus targets de pruebas.

## Lo más destacado

- **Pruebas de interfaz legibles** — los robots convierten secuencias como `app.buttons["signIn.submit"].tap()` en
  `app.on(SignInRobot.self).signIn(email:password:)`. Cada paso espera hasta que su elemento se puede
  pulsar y aparece como un paso con nombre en el informe de pruebas de Xcode.
- **Localizadores que se autorreparan** — cuando se cambia el nombre de un identificador, la búsqueda encuentra el elemento por su
  etiqueta, su texto de marcador de posición o un identificador parecido, registra la corrección que hay que hacer y se niega a adivinar cuando dos
  elementos coinciden igual de bien.
- **Regresiones visuales que se ven** — las capturas y las vistas de SwiftUI se comparan con un
  PNG de referencia, con una tolerancia, regiones ignoradas (un reloj, una fecha) y una imagen de diferencias en
  la que cada píxel modificado aparece en azul.
- **Accesibilidad en cada ejecución** — una sola llamada revisa la pantalla en busca de controles sin etiqueta, áreas táctiles
  menores de 44 × 44 puntos, etiquetas que repiten el tipo de elemento e identificadores duplicados,
  y puede añadir `performAccessibilityAudit()` de Apple.
- **Salida lista para CI** — `junit.xml` y un resumen de trabajo en Markdown para cada paquete de pruebas, con las
  contraseñas y los tokens escritos ocultos, además de un análisis de pruebas inestables a lo largo de varias ejecuciones.
- **Reglas probadas** — la autorreparación, la auditoría, la comparación de imágenes, los informes y el enmascarado de datos
  son Swift puro y están cubiertos por 118 pruebas de Swift Testing en macOS y en un simulador de iPhone; 9 pruebas de interfaz
  de la [app de ejemplo](Examples/AutomationShowcase) ejecutan la capa de XCUITest de extremo a extremo en CI.

### Qué incluye

| Área                              | Tipos                                                                                                                                                                    |
| --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Pruebas de interfaz               | `Robot`, `Locator`, `LocatorHealer`, `HealingLog`, `XCUIElement.element(_:)`, `waitForHittable`, `waitForDisappearance`, `waitForLabel`, `waitForValue`, `descriptors()` |
| Accesibilidad                     | `AccessibilityAudit`, `Robot.assertAccessible()`, `XCUIElement.accessibilityIssues()`, `ContrastRatio`                                                                   |
| Imágenes                          | `assertSnapshot(of:)`, `Robot.assertScreenshot(named:)`, `SnapshotStore`, `ImageComparator`, `Bitmap`, `ViewRenderer`                                                    |
| Informes                          | `TestResultCollector`, `TestReport` (JUnit XML, Markdown), `TestResult`, `Redactor`, `FlakinessAnalyzer`                                                                 |
| Utilidades para pruebas unitarias | `Wait`, `RetryPolicy`, `Spy`, `ThrowingSpy`, `Fixtures`, `Benchmark`                                                                                                     |

## Inicio rápido

**1. Añade el paquete**

En Xcode, elige **File › Add Package Dependencies…** e introduce la URL del repositorio:

```text
https://github.com/muhittincamdali/iOS-Testing-Automation-Framework.git
```

Pégala en el campo de búsqueda de la parte superior derecha de la ventana. Deja **Dependency Rule** en
**Up to Next Major Version** desde `2.0.0` y haz clic en **Add Package**. En la ventana siguiente, elige
tu **target de pruebas de interfaz** junto a **iOSTestingAutomationFramework** (no el target de la app: el
paquete enlaza XCTest) y haz clic de nuevo en **Add Package**.

¿Todavía no tienes un target de pruebas de interfaz? Elige **File › New › Target… › UI Testing Bundle**.

**2. Importa el módulo**

```swift
import iOSTestingAutomationFramework
```

Pon esta línea al principio de tu archivo de pruebas de interfaz, debajo de `import XCTest`.

**3. Úsalo**

En una app nueva de Xcode (**File › New › Project… › App**, con **Include Tests** marcado), sustituye
todo el contenido de `ContentView.swift` por:

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

Después, sustituye el contenido del archivo de pruebas de interfaz (el que termina en `UITests.swift`) por:

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

Pulsa **⌘U**. La prueba abre la app en el simulador, pulsa el botón dos veces y pasa. En
el informe de pruebas, cada pulsación y la comprobación de la etiqueta aparecen como un paso propio.

## Instalación

### Swift Package Manager

En Xcode, elige **File › Add Package Dependencies…** e introduce la URL del repositorio:

```text
https://github.com/muhittincamdali/iOS-Testing-Automation-Framework.git
```

En un `Package.swift`, añade la dependencia y enumera el producto en tus targets de pruebas:

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

## Uso

Los ejemplos de pruebas de interfaz proceden de las [pruebas de interfaz de la app de ejemplo](Examples/AutomationShowcase/AutomationShowcaseUITests)
y los de pruebas unitarias de
[`ReadmeExamples.swift`](Tests/iOSTestingAutomationFrameworkTests/ReadmeExamples.swift); CI ejecuta
ambos.

### Escribe un robot para cada pantalla

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

Así, las pruebas se leen como los pasos de un caso de prueba:

```swift
app.on(SignInRobot.self)
    .signIn(email: "ada@example.com", password: "correct-horse-battery")
    .assertCart(contains: 0)
    .open("grinder")
    .addToCart(times: 2)
    .goBack()
    .assertCart(contains: 2)
```

`typeSecret(_:into:)` registra la contraseña, de modo que se oculta como `••••` en los nombres de los pasos, los mensajes de fallo
y los informes. Pega la contraseña en lugar de escribirla, porque XCTest registra el texto escrito
en sus propios pasos, adonde no llega ningún enmascarador. Después se vacía el portapapeles.

### Mantén las pruebas funcionando cuando cambia un identificador

Un `Locator` lleva el identificador junto con la etiqueta o el marcador de posición que ve una persona. Aquí la prueba
sigue usando el identificador anterior a un rediseño:

```swift
// "loginButton" was the identifier before the redesign; the app now uses "signIn.submit".
let button = app.element(Locator("loginButton", label: "Sign In", kind: .button), timeout: 1)
XCTAssertTrue(button.exists)
XCTAssertEqual(button.identifier, "signIn.submit")
```

La búsqueda autorreparada se registra en `HealingLog` y en el informe Markdown, junto con la corrección:
`Update the locator "loginButton" to "signIn.submit"`.

### Audita la accesibilidad

```swift
app.on(SignInRobot.self).assertAccessible()
```

Cada problema se convierte en un fallo de la prueba. Para inspeccionar los problemas tú mismo:

```swift
let issues = try app.accessibilityIssues()
let favoriteIssues = issues.filter { $0.element.identifier == "audit.favorite" }.map(\.rule)
XCTAssertEqual(Set(favoriteIssues), [.missingLabel, .smallTouchTarget])
```

### Compara capturas de pantalla

`assertScreenshot(named:of:ignoring:)` compara la app (o un elemento) con un PNG de referencia
guardado en `__Snapshots__/` junto al archivo de pruebas, dejando fuera los elementos que cambian por sí solos:

```swift
catalog.assertScreenshot(named: "catalog", ignoring: [catalog.lastUpdated], comparator: comparator, store: store)
```

La primera ejecución graba la referencia y falla, así que una referencia ausente nunca pasa en silencio. Si hay una
diferencia, la referencia, la captura real y la imagen de diferencias se adjuntan al informe de pruebas.

### Haz una instantánea de una vista de SwiftUI en una prueba unitaria

```swift
@Test @MainActor func signalBarsLookRight() throws {
    try assertSnapshot(of: SignalBars(level: 3), named: "signal-bars-3", size: CGSize(width: 44, height: 32))
}
```

`assertSnapshot` lanza un error en lugar de registrar un problema, así que funciona igual en Swift Testing y
en XCTest.

### Espera un estado asíncrono y comprueba un doble

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

### Informa de los resultados en CI

Instala el recolector una vez en tu paquete de pruebas de interfaz:

```swift
override class func setUp() {
    super.setUp()
    // Writes junit.xml and summary.md when TESTING_AUTOMATION_REPORT_DIR is set.
    TestResultCollector.install(reportName: "AutomationShowcase UI tests")
}
```

e indica la carpeta del informe cuando ejecutes las pruebas:

```sh
TEST_RUNNER_TESTING_AUTOMATION_REPORT_DIR="$PWD/reports" xcodebuild test \
  -scheme AutomationShowcase -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
cat reports/summary.md >> "$GITHUB_STEP_SUMMARY"   # on GitHub Actions
```

Para crear un informe a partir de tus propios resultados:

```swift
let report = TestReport(name: "Nightly", results: results)
let xml = report.junitXML()
```

## Demo

La app [AutomationShowcase](Examples/AutomationShowcase) en un simulador de iPhone 17 Pro. Su
prueba de regresión visual oculta los precios y compara la pantalla con la referencia; la tercera
imagen es la imagen de diferencias que dibujó el paquete, con cada píxel modificado en azul. Las imágenes
las guarda esa prueba y las escala
[`scripts/generate-screenshots.sh`](scripts/generate-screenshots.sh).

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/visual-diff-dark.png"><img src="docs/images/visual-diff-light.png" alt="Tres capturas de teléfono una al lado de otra: el catálogo con precios, el catálogo con los precios ocultos y una imagen de diferencias atenuada en la que solo los precios y el interruptor aparecen resaltados en azul" width="840"></picture></p>

Para ejecutar tú mismo las pruebas de interfaz, abre `AutomationShowcase.xcodeproj` en
[`Examples/AutomationShowcase`](Examples/AutomationShowcase), elige un simulador de iPhone y pulsa
**⌘U**. [Examples/README.md](Examples/README.md) enumera lo que muestra cada prueba.

## Documentación

Referencia de la API y artículos:

- [Referencia de la API](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/)
  (DocC, publicada en GitHub Pages desde `main`)
- Compílala en local en Xcode con **Product › Build Documentation**, o desde la línea de comandos:

```sh
xcodebuild docbuild -scheme iOSTestingAutomationFramework -destination 'generic/platform=iOS Simulator'
```

## Guías

- [Getting Started](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/gettingstarted)
  — añade el paquete a los targets de pruebas y escribe una primera prueba con robots y una primera prueba unitaria
  ([código fuente](Sources/iOSTestingAutomationFramework/iOSTestingAutomationFramework.docc/GettingStarted.md)).
- [Writing UI Tests with Robots](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/writinguitestswithrobots)
  — cadenas de robots, localizadores que se autorreparan, esperas y auditoría de accesibilidad
  ([código fuente](Sources/iOSTestingAutomationFramework/iOSTestingAutomationFramework.docc/WritingUITestsWithRobots.md)).
- [Comparing Screenshots](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/comparingscreenshots)
  — instantáneas de SwiftUI, capturas de pruebas de interfaz, tolerancias y modos de grabación
  ([código fuente](Sources/iOSTestingAutomationFramework/iOSTestingAutomationFramework.docc/ComparingScreenshots.md)).
- [Reporting on CI](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/reportingonci)
  — JUnit XML, resúmenes de trabajo, enmascarado de datos y pruebas inestables
  ([código fuente](Sources/iOSTestingAutomationFramework/iOSTestingAutomationFramework.docc/ReportingOnCI.md)).

## Requisitos

| Plataforma   | Versión mínima        |
| ------------ | --------------------- |
| iOS          | 17                    |
| macOS        | 14                    |
| Herramientas | Swift 6.2 · Xcode 26+ |

Las utilidades de XCUITest necesitan un target de pruebas de interfaz; las demás funcionan en cualquier target de pruebas. CI compila
con el Xcode predeterminado de la imagen de ejecución `macos-26` de GitHub. El paquete se desarrolla con
Xcode 27.

## Arquitectura

- `Sources/iOSTestingAutomationFramework/` tiene una carpeta por área: `Core`, `Reporting`,
  `Waiting`, `Resilience`, `Locators`, `Accessibility`, `Visual`, `Doubles`, `Fixtures`,
  `Performance` y `XCUI`.
- Todo lo que no está en `XCUI` es Swift puro. Las reglas (autorreparación, auditoría, comparación de imágenes,
  informes, enmascarado) trabajan con valores como `ElementDescriptor` y `Bitmap`, de modo que las pruebas unitarias
  las cubren sin una app en ejecución. `XCUI` es una capa fina que convierte una instantánea de la pantalla
  en descriptores e informa de los fallos a través de XCTest.
- El paquete no importa Swift Testing: Xcode compila los paquetes de pruebas de interfaz sin Swift Testing
  disponible, así que depender de él rompería todos los targets de pruebas de interfaz. Las aserciones pensadas para pruebas
  unitarias lanzan errores, y ambos frameworks los notifican como fallos.
- La entrada que viene de fuera de la prueba está acotada: los tamaños de imagen se comprueban antes de decodificar, los nombres
  de instantáneas se convierten en nombres de archivo seguros, los números NaN e infinitos se limitan en lugar de convertirse, y los
  espías, el registro de reparaciones, la auditoría y la búsqueda por distancia de edición tienen límites
  fijos. Los resultados de prueba recopilados y los secretos registrados se conservan completos durante la ejecución.
- CI ejecuta `swift test` en macOS y `xcodebuild test` en un simulador de iPhone, compila para iOS y
  macOS, ejecuta las pruebas de interfaz de la app de ejemplo y publica la documentación de DocC.

Ejecuta las pruebas en local:

```sh
swift test                                    # macOS
xcodebuild test -scheme iOSTestingAutomationFramework \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
cd Examples/AutomationShowcase                # the UI tests
xcodebuild test -scheme AutomationShowcase \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

## Hoja de ruta

- Estrategias de instantáneas de texto y JSON junto a la comparación de imágenes.
- Una tolerancia de color perceptual para capturas tomadas en máquinas distintas.
- Añadir el paquete al Swift Package Index; `.spi.yml` ya está en el repositorio.

## Contribuir

Las contribuciones son bienvenidas. Lee la [guía de contribución](https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/CONTRIBUTING.md) y el [código de conducta](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md) antes de abrir una pull request. Informa de los problemas de seguridad de forma privada, como se describe en la [política de seguridad](https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/SECURITY.md).

## Licencia

Publicado bajo la licencia MIT. Consulta [LICENSE](LICENSE).
