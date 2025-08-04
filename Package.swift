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
        .library(
            name: "iOSTestingAutomationCore",
            targets: ["iOSTestingAutomationCore"]),
        .library(
            name: "iOSTestingAutomationUI",
            targets: ["iOSTestingAutomationUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.0"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.0.0"),
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.3.0"),
        .package(url: "https://github.com/jrendel/SwiftKeychainWrapper.git", from: "4.0.0"),
        .package(url: "https://github.com/apple/swift-crypto.git", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-metrics.git", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "iOSTestingAutomationFramework",
            dependencies: [
                "iOSTestingAutomationCore",
                "iOSTestingAutomationUI",
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "Kingfisher", package: "Kingfisher"),
                .product(name: "Lottie", package: "lottie-ios"),
                .product(name: "SwiftKeychainWrapper", package: "SwiftKeychainWrapper"),
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Metrics", package: "swift-metrics"),
                .product(name: "Collections", package: "swift-collections"),
            ],
            path: "Sources/Framework"),
        
        .target(
            name: "iOSTestingAutomationCore",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Metrics", package: "swift-metrics"),
            ],
            path: "Sources/Core"),
        
        .target(
            name: "iOSTestingAutomationUI",
            dependencies: [
                "iOSTestingAutomationCore",
                .product(name: "Kingfisher", package: "Kingfisher"),
                .product(name: "Lottie", package: "lottie-ios"),
            ],
            path: "Sources/UI"),
        
        .testTarget(
            name: "iOSTestingAutomationFrameworkTests",
            dependencies: [
                "iOSTestingAutomationFramework",
                "iOSTestingAutomationCore",
                "iOSTestingAutomationUI"
            ],
            path: "Tests/FrameworkTests"),
        
        .testTarget(
            name: "iOSTestingAutomationCoreTests",
            dependencies: ["iOSTestingAutomationCore"],
            path: "Tests/CoreTests"),
        
        .testTarget(
            name: "iOSTestingAutomationUITests",
            dependencies: ["iOSTestingAutomationUI"],
            path: "Tests/UITests"),
    ]
) 