// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SurveyApp",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "SurveyApp",
            targets: ["SurveyApp"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "SurveyApp",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]),
        .testTarget(
            name: "SurveyAppTests",
            dependencies: ["SurveyApp"]),
    ]
) 