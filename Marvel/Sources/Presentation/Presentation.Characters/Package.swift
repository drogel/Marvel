// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Presentation.Characters",
    platforms: [.iOS(.v15), .macOS(.v11)],
    products: [
        .library(
            name: "Presentation.Characters",
            targets: ["Presentation.Characters"]
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
            name: "Presentation.Characters",
            dependencies: ["Domain", "Presentation.Common"]
        ),
        .testTarget(
            name: "Presentation.CharactersTests",
            dependencies: ["Presentation.Characters", "DomainTestUtils", "TestUtils"]
        ),
    ]
)
