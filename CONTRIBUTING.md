# Contributing to iOS Testing Automation Framework

Thank you for your interest in contributing to iOS Testing Automation Framework! This document provides guidelines and information for contributors.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Code Style](#code-style)
- [Testing](#testing)
- [Pull Request Process](#pull-request-process)
- [Release Process](#release-process)

## Code of Conduct

This project and its participants are governed by our Code of Conduct. By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

- Use the GitHub issue tracker
- Include detailed reproduction steps
- Provide system information
- Include error logs and screenshots

### Suggesting Enhancements

- Use the GitHub issue tracker
- Describe the enhancement clearly
- Explain the use case
- Provide examples if possible

### Contributing Code

- Fork the repository
- Create a feature branch
- Make your changes
- Add tests for new functionality
- Update documentation
- Submit a pull request

## Development Setup

### Prerequisites

- Xcode 15.0 or later
- Swift 5.9 or later
- iOS 15.0+ SDK
- macOS 12.0+ for development

### Setup Steps

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/your-username/iOS-Testing-Automation-Framework.git
   ```

3. Open in Xcode:
   ```bash
   open iOS-Testing-Automation-Framework.xcodeproj
   ```

4. Build the project:
   ```bash
   swift build
   ```

5. Run tests:
   ```bash
   swift test
   ```

## Code Style

### Swift Guidelines

- Follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Use meaningful variable and function names
- Add comprehensive documentation
- Include unit tests for new features

### Documentation

- Use Swift documentation comments
- Include parameter descriptions
- Provide usage examples
- Update README.md for new features

### Testing

- Write unit tests for all new code
- Maintain 100% test coverage
- Include integration tests
- Add performance tests where appropriate

## Testing

### Running Tests

```bash
# Run all tests
swift test

# Run specific test target
swift test --filter TestCaseTests

# Run with performance monitoring
swift test --enable-performance-monitoring
```

### Test Coverage

- Maintain 100% test coverage
- Include edge cases
- Test error conditions
- Validate performance

## Pull Request Process

### Before Submitting

1. Ensure all tests pass
2. Update documentation
3. Add tests for new features
4. Follow code style guidelines
5. Update CHANGELOG.md

### Pull Request Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] All tests pass

## Documentation
- [ ] README updated
- [ ] API documentation updated
- [ ] CHANGELOG updated

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Tests added/updated
- [ ] Documentation updated
```

## Release Process

### Versioning

We follow [Semantic Versioning](https://semver.org/):
- MAJOR.MINOR.PATCH
- Breaking changes increment MAJOR
- New features increment MINOR
- Bug fixes increment PATCH

### Release Steps

1. Update version in Package.swift
2. Update CHANGELOG.md
3. Create release branch
4. Run full test suite
5. Create GitHub release
6. Tag release
7. Merge to main

## Contact

- GitHub Issues: [Create an issue](https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/issues)
- Discussions: [GitHub Discussions](https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/discussions)
- Email: support@muhittincamdali.com

## License

By contributing, you agree that your contributions will be licensed under the MIT License. 