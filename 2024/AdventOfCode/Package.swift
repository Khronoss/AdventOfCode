// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdventOfCode",
    platforms: [.macOS(.v15)],
    products: [
        .executable(named: "AdventOfCode"),
        .executable(named: "AdventOfCodeMacApp"),
        .library(named: "FileReader")
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
        .package(url: "https://github.com/pointfreeco/swift-parsing", from: "0.13.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "AdventOfCode",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .swiftParsing,
                "FileReader"
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .executableTarget(
            name: "AdventOfCodeMacApp",
            dependencies: [
                .swiftParsing,
                "FileReader"
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .target(name: "FileReader"),
        .testTarget(
            name: "AdventOfCodeTests",
            dependencies: ["AdventOfCode"]
        )
    ]
)

extension Product {
    static func executable(named: String) -> Product {
        executable(name: named, targets: [named])
    }

    static func library(named: String) -> Product {
        library(name: named, targets: [named])
    }
}

extension Target.Dependency {
    static var swiftParsing: Self {
        .product(name: "Parsing", package: "swift-parsing")
    }
}
