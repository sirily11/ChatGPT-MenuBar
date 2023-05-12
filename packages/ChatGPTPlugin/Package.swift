// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ChatGPTPlugin",
    platforms: [
        .macOS(.v12),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ChatGPTPlugin",
            targets: ["ChatGPTPlugin"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/alfianlosari/ChatGPTSwift", exact: "1.3.3"),
        .package(path: "../MenuBarSDK"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ChatGPTPlugin",
            dependencies: [
                .product(name: "ChatGPTSwift", package: "ChatGPTSwift"),
                .product(name: "MenuBarSDK", package: "MenuBarSDK"),
            ]),
        .testTarget(
            name: "ChatGPTPluginTests",
            dependencies: ["ChatGPTPlugin"]),
    ])
