// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TypoChecker",
    products: [
        .executable(name: "TypoChecker", targets: ["TypoChecker"])
    ],
    dependencies: [
        .package(url: "https://github.com/seznam/swift-uniyaml.git", from: "0.11.1"),
        .package(url: "https://github.com/JohnSundell/Files.git", from: "2.3.0"),
        
        ],
    targets: [
        .target(
            name: "TypoChecker",
            dependencies: [
                "UniYAML",
                "Files"
                ]),
        .testTarget(
            name: "TypoCheckerTests",
            dependencies: ["TypoChecker"]),
        ]
)
