// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "peak-ios-prkit",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PRKit",
            targets: ["PRKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/svgkit/svgkit", from: "3.0.0"),
        .package(url: "https://github.com/mischa-hildebrand/AlignedCollectionViewFlowLayout", from: "1.1.3"),
        .package(url: "https://github.com/alankarmisra/SwiftSignatureView", exact: "3.2.1"),
        .package(url: "https://github.com/podkovyrin/Keyboardy", from: "0.2.7")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PRKit",
            dependencies: [
                .product(name: "SVGKit", package: "SVGKit"),
                .product(name: "AlignedCollectionViewFlowLayout", package: "AlignedCollectionViewFlowLayout"),
                .product(name: "SwiftSignatureView", package: "SwiftSignatureView"),
                .product(name: "Keyboardy", package: "Keyboardy")
            ],
            resources: [
                .process("Assets/Branding/logo.full.dark.svg"),
                .process("Assets/Branding/logo.full.light.svg"),
                .process("Assets/Branding/logo.full.white.svg"),
                .process("Assets/Branding/logo.square.dark.svg"),
                .process("Assets/Branding/logo.square.light.svg"),
            ]
        ),
        .testTarget(
            name: "PRKitTests",
            dependencies: ["PRKit"]
        ),
    ],
    swiftLanguageModes: [.v5]
)
