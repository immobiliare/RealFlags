// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BentoFlags",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "BentoFlags", targets: ["BentoFlags"]),
        .library(name: "BentoFlagsFirebase", targets: ["BentoFlagsFirebase"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(
            name: "Firebase",
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            from: "7.0.0"
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "BentoFlags",
            dependencies: [],
            path: "BentoFlags/Sources"
        ),
        .target(
            name: "BentoFlagsFirebase",
            dependencies: [
                "BentoFlags",
                .product(name: "FirebaseRemoteConfig", package: "Firebase"),
            ],
            path: "BentoFlagsFirebase/Sources"
        ),
        .testTarget(
            name: "BentoFlagsTests",
            dependencies: ["BentoFlags"]),
    ]
)
