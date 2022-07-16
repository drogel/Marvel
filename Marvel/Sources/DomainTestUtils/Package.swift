// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DomainTestUtils",
    platforms: [.iOS(.v15), .macOS(.v11)],
    products: [
        .library(
            name: "DomainTestUtils",
            targets: ["DomainTestUtils"]
        ),
    ],
    dependencies: [
        .package(name: "Domain", path: "Marvel/Sources/Domain"),
    ],
    targets: [
        .target(
            name: "DomainTestUtils",
            dependencies: ["Domain"]
        ),
    ]
)
