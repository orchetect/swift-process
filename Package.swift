// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-process",
    platforms: [.macOS(.v10_15), .macCatalyst(.v13), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)],
    products: [
        .library(name: "SwiftProcess", targets: ["SwiftProcess"])
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/swift-testing-extensions", from: "0.3.0")
    ],
    targets: [
        .target(name: "SwiftProcess"),
        .testTarget(
            name: "SwiftProcessTests",
            dependencies: [
                "SwiftProcess",
                .product(name: "TestingExtensions", package: "swift-testing-extensions")
            ]
        )
    ]
)
