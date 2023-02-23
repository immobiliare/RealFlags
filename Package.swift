// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RealFlags",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(name: "RealFlags", targets: ["RealFlags"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "RealFlags",
            dependencies: [],
            path: "RealFlags/Sources/RealFlags/Classes",
            resources: [
                .process("Browser/FlagsBrowserController.storyboard"),
                .process("Browser/Cells/FlagBrowserDataCell.xib"),
                .process("Browser/Cells/FlagsBrowserDefaultCell.xib"),
                .process("Browser/Cells/FlagsBrowserToggleCell.xib")
            ]
        ),
        .testTarget(
            name: "RealFlagsTests",
            dependencies: ["RealFlags"]),
    ]
)
