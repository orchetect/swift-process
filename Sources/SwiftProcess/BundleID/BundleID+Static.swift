//
//  BundleID+Static.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

// Bundle ID lookup is only available on macOS (not including macCatalyst)

#if os(macOS)

import class Foundation.Bundle

extension BundleID {
    /// Returns the bundle identifier for the current process's main bundle.
    public static var main: BundleID? {
        guard let string = Bundle.main.bundleIdentifier else { return nil }
        return BundleID(string)
    }
}

#endif
