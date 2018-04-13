// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "WWDCHelper",
    dependencies: [
        .package(url: "https://github.com/kylef/PathKit.git", from: "0.9.1"),
        .package(url: "https://github.com/onevcat/Rainbow.git", from: "3.1.1"),
        .package(url: "https://github.com/kylef/Spectre.git", from: "0.8.0"),
        .package(url: "https://github.com/kingcos/CommandLine.git", from: "4.1.0")
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
