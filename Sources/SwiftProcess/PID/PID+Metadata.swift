//
//  PID+Metadata.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) || targetEnvironment(macCatalyst) || os(Linux)

import Foundation

extension PID {
    // TODO: untested on Linux
    /// Returns the BSD info struct for the process.
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

    // TODO: untested on Linux
    /// Returns the name of the process.
    /// If the process is no longer running or no name is returned from the system, `nil` is returned.
    nonisolated
    public var name: String? {
        guard let bsdInfo else { return nil }

        typealias NameTuple = (
            CChar,
            CChar,
            CChar,
            CChar,
            CChar,
            CChar,
            CChar,
            CChar,
            CChar,
            CChar,
            CChar,
            CChar,
            CChar,
            CChar,
            CChar,
            CChar,
            CChar,
            CChar,
            CChar,
            CChar,
            CChar,
            CChar,
            CChar,
            CChar,
            CChar,
            CChar,
            CChar,
            CChar,
            CChar,
            CChar,
            CChar,
            CChar
        )

        let tuple: NameTuple = bsdInfo.pbi_name
        let charCount = MemoryLayout<NameTuple>.stride // 32 bytes
        let string = withUnsafePointer(to: tuple) { ptr in
            ptr.withMemoryRebound(to: CChar.self, capacity: charCount) { pointer in
                String(cString: pointer)
            }
        }
        return string
    }
}

#endif
