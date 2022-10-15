// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Data",
    platforms: [.iOS(.v15), .macOS(.v11)],
    products: [
        .library(
            name: "Data",
            targets: ["Data"]
        ),
    ],
    dependencies: [
        .package(name: "TestUtils", path: "TestUtils/TestUtils"),
        .package(name: "Domain", path: "Marvel/Sources/Domain/Domain"),
        .package(name: "DomainTestUtils", path: "TestUtils/DomainTestUtils"),
    ],
    targets: [
        .target(
            name: "Data",
            dependencies: ["Domain"],
            resources: [
                .process("Resources"),
            ]
        ),
        .testTarget(
            name: "DataTests",
            dependencies: [
                "DomainTestUtils",
                "Data",
                "TestUtils",
            ],
            resources: [
                .process("Jsons"),
            ]
        ),
    ]
)
