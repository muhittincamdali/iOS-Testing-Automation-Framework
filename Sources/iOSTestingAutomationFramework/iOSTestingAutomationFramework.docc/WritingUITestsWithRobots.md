# Writing UI Tests with Robots

Keep UI tests readable and stable with robots, healing locators, waits and the accessibility audit.

## One robot per screen

A robot knows how to find the elements of one screen and what a person can do there. Tests
chain robot methods, and a method that moves to another screen returns that screen's robot
with ``Robot/on(_:)``:

```swift
final class CatalogRobot: Robot {
    var cartCount: XCUIElement { app.staticTexts["cart.count"] }

    func product(_ id: String) -> XCUIElement { app.buttons["product.\(id)"] }

    @discardableResult
    func open(_ id: String) -> ProductRobot {
        tap(product(id))
        return on(ProductRobot.self)
    }

    @discardableResult
    func assertCart(contains count: Int) -> Self {
        assertLabel(of: cartCount, equals: "Cart: \(count)")
    }
}
```

Every action (`tap`, `type`, `typeSecret`, `clearText`) waits until its element is hittable,
runs as a named XCTest activity, so the steps appear in Xcode's test report, and reports a
failure at the line of your test if the element never becomes usable. The assertions
(`assertExists`, `assertNotExists`, `assertLabel`, `assertValue`) wait up to
``Robot/defaultTimeout`` (5 seconds; override it in a subclass).

Group several actions under one name with ``Robot/step(_:_:)``.

## Locators that survive an identifier change

`app.element(_:)` takes a ``Locator``: the identifier you expect plus what a person would use
to find the element, such as its label or placeholder.

```swift
let submit = app.element(Locator("signIn.submit", label: "Sign In", kind: .button))
```

The lookup waits for the identifier first. If it does not appear, ``LocatorHealer`` looks at a
single snapshot of the screen and picks:

1. the one element showing the label (the interactive one when a title shows it too),
2. the one text field with the placeholder,
3. the element with the most similar identifier (`loginButton`, `login_button` and
   `auth.loginButton` are similar), if the similarity reaches 0.8.

When two elements match equally well, nothing is healed: the original query is returned and
the next action fails with XCTest's usual message. A test that taps the wrong element is worse
than a test that fails.

Every healed lookup is recorded in ``HealingLog`` with the change that removes the need for it,
and ``TestResultCollector`` adds the list to the Markdown summary:

```text
- `loginButton` was found by label: Update the locator "loginButton" to "signIn.submit",
  or rename the identifier of button "Sign In" (id: signIn.submit)
```

## Waiting without sleeping

Use the waits instead of `sleep`:

- `waitForHittable(timeout:)`: the element exists and can be tapped (not covered, not
  animating in).
- `waitForDisappearance(timeout:)`: a sheet or spinner is gone.
- `waitForLabel(_:timeout:)` and `waitForValue(_:timeout:)`.

They check the condition at once before polling, so a condition that already holds returns
immediately, and negative or NaN timeouts count as zero.

## Auditing accessibility

``Robot/assertAccessible(audit:ignoring:includingSystemAudit:fileID:filePath:line:column:)``
records one failure for every issue on the current screen:

```swift
app.on(SignInRobot.self).assertAccessible()
```

``AccessibilityAudit`` checks for controls and images without a label, touch targets smaller
than 44 × 44 points, labels that repeat the element kind ("Close button") and duplicate
identifiers. Elements inside a control (the switch inside a toggle, the chevron of a
navigation link) count as part of it, and controls in navigation bars, tab bars and toolbars
are not size-checked, because the system extends their hit area. Pass
`includingSystemAudit: true` to also run Apple's `performAccessibilityAudit()`, which checks
contrast, Dynamic Type and clipped text.

To check issues yourself, call `accessibilityIssues()` on any element:

```swift
let issues = try app.accessibilityIssues()
XCTAssertEqual(issues.map(\.rule), [.missingLabel, .smallTouchTarget])
```
