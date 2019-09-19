// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FavoritePrimes",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "FavoritePrimes",
            targets: ["FavoritePrimes"]),
    ],
    dependencies: [
         .package(path: "../SwiftTea"),
    ],
    targets: [
        .target(
            name: "FavoritePrimes",
            dependencies: [
                "SwiftTea"
            ]),
        .testTarget(
            name: "FavoritePrimesTests",
            dependencies: ["FavoritePrimes"]),
    ]
)
