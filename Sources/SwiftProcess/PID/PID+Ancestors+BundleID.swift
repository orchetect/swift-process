//
//  PID+Ancestors+BundleID.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)
import AppKit
#endif

@available(macOS 10.15, *)
@available(macCatalyst, deprecated, message: "Not available on macCatalyst.")
@available(iOS, deprecated, message: "Not available on iOS.")
@available(tvOS, deprecated, message: "Not available on tvOS.")
@available(watchOS, deprecated, message: "Not available on watchOS.")
@available(visionOS, deprecated, message: "Not available on visionOS.")
extension PID {
    /// Returns `true` if any of a PID's ancestors have the given bundle ID, using case-insensitive comparison.
    /// Optionally start with the specified PID first before iterating on its ancestors.
    @_disfavoredOverload
    nonisolated
    public func hasAncestor(withBundleID bundleID: BundleID) -> Bool {
        #if os(macOS)
        ancestors.contains(caseInsensitiveBundleID: bundleID.rawValue)
        #else
        false
        #endif
    }

    /// Returns `true` if any of a PID's ancestors have the given bundle ID, using case-insensitive comparison.
    /// Optionally start with the specified PID first before iterating on its ancestors.
    nonisolated
    public func hasAncestor(withBundleID bundleID: String) -> Bool {
        #if os(macOS)
        ancestors.contains(caseInsensitiveBundleID: bundleID)
        #else
        false
        #endif
    }
}
