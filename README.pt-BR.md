<!-- i18n-source: README.md@96afd867c60fbff34acfc396cf2b8d69f0d0f58f status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/banner-pt-BR-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/banner-pt-BR-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/banner-pt-BR-light.svg" alt="iOS Testing Automation: Robots, localizadores que se corrigem, diferenças de capturas, acessibilidade e relatórios de CI para XCUITest."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/actions/workflows/ci.yml/badge.svg" alt="Status da CI"></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-version-light.svg" alt="Versão mais recente: v1.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-platforms-light.svg" alt="Plataformas compatíveis: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-language-light.svg" alt="Versão da linguagem: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-license-light.svg" alt="Licença: MIT"></picture></a>
</p>

<p align="center">
<a href="#início-rápido"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-start-pt-BR-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-start-pt-BR-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-start-pt-BR-light.svg" alt="Começar"></picture></a>
<a href="https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-docs-pt-BR-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-docs-pt-BR-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-docs-pt-BR-light.svg" alt="Documentação"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-examples-pt-BR-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-examples-pt-BR-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-examples-pt-BR-light.svg" alt="Exemplos"></picture></a>
</p>

> Esta é uma tradução do README em inglês. Se houver diferença, vale a versão em inglês.

<!-- brand:end -->

Um pacote Swift para testes de interface e testes unitários de apps iOS e macOS. No XCUITest, ele adiciona robots
(uma classe por tela cujos métodos esperam, registram um passo e relatam falhas na sua linha), buscas de
elementos que continuam funcionando depois que um identificador de acessibilidade muda, uma auditoria de acessibilidade,
comparação de capturas com uma imagem de diferenças e relatórios JUnit e Markdown para CI. Em qualquer
teste, com Swift Testing ou XCTest, ele adiciona snapshots de SwiftUI, esperas por polling, novas tentativas, spies e
dados de teste com semente fixa. É para equipes cujos testes de interface quebram com pequenas mudanças na UI ou são difíceis de ler
em um log de CI. O pacote não tem dependências e vai apenas nos seus targets de teste.

## Destaques

- **Testes de interface legíveis** — os robots transformam sequências como `app.buttons["signIn.submit"].tap()` em
  `app.on(SignInRobot.self).signIn(email:password:)`. Cada passo espera até que seu elemento possa ser
  tocado e aparece como um passo nomeado no relatório de testes do Xcode.
- **Localizadores que se corrigem** — quando um identificador é renomeado, a busca encontra o elemento pelo
  rótulo, pelo placeholder ou por um identificador parecido, registra a correção a fazer e se recusa a adivinhar quando dois
  elementos correspondem igualmente bem.
- **Regressões visuais que você enxerga** — capturas e views SwiftUI são comparadas com um
  PNG de referência, com tolerância, regiões ignoradas (um relógio, uma data) e uma imagem de diferenças em
  que cada pixel alterado fica azul.
- **Acessibilidade em toda execução** — uma única chamada verifica a tela em busca de controles sem rótulo, alvos de toque
  menores que 44 × 44 pontos, rótulos que repetem o tipo do elemento e identificadores duplicados,
  e pode incluir o `performAccessibilityAudit()` da Apple.
- **Saída pronta para CI** — `junit.xml` e um resumo de job em Markdown para cada bundle de testes, com senhas
  e tokens digitados mascarados, além de uma análise de testes instáveis ao longo de várias execuções.
- **Regras testadas** — a correção automática, a auditoria, a comparação de imagens, os relatórios e o mascaramento de dados
  são Swift puro, cobertos por 112 testes de Swift Testing no macOS e em um simulador de iPhone; 9 testes de interface
  no [app de exemplo](Examples/AutomationShowcase) executam a camada XCUITest de ponta a ponta no CI.

### O que está incluído

