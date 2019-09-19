// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftTea",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "SwiftTea",
            targets: ["SwiftTea"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftTea",
            dependencies: []),
        .testTarget(
            name: "SwiftTeaTests",
            dependencies: ["SwiftTea"]),
    ]
)
