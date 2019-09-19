// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Wolfram",
    products: [
        .library(
            name: "Wolfram",
            targets: ["Wolfram"]),
    ],
    dependencies: [
        .package(path: "../Util"),
    ],
    targets: [
        .target(
            name: "Wolfram",
            dependencies: [
                "Util",
            ]),
        .testTarget(
            name: "WolframTests",
            dependencies: ["Wolfram"]),
    ]
)
