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

## Documentation

See the [online documentation](https://swiftpackageindex.com/orchetect/swift-process/documentation) for library usage and getting started info.

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](LICENSE) for details.

## Sponsoring

If you enjoy using this library and want to contribute to open-source financially, GitHub sponsorship is much appreciated. Feedback and code contributions are also welcome.

## Community & Support

Please do not email maintainers for technical support. Several options are available for issues and questions:

- Questions and feature ideas can be posted to [Discussions](https://github.com/orchetect/swift-process/discussions).
- If an issue is a verifiable bug with reproducible steps it may be posted in [Issues](https://github.com/orchetect/swift-process/issues).

## Contributions

Contributions are welcome. Posting in [Discussions](https://github.com/orchetect/swift-process/discussions) first prior to new submitting PRs for features or modifications is encouraged.

## Code Quality & AI Contribution Policy

In an effort to maintain a consistent level of code quality and safety, this repository was built by hand and is maintained without the use of AI code generation.

AI-assisted contributions are welcome, but must remain modest in scope, maintain the same degree of quality and care, and be thoroughly vetted before acceptance.
