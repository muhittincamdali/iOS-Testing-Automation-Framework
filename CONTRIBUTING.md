# Contributing

Thanks for taking the time to improve iOS Testing Automation Framework.

## Reporting bugs

Open an issue with:

- the type and method you used, and the arguments,
- what you expected and what happened, including the failure message,
- for UI tests: the element tree around the problem (`print(app.debugDescription)`) or the
  output of `try app.descriptors()`,
- platform, OS version and Xcode version, and whether it ran on a device or a simulator.

Do not paste real passwords or tokens from test accounts. Security problems go through the
[security policy](SECURITY.md), not an issue.

## Pull requests

1. Fork the repository and branch from `main`.
2. Keep each pull request focused on one change.
3. Run the tests on macOS, on an iOS simulator, and the example app's UI tests:

    ```sh
    swift test
    xcodebuild test -scheme iOSTestingAutomationFramework -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
    cd Examples/AutomationShowcase
    xcodebuild test -scheme AutomationShowcase -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
    ```

4. Add a test for every change in behaviour in `Tests/iOSTestingAutomationFrameworkTests`.
   Put the rule in a plain-Swift type that the unit tests can reach (as `LocatorHealer`,
   `AccessibilityAudit` and `ImageComparator` do) and keep the XCUITest layer thin. Cover
   invalid and hostile input, not only the happy path: empty and oversized values, `NaN`,
   infinite and negative numbers, `Int.min` and `Int.max`, sizes whose product overflows,
   Unicode tricks (combining marks, full-width digits) and file names such as `../../x`.
5. Public functions keep their input in range or throw a typed error; they do not crash.
   Every loop and allocation whose size depends on input is bounded. Text that can reach a
   report or a log goes through `TestingAutomation.redactor`.
6. Do not import Swift Testing in the package: UI test bundles cannot load it. Assertions for
   unit tests throw; robot assertions call XCTFail.
7. If you change a README code sample, change its source as well:
   `Tests/iOSTestingAutomationFrameworkTests/ReadmeExamples.swift` for unit-test samples, the
   files in `Examples/AutomationShowcase/AutomationShowcaseUITests` for UI-test samples.
8. If a change affects the example app's screens or the difference image, regenerate the
   README images with `scripts/generate-screenshots.sh`.

## Code style

- Follow the [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/).
- The package builds in the Swift 6 language mode; new code should not add warnings, and
  `xcodebuild docbuild` should stay free of documentation warnings.
- Document public API with DocC comments (`///`), including every parameter.
- Commit messages follow [Conventional Commits](https://www.conventionalcommits.org/)
  (`feat:`, `fix:`, `docs:`, `test:`, `refactor:`, `ci:`, `chore:`).
