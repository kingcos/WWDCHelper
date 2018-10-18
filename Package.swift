// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWDCHelper",
    dependencies: [
        .package(url: "https://github.com/kylef/PathKit.git", from: "0.9.2"),
        .package(url: "https://github.com/onevcat/Rainbow.git", from: "3.1.4"),
        .package(url: "https://github.com/kylef/Spectre.git", from: "0.9.0"),
        .package(url: "https://github.com/kingcos/CommandLine.git", from: "4.2.0")
    ],
    targets: [
        .target(
            name: "WWDCHelper",
            dependencies: ["WWDCHelperKit", "CommandLine", "Rainbow"]),
        .target(
            name: "WWDCHelperKit",
            dependencies: ["WWDCWebVTTToSRTHelperKit", "PathKit", "Rainbow"]),
        .target(
            name: "WWDCWebVTTToSRTHelperKit",
            dependencies: []),
        .testTarget(
            name: "WWDCHelperKitTests",
            dependencies: ["WWDCHelperKit", "PathKit", "Spectre"]),
        .testTarget(
            name: "WWDCWebVTTToSRTHelperKitTests",
            dependencies: ["WWDCWebVTTToSRTHelperKit", "PathKit", "Spectre"]),
        ]
)
