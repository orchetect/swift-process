# SwiftProcess

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Forchetect%2Fswift-process%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/orchetect/swift-process) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Forchetect%2Fswift-process%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/orchetect/swift-process) [![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/swift-process/blob/main/LICENSE)

A toolkit for managing and gathering information on applications and processes in Swift.

The library provides cross-platform foundational types for things like process IDs and application bundle IDs.

> [!NOTE]
>
> While the library is primarily oriented toward macOS, functionality for other platforms such as Linux is implemented where possible

## Getting Started

This library is available as a Swift Package Manager (SPM) package.

1. Add the **swift-process** repo as a dependency.

   ```swift
   .package(url: "https://github.com/orchetect/swift-process", from: "0.1.0")
   ```

2. Add **SwiftProcess** to your target.

   ```swift
   .product(name: "SwiftProcess", package: "swift-process")
   ```

3. Import **SwiftProcess** to use it.

   ```swift
   import SwiftProcess
   ```

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](LICENSE) for details.
