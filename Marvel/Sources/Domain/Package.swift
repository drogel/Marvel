// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Domain",
    platforms: [.iOS(.v15), .macOS(.v11)],
    products: [
        .library(name: "Domain", targets: ["Domain"]),
        .library(name: "DomainTestUtils", targets: ["DomainTestUtils"])
    ],
    dependencies: [
        .package(name: "TestUtils", path: "MarvelTests/TestUtils")
    ],
    targets: [
        .target(
            name: "Domain",
            dependencies: []),
        .target(
            name: "DomainTestUtils",
            dependencies: ["Domain"]),
        .testTarget(
            name: "DomainTests",
            dependencies: ["Domain", "TestUtils", "DomainTestUtils"]),
    ]
)
