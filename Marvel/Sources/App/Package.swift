// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "App",
    platforms: [.iOS(.v15), .macOS(.v11)],
    products: [
        .library(
            name: "App",
            targets: ["App"]
        ),
    ],
    dependencies: [
        .package(name: "Data", path: "Marvel/Sources/Data"),
        .package(name: "Domain", path: "Marvel/Sources/Domain"),
        .package(name: "Presentation", path: "Marvel/Sources/Presentation"),
        .package(name: "DomainTestUtils", path: "TestUtils/DomainTestUtils"),
        .package(url: "https://github.com/hmlongco/Factory", from: Version(1, 2, 8)),
    ],
    targets: [
        .target(
            name: "App",
            dependencies: ["Data", "Domain", "Presentation", "Factory"]
        ),
        .testTarget(
            name: "AppTests",
            dependencies: [
                "DomainTestUtils",
                "App",
            ]
        ),
    ]
)
