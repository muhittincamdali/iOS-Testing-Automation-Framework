// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "iOSTestingAutomationFramework",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "iOSTestingAutomationFramework",
            targets: ["iOSTestingAutomationFramework"]
        )
    ],
    targets: [
        .target(
            name: "iOSTestingAutomationFramework",
            path: "Sources/iOSTestingAutomationFramework"
        ),
        .testTarget(
            name: "iOSTestingAutomationFrameworkTests",
            dependencies: ["iOSTestingAutomationFramework"],
            path: "Tests/iOSTestingAutomationFrameworkTests",
            // Baseline images for the snapshot tests, read from disk at run time.
            exclude: ["__Snapshots__"]
        )
    ]
)
