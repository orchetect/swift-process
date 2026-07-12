//
//  BundleID+Static.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import class Foundation.Bundle

extension BundleID {
    /// Returns the bundle identifier for the current process's main bundle.
    ///
    /// > Note: Bundle ID lookup is only available on macOS (not including Mac Catalyst).
    /// > On all other platforms, this property always returns `nil`.
    public static var main: BundleID? {
        #if os(macOS)
        guard let string = Bundle.main.bundleIdentifier else { return nil }
        return BundleID(string)
        #else
        return nil
        #endif
    }
}
