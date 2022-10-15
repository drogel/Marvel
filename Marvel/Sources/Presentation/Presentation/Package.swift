// swift-tools-version: 5.6

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
        .package(
            name: "Presentation.Characters",
            path: "Marvel/Sources/Presentation/Presentation.Characters"
        ),
        .package(
            name: "Presentation.CharacterDetail",
            path: "Marvel/Sources/Presentation/Presentation.CharacterDetail"
        ),
    ],
    targets: [
        .target(
            name: "Presentation",
            dependencies: ["Presentation.Characters", "Presentation.CharacterDetail"]
        ),
    ]
)
