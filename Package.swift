// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RealFlags",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "RealFlags", targets: ["RealFlags"]),
        .library(name: "RealFlagsFirebase", targets: ["RealFlagsFirebase"])
    ],
    dependencies: [
        .package(
            name: "Firebase",
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            from: "7.0.0"
        )
    ],
    targets: [
        .target(
            name: "RealFlags",
            dependencies: [],
            path: "RealFlags/Sources"
        ),
        .target(
            name: "RealFlagsFirebase",
            dependencies: [
                "RealFlags",
                .product(name: "FirebaseRemoteConfig", package: "Firebase"),
            ],
            path: "RealFlagsFirebase/Sources"
        ),
        .testTarget(
            name: "RealFlagsTests",
            dependencies: ["RealFlags"]),
    ]
)
