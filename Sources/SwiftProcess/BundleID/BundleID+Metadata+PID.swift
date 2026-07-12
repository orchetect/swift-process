//
//  BundleID+Metadata+PID.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

// Bundle ID lookup is only available on macOS (not including macCatalyst)

#if os(macOS)
import class AppKit.NSRunningApplication
#endif

@available(macOS 10.15, *)
@available(macCatalyst, deprecated, message: "Not available on macCatalyst.")
@available(iOS, deprecated, message: "Not available on iOS.")
@available(tvOS, deprecated, message: "Not available on tvOS.")
@available(watchOS, deprecated, message: "Not available on watchOS.")
@available(visionOS, deprecated, message: "Not available on visionOS.")
extension BundleID {
    /// Returns all process identifiers for running processes associated with the specified bundle identifier.
    ///
    /// > Note: Bundle ID and PID lookup is only available on macOS (not including Mac Catalyst).
    /// > On all other platforms, this property always returns an empty collection.
    nonisolated
    public var pids: Set<PID> {
        #if os(macOS)
        let runningApps = NSRunningApplication
            .runningApplications(withBundleIdentifier: rawValue)

        let pids = runningApps
            .map(\.processIdentifier)
            .map(PID.init(rawValue:))

        return Set(pids)
        #else
        return []
        #endif
    }
}
