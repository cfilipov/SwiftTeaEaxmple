// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PrimeModal",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "PrimeModal",
            targets: ["PrimeModal"]),
    ],
    dependencies: [
        .package(path: "../SwiftTea"),
        .package(path: "../Util"),
    ],
    targets: [
        .target(
            name: "PrimeModal",
            dependencies: [
                "SwiftTea",
                "Util",
            ]),
        .testTarget(
            name: "PrimeModalTests",
            dependencies: ["PrimeModal"]),
    ]
)
