//
//  Sequence+PID+BundleID.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

extension Sequence<PID> {
    /// Returns a Boolean value indicating whether the sequence contains a process associated with the specified bundle identifier.
    ///
    /// > Note: Bundle ID lookup is only available on macOS (not including Mac Catalyst).
    /// > On all other platforms, this property always returns `false`.
    @available(macOS 10.15, *)
    @available(macCatalyst, deprecated, message: "Not available on macCatalyst.")
    @available(iOS, deprecated, message: "Not available on iOS.")
    @available(tvOS, deprecated, message: "Not available on tvOS.")
    @available(watchOS, deprecated, message: "Not available on watchOS.")
    @available(visionOS, deprecated, message: "Not available on visionOS.")
    @_disfavoredOverload
    nonisolated
    public func contains(caseInsensitiveBundleID bundleID: BundleID) -> Bool {
        contains(caseInsensitiveBundleID: bundleID.rawValue)
    }

    /// Returns a Boolean value indicating whether the sequence contains a process associated with the specified bundle identifier.
    ///
    /// > Note: Bundle ID lookup is only available on macOS (not including Mac Catalyst).
    /// > On all other platforms, this property always returns `false`.
    @available(macOS 10.15, *)
    @available(macCatalyst, deprecated, message: "Not available on macCatalyst.")
    @available(iOS, deprecated, message: "Not available on iOS.")
    @available(tvOS, deprecated, message: "Not available on tvOS.")
    @available(watchOS, deprecated, message: "Not available on watchOS.")
    @available(visionOS, deprecated, message: "Not available on visionOS.")
    nonisolated
    public func contains(caseInsensitiveBundleID bundleID: String) -> Bool {
        bundleIDs
            .contains {
                $0.rawValue.caseInsensitiveCompare(bundleID) == .orderedSame
            }
    }

    /// Returns a lazy sequence of all bundle IDs in the sequence.
    ///
    /// > Note: Bundle ID lookup is only available on macOS (not including Mac Catalyst).
    /// > On all other platforms, this property always returns an empty sequence.
    @available(macOS 10.15, *)
    @available(macCatalyst, deprecated, message: "Not available on macCatalyst.")
    @available(iOS, deprecated, message: "Not available on iOS.")
    @available(tvOS, deprecated, message: "Not available on tvOS.")
    @available(watchOS, deprecated, message: "Not available on watchOS.")
    @available(visionOS, deprecated, message: "Not available on visionOS.")
    nonisolated
    public var bundleIDs: some Sequence<BundleID> {
        lazy.compactMap(\.bundleID)
    }

    /// Returns the first bundle ID in the sequence.
    ///
    /// > Note: Bundle ID lookup is only available on macOS (not including Mac Catalyst).
    /// > On all other platforms, this property always returns `nil`.
    @available(macOS 10.15, *)
    @available(macCatalyst, deprecated, message: "Not available on macCatalyst.")
    @available(iOS, deprecated, message: "Not available on iOS.")
    @available(tvOS, deprecated, message: "Not available on tvOS.")
    @available(watchOS, deprecated, message: "Not available on watchOS.")
    @available(visionOS, deprecated, message: "Not available on visionOS.")
    nonisolated
    public var firstBundleID: BundleID? {
        bundleIDs.first(where: { _ in true })
    }
}