| Área                              | Tipos                                                                                                                                                                    |
| --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Testes de interface               | `Robot`, `Locator`, `LocatorHealer`, `HealingLog`, `XCUIElement.element(_:)`, `waitForHittable`, `waitForDisappearance`, `waitForLabel`, `waitForValue`, `descriptors()` |
| Acessibilidade                    | `AccessibilityAudit`, `Robot.assertAccessible()`, `XCUIElement.accessibilityIssues()`, `ContrastRatio`                                                                   |
| Imagens                           | `assertSnapshot(of:)`, `Robot.assertScreenshot(named:)`, `SnapshotStore`, `ImageComparator`, `Bitmap`, `ViewRenderer`                                                    |
| Relatórios                        | `TestResultCollector`, `TestReport` (JUnit XML, Markdown), `TestResult`, `Redactor`, `FlakinessAnalyzer`                                                                 |
| Utilitários para testes unitários | `Wait`, `RetryPolicy`, `Spy`, `ThrowingSpy`, `Fixtures`, `Benchmark`                                                                                                     |

## Início rápido

**1. Adicione o pacote**

No Xcode, escolha **File › Add Package Dependencies…** e informe a URL do repositório:

```text
https://github.com/muhittincamdali/iOS-Testing-Automation-Framework.git
```

Cole-a no campo de busca no canto superior direito da janela. Deixe **Dependency Rule** em
**Up to Next Major Version** a partir de `2.0.0` e clique em **Add Package**. Na janela seguinte, escolha
o seu **target de testes de interface** ao lado de **iOSTestingAutomationFramework** (não o target do app: o
pacote vincula o XCTest) e clique em **Add Package** novamente.

Ainda não tem um target de testes de interface? Escolha **File › New › Target… › UI Testing Bundle**.

**2. Importe o módulo**

```swift
import iOSTestingAutomationFramework
```

Coloque esta linha no topo do seu arquivo de testes de interface, abaixo de `import XCTest`.

**3. Use**

Em um app novo do Xcode (**File › New › Project… › App**, com **Include Tests** marcado), substitua
todo o conteúdo de `ContentView.swift` por:

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

Depois, substitua o conteúdo do arquivo de testes de interface (o que termina em `UITests.swift`) por:

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

Pressione **⌘U**. O teste abre o app no simulador, toca no botão duas vezes e passa. No
relatório de testes, cada toque e a verificação do rótulo aparecem como um passo próprio.

## Instalação

### Swift Package Manager

No Xcode, escolha **File › Add Package Dependencies…** e informe a URL do repositório:

```text
https://github.com/muhittincamdali/iOS-Testing-Automation-Framework.git
```

Em um `Package.swift`, adicione a dependência e liste o produto nos seus targets de teste:

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

Os exemplos de testes de interface vêm dos [testes de interface do app de exemplo](Examples/AutomationShowcase/AutomationShowcaseUITests)
e os de testes unitários de
[`ReadmeExamples.swift`](Tests/iOSTestingAutomationFrameworkTests/ReadmeExamples.swift); o CI executa
ambos.

### Escreva um robot para cada tela

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

Os testes então se leem como os passos de um caso de teste:

```swift
app.on(SignInRobot.self)
    .signIn(email: "ada@example.com", password: "correct-horse-battery")
    .assertCart(contains: 0)
    .open("grinder")
    .addToCart(times: 2)
    .goBack()
    .assertCart(contains: 2)
```

`typeSecret(_:into:)` registra a senha, que por isso é mascarada como `••••` nos nomes dos passos, nas mensagens de falha
e nos relatórios.

### Mantenha os testes funcionando quando um identificador muda

Um `Locator` leva o identificador junto com o rótulo ou o placeholder que uma pessoa vê. Aqui o teste
ainda usa o identificador de antes de um redesign:

```swift
// "loginButton" was the identifier before the redesign; the app now uses "signIn.submit".
let button = app.element(Locator("loginButton", label: "Sign In", kind: .button), timeout: 1)
XCTAssertTrue(button.exists)
XCTAssertEqual(button.identifier, "signIn.submit")
```

