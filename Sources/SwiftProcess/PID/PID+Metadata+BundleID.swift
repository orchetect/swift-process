//
//  PID+Metadata+BundleID.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

// Bundle ID lookup is only available on macOS (not including macCatalyst)

#if os(macOS)

import AppKit

extension PID {
    /// Returns the bundle identifier for the process.
    /// This returns `nil` if no running application matches the process identifier.
    nonisolated
    public var bundleID: BundleID? {
        // Create an NSRunningApplication with the given process identifier.
        // This returns `nil` if no running app matches the PID.
        guard let runningApp = NSRunningApplication(processIdentifier: rawValue),
              let bundleID = runningApp.bundleIdentifier
        else {
            return nil
        }
        return BundleID(bundleID)
    }
}

#endif
