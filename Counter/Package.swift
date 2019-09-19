// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Counter",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Counter",
            targets: ["Counter"]),
    ],
    dependencies: [
        .package(path: "../SwiftTea"),
        .package(path: "../Wolfram"),
        .package(path: "../Util")
    ],
    targets: [
        .target(
            name: "Counter",
            dependencies: [
                "SwiftTea",
                "Wolfram",
                "Util"
            ]),
        .testTarget(
            name: "CounterTests",
            dependencies: ["Counter"]),
    ]
)