A busca corrigida é registrada no `HealingLog` e no relatório em Markdown, com a correção:
`Update the locator "loginButton" to "signIn.submit"`.

### Audite a acessibilidade

```swift
app.on(SignInRobot.self).assertAccessible()
```

Cada problema vira uma falha de teste. Para inspecionar os problemas você mesmo:

```swift
let issues = try app.accessibilityIssues()
let favoriteIssues = issues.filter { $0.element.identifier == "audit.favorite" }.map(\.rule)
XCTAssertEqual(Set(favoriteIssues), [.missingLabel, .smallTouchTarget])
```

### Compare capturas de tela

`assertScreenshot(named:of:ignoring:)` compara o app (ou um elemento) com um PNG de referência
guardado em `__Snapshots__/`, ao lado do arquivo de teste, deixando de fora os elementos que mudam sozinhos:

```swift
catalog.assertScreenshot(named: "catalog", ignoring: [catalog.lastUpdated], comparator: comparator, store: store)
```

A primeira execução grava a referência e falha, para que uma referência ausente nunca passe em silêncio. Em caso de
divergência, a referência, a captura real e a imagem de diferenças são anexadas ao relatório de testes.

### Faça o snapshot de uma view SwiftUI em um teste unitário

```swift
@Test @MainActor func signalBarsLookRight() throws {
    try assertSnapshot(of: SignalBars(level: 3), named: "signal-bars-3", size: CGSize(width: 44, height: 32))
}
```

`assertSnapshot` lança um erro em vez de registrar um problema, então funciona do mesmo jeito no Swift Testing e
no XCTest.

### Espere um estado assíncrono e verifique um fake

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

### Relate os resultados no CI

Instale o coletor uma vez no seu bundle de testes de interface:

```swift
override class func setUp() {
    super.setUp()
    // Writes junit.xml and summary.md when TESTING_AUTOMATION_REPORT_DIR is set.
    TestResultCollector.install(reportName: "AutomationShowcase UI tests")
}
```

e informe a pasta do relatório ao executar os testes:

```sh
TEST_RUNNER_TESTING_AUTOMATION_REPORT_DIR="$PWD/reports" xcodebuild test \
  -scheme AutomationShowcase -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
cat reports/summary.md >> "$GITHUB_STEP_SUMMARY"   # on GitHub Actions
```

Para montar um relatório a partir dos seus próprios resultados:

```swift
let report = TestReport(name: "Nightly", results: results)
let xml = report.junitXML()
```

## Demonstração

O app [AutomationShowcase](Examples/AutomationShowcase) em um simulador de iPhone 17 Pro. O teste de
regressão visual dele esconde os preços e compara a tela com a referência; a terceira
imagem é a imagem de diferenças desenhada pelo pacote, com cada pixel alterado em azul. As imagens
são salvas por esse teste e redimensionadas por
[`scripts/generate-screenshots.sh`](scripts/generate-screenshots.sh).

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/visual-diff-dark.png"><img src="docs/images/visual-diff-light.png" alt="Três capturas de tela de celular lado a lado: o catálogo com preços, o catálogo com os preços ocultos e uma imagem de diferenças esmaecida em que apenas os preços e o interruptor aparecem destacados em azul" width="840"></picture></p>

Para executar os testes de interface você mesmo, abra `AutomationShowcase.xcodeproj` em
[`Examples/AutomationShowcase`](Examples/AutomationShowcase), escolha um simulador de iPhone e pressione
**⌘U**. [Examples/README.md](Examples/README.md) lista o que cada teste mostra.

## Documentação

Referência da API e artigos:

- [Referência da API](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/)
  (DocC, publicada no GitHub Pages a partir de `main`)
- Gere-a localmente no Xcode com **Product › Build Documentation**, ou pela linha de comando:

```sh
xcodebuild docbuild -scheme iOSTestingAutomationFramework -destination 'generic/platform=iOS Simulator'
```

## Guias

