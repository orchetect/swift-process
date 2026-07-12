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
