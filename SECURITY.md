# Security policy

## Supported versions

Security fixes are made for the latest release. Version 1.0.0 is a different, unmaintained code
base and does not receive fixes.

## What counts as a vulnerability

The package runs inside test processes on developer machines and CI servers. It reads input it
does not control (PNG baselines from the repository, snapshot names, element trees of the app
under test, stored test results) and writes reports that are often uploaded as CI artifacts.
Please report privately anything that makes it:

- leak a secret: a password typed with `typeSecret(_:into:)`, a value registered with
  `TestingAutomation.registerSecret(_:)` or a credential that `Redactor` documents that it
  masks, into an activity name, a failure message, `junit.xml` or `summary.md`;
- write outside the folder it was given, for example through a snapshot name;
- crash (a trap, an out-of-range index, an integer overflow) instead of throwing or clamping;
- run for a very long time or allocate memory out of proportion to its input, for example a
  small PNG that declares a huge size;
- produce a JUnit file that does not parse, or Markdown whose table a message can break.

## Reporting a vulnerability

Please report vulnerabilities privately, not in a public issue, pull request or discussion.

1. **Preferred:** open the repository's **Security** tab and choose
   **Report a vulnerability** ([how private reporting works](https://docs.github.com/en/code-security/how-tos/report-and-fix-vulnerabilities/report-privately)).
2. **Or** email [muhittincamdali@gmail.com](mailto:muhittincamdali@gmail.com) with
   "Security" in the subject.

Include the version (tag or commit), the platform and Xcode version, the input that triggers the
problem and what happens.

## What happens next

You get an answer within a week. Confirmed problems are fixed in a release, with a test that
reproduces them and a note in the changelog; you are credited unless you ask not to be.
