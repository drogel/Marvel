// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Presentation.CharacterDetail",
    platforms: [.iOS(.v15), .macOS(.v11)],
    products: [
        .library(
            name: "Presentation.CharacterDetail",
            targets: ["Presentation.CharacterDetail"]
        ),
    ],
    dependencies: [
        .package(name: "Domain", path: "Marvel/Sources/Domain/Domain"),
        .package(name: "DomainTestUtils", path: "TestUtils/DomainTestUtils"),
        .package(name: "TestUtils", path: "TestUtils/TestUtils"),
        .package(name: "Presentation.Common", path: "Marvel/Sources/Presentation/Presentation.Common"),
    ],
    targets: [
        .target(
            name: "Presentation.CharacterDetail",
            dependencies: ["Domain", "Presentation.Common"]
        ),
        .testTarget(
            name: "Presentation.CharacterDetailTests",
            dependencies: ["Presentation.CharacterDetail", "DomainTestUtils", "TestUtils"]
        ),
    ]
)
