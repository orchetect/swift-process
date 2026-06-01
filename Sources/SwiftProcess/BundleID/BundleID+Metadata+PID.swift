//
//  BundleID+Metadata+PID.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

// Bundle ID lookup is only available on macOS (not including macCatalyst)

#if os(macOS)

import class AppKit.NSRunningApplication

extension BundleID {
    /// Returns all process identifiers for running processes associated with the specified bundle identifier.
    nonisolated
    public var pids: Set<PID> {
        let runningApps = NSRunningApplication
            .runningApplications(withBundleIdentifier: rawValue)

        let pids = runningApps
            .map(\.processIdentifier)
            .map(PID.init(rawValue:))

        return Set(pids)
    }
}

#endif
