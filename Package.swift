// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-process",
    platforms: [.macOS(.v10_15), .macCatalyst(.v13), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)],
    products: [
        .library(name: "SwiftProcess", targets: ["SwiftProcess"])
    ],
    targets: [
        .target(name: "SwiftProcess"),
        .testTarget(name: "SwiftProcessTests", dependencies: ["SwiftProcess"])
    ]
)
