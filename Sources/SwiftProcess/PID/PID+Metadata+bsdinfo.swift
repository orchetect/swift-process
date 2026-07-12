//
//  PID+Metadata+bsdinfo.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension PID {
    #if os(macOS) || targetEnvironment(macCatalyst)

    /// Returns the BSD information struct for the process.
    /// If the process is no longer running or an error occurred, `nil` is returned.
    nonisolated
    public var bsdInfo: proc_bsdinfo? {
        // The `proc_bsdinfo` struct holds assorted information about a BSD process
        var bsdInfo = proc_bsdinfo()

        // Call `proc_pidinfo`, requesting `PROC_PIDTBSDINFO`
        // This populates `bsdInfo` if successful
        let size = MemoryLayout<proc_bsdinfo>.stride
        let result = withUnsafeMutablePointer(to: &bsdInfo) {
            $0.withMemoryRebound(to: CChar.self, capacity: size) {
                proc_pidinfo(rawValue, PROC_PIDTBSDINFO, 0, $0, Int32(size))
            }
        }

        // If the call returns the size of `proc_bsdinfo`, it succeeded
        guard result == size else {
            return nil // failed, or pid doesn't exist
        }

        return bsdInfo
    }

    #endif
}

// MARK: - BSD Info

@available(macOS 10.15, *)
@available(iOS, deprecated, message: "Not available on iOS.")
@available(tvOS, deprecated, message: "Not available on tvOS.")
@available(watchOS, deprecated, message: "Not available on watchOS.")
@available(visionOS, deprecated, message: "Not available on visionOS.")
extension PID {
    /// Returns the command name of the process (Limited to 15 characters).
    /// If the process is no longer running or no name is returned from the system, `nil` is returned.
    ///
    /// > Note: Process info lookup is only available on macOS and Mac Catalyst.
    /// > On all other platforms, this property always returns `nil`.
    nonisolated
    public var commandName: String? {
        #if os(macOS) || targetEnvironment(macCatalyst)
        guard let bsdInfo else { return nil }
        return bsdInfo.getCommandName()
        #else
        return nil
        #endif
    }

    /// Returns the name of the process.
    /// If the process is no longer running or no name is returned from the system, `nil` is returned.
    ///
    /// > Note: Process info lookup is only available on macOS and Mac Catalyst.
    /// > On all other platforms, this property always returns `nil`.
    nonisolated
    public var name: String? {
        #if os(macOS) || targetEnvironment(macCatalyst)
        guard let bsdInfo else { return nil }
        return bsdInfo.getName()
        #else
        return nil
        #endif
    }
}
