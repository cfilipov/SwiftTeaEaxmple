// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PrimeTime",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "PrimeTime",
            targets: ["PrimeTime"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-prelude.git", .branch("master")),
        .package(path: "../SwiftTea"),
        .package(path: "../ActivityIndicator"),
        .package(path: "../Wolfram"),
        .package(path: "../Util"),
        .package(path: "../Counter"),
        .package(path: "../PrimeModal"),
        .package(path: "../FavoritePrimes"),
    ],
    targets: [
        .target(
            name: "PrimeTime",
            dependencies: [
                "Prelude",
                "SwiftTea",
                "ActivityIndicator",
                "Wolfram",
                "Util",
                "Counter",
                "PrimeModal",
                "FavoritePrimes",
            ]),
        .testTarget(
            name: "PrimeTimeTests",
            dependencies: ["PrimeTime"]),
    ]
)
