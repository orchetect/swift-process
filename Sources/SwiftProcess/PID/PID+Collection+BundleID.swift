//
//  PID+Collection+BundleID.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

// Bundle ID lookup is only available on macOS (not including macCatalyst)

#if os(macOS)

import AppKit

extension Sequence<PID> {
    /// Returns a Boolean value indicating whether the sequence contains a process associated with the specified bundle identifier.
    @_disfavoredOverload
    nonisolated
    public func contains(caseInsensitiveBundleID bundleID: BundleID) -> Bool {
        contains(caseInsensitiveBundleID: bundleID.rawValue)
    }

    /// Returns a Boolean value indicating whether the sequence contains a process associated with the specified bundle identifier.
    nonisolated
    public func contains(caseInsensitiveBundleID bundleID: String) -> Bool {
        bundleIDs
            .contains {
                $0.rawValue.caseInsensitiveCompare(bundleID) == .orderedSame
            }
    }

    /// Returns a lazy sequence of all bundle IDs in the sequence.
    nonisolated
    public var bundleIDs: some Sequence<BundleID> {
        lazy.compactMap(\.bundleID)
    }

    /// Returns the first bundle ID in the sequence.
    nonisolated
    public var firstBundleID: BundleID? {
        bundleIDs.first(where: { _ in true })
    }
}

#endif