- [Getting Started](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/gettingstarted)
  — adicione o pacote aos targets de teste, escreva um primeiro teste com robot e um primeiro teste unitário
  ([código-fonte](Sources/iOSTestingAutomationFramework/iOSTestingAutomationFramework.docc/GettingStarted.md)).
- [Writing UI Tests with Robots](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/writinguitestswithrobots)
  — encadeamento de robots, localizadores que se corrigem, esperas e a auditoria de acessibilidade
  ([código-fonte](Sources/iOSTestingAutomationFramework/iOSTestingAutomationFramework.docc/WritingUITestsWithRobots.md)).
- [Comparing Screenshots](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/comparingscreenshots)
  — snapshots de SwiftUI, capturas de testes de interface, tolerâncias e modos de gravação
  ([código-fonte](Sources/iOSTestingAutomationFramework/iOSTestingAutomationFramework.docc/ComparingScreenshots.md)).
- [Reporting on CI](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/reportingonci)
  — JUnit XML, resumos de job, mascaramento de dados e testes instáveis
  ([código-fonte](Sources/iOSTestingAutomationFramework/iOSTestingAutomationFramework.docc/ReportingOnCI.md)).

## Requisitos

| Plataforma  | Versão mínima         |
| ----------- | --------------------- |
| iOS         | 17                    |
| macOS       | 14                    |
| Ferramentas | Swift 6.2 · Xcode 26+ |

Os utilitários de XCUITest precisam de um target de testes de interface; os demais funcionam em qualquer target de teste. O CI compila
com o Xcode padrão da imagem de runner `macos-26` do GitHub. O pacote é desenvolvido com
o Xcode 27.

## Arquitetura

- `Sources/iOSTestingAutomationFramework/` tem uma pasta por área: `Core`, `Reporting`,
  `Waiting`, `Resilience`, `Locators`, `Accessibility`, `Visual`, `Doubles`, `Fixtures`,
  `Performance` e `XCUI`.
- Tudo fora de `XCUI` é Swift puro. As regras (correção automática, auditoria, comparação de imagens,
  relatórios, mascaramento) trabalham com valores como `ElementDescriptor` e `Bitmap`, então os testes unitários
  as cobrem sem um app em execução. `XCUI` é uma camada fina que transforma um instantâneo da tela
  em descritores e relata falhas pelo XCTest.
- O pacote não importa o Swift Testing: o Xcode compila bundles de testes de interface sem o Swift Testing
  disponível, então depender dele quebraria todos os targets de testes de interface. As asserções pensadas para testes
  unitários lançam erros, que ambos os frameworks relatam como falha.
- A entrada vinda de fora do teste é limitada: os tamanhos de imagem são verificados antes da decodificação, os nomes
  de snapshots viram nomes de arquivo seguros, números NaN e infinitos são limitados em vez de convertidos, e toda
  lista que cresce com a entrada tem um limite.
- O CI executa `swift test` no macOS e `xcodebuild test` em um simulador de iPhone, compila para iOS e
  macOS, executa os testes de interface do app de exemplo e publica a documentação DocC.

Execute os testes localmente:

```sh
swift test                                    # macOS
xcodebuild test -scheme iOSTestingAutomationFramework \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
cd Examples/AutomationShowcase                # the UI tests
xcodebuild test -scheme AutomationShowcase \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

## Roteiro

- Estratégias de snapshot de texto e JSON ao lado da comparação de imagens.
- Uma tolerância de cor perceptual para capturas feitas em máquinas diferentes.
- Adicionar o pacote ao Swift Package Index; o `.spi.yml` já está no repositório.

## Como contribuir

Contribuições são bem-vindas. Leia o [guia de contribuição](https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/CONTRIBUTING.md) e o [código de conduta](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md) antes de abrir um pull request. Relate problemas de segurança de forma privada, como descrito na [política de segurança](https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/SECURITY.md).

## Licença

Publicado sob a licença MIT. Veja [LICENSE](LICENSE).
