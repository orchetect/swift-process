//
//  PID+Metadata+BundleID.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)
import AppKit
#endif

extension PID {
    /// Returns the bundle identifier for the process.
    /// This returns `nil` if no running application matches the process identifier.
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
    public var bundleID: BundleID? {
        // Bundle ID lookup is only available on macOS (not including macCatalyst)
        #if os(macOS)
        // Create an NSRunningApplication with the given process identifier.
        // This returns `nil` if no running app matches the PID.
        guard let runningApp = NSRunningApplication(processIdentifier: rawValue),
              let bundleID = runningApp.bundleIdentifier
        else {
            return nil
        }
        return BundleID(bundleID)
        #else
        return nil
        #endif
    }
}
