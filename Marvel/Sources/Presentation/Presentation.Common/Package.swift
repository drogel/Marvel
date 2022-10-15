// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Presentation.Common",
    platforms: [.iOS(.v15), .macOS(.v11)],
    products: [
        .library(
            name: "Presentation.Common",
            targets: ["Presentation.Common"]
        ),
    ],
    targets: [
        .target(
            name: "Presentation.Common",
            dependencies: []
        ),
    ]
)
