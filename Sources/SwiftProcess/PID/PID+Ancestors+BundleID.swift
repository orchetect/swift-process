//
//  PID+Ancestors+BundleID.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

// Bundle ID lookup is only available on macOS (not including macCatalyst)

#if os(macOS)

import AppKit

extension PID {
    /// Returns `true` if any of a PID's ancestors have the given bundle ID, using case-insensitive comparison.
    /// Optionally start with the specified PID first before iterating on its ancestors.
    @_disfavoredOverload
    nonisolated
    public func hasAncestor(withBundleID bundleID: BundleID) -> Bool {
        ancestors.contains(caseInsensitiveBundleID: bundleID.rawValue)
    }

    /// Returns `true` if any of a PID's ancestors have the given bundle ID, using case-insensitive comparison.
    /// Optionally start with the specified PID first before iterating on its ancestors.
    nonisolated
    public func hasAncestor(withBundleID bundleID: String) -> Bool {
        ancestors.contains(caseInsensitiveBundleID: bundleID)
    }
}

#endif
