// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iOSTestingAutomationFramework",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .watchOS(.v8),
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "iOSTestingAutomationFramework",
            targets: ["iOSTestingAutomationFramework"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "iOSTestingAutomationFramework",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
            ],
            path: "Sources"),
        
        .testTarget(
            name: "iOSTestingAutomationFrameworkTests",
            dependencies: ["iOSTestingAutomationFramework"],
            path: "Tests/FrameworkTests"),
    ]
)
