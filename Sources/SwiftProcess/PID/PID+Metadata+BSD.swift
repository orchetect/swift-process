//
//  PID+Metadata+BSD.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) || targetEnvironment(macCatalyst)

import Foundation

// MARK: - BSD Process Info

extension PID {
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

    /// Returns the BSD short information struct for the process.
    /// If the process is no longer running or an error occurred, `nil` is returned.
    nonisolated
    public var bsdShortInfo: proc_bsdshortinfo? {
        var bsdInfo = proc_bsdshortinfo()

        let size = MemoryLayout<proc_bsdshortinfo>.stride
        let result = withUnsafeMutablePointer(to: &bsdInfo) {
            $0.withMemoryRebound(to: CChar.self, capacity: size) {
                proc_pidinfo(rawValue, PROC_PIDT_SHORTBSDINFO, 0, $0, Int32(size))
            }
        }

        guard result == size else {
            return nil
        }

        return bsdInfo
    }
}

// MARK: - BSD System Control

extension PID {
    /// Returns the memory information base (MIB) for the process that is passed to `sysctl` calls.
    nonisolated
    var memoryInformationBase: [Int32] {
        [CTL_KERN, KERN_PROC, KERN_PROC_PID, rawValue]
    }

    /// Returns the `sysctl` information struct (`kinfo_proc`) for the process.
    nonisolated
    public var sysctlInfo: kinfo_proc {
        get throws(SystemError) {
            var mib = memoryInformationBase
            var procInfo = kinfo_proc()
            var procInfoSize = MemoryLayout<kinfo_proc>.size

            let result = sysctl(
                &mib,
                UInt32(mib.count),
                &procInfo,
                &procInfoSize,
                nil,
                0
            )

            guard result == 0 else {
                throw .systemControl(errno: result)
            }

            return procInfo
        }
    }
}

#endif
