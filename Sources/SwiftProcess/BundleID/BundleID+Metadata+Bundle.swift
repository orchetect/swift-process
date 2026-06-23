//
//  BundleID+Metadata+Bundle.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

// Bundle ID lookup is only available on macOS (not including macCatalyst)

#if os(macOS)

import class AppKit.NSRunningApplication
import class AppKit.NSWorkspace
import class Foundation.Bundle
import struct Foundation.URL

extension BundleID {
    /// Returns the file URL of the bundle with the bundle identifier, if the bundle can be located in the system.
    ///
    /// Note that this method may take some time to return, so it is ideal to call it on a background
    /// actor asynchronously and await its result.
    nonisolated
    public var bundleURL: URL? {
        NSWorkspace.shared.urlForApplication(withBundleIdentifier: rawValue)
            ?? Bundle(identifier: rawValue)?.bundleURL
    }
}

#endif
