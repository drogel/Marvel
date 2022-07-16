// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Presentation",
    platforms: [.iOS(.v15), .macOS(.v11)],
    products: [
        .library(
            name: "Presentation",
            targets: ["Presentation"]
        ),
    ],
    dependencies: [
        .package(name: "TestUtils", path: "TestUtils/TestUtils"),
        .package(name: "Domain", path: "Marvel/Sources/Domain"),
        .package(name: "DomainTestUtils", path: "TestUtils/DomainTestUtils"),
    ],
    targets: [
        .target(
            name: "Presentation",
            dependencies: ["Domain"]
        ),
        .testTarget(
            name: "PresentationTests",
            dependencies: [
                "DomainTestUtils",
                "Presentation",
                "TestUtils",
            ]
        ),
    ]
)
