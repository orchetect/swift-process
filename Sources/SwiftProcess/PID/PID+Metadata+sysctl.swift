//
//  PID+Metadata+sysctl.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension PID {
    /// Returns the memory information base (MIB) for the process that is passed to `sysctl` calls.
    var memoryInformationBase: [Int32] {
        [CTL_KERN, KERN_PROC, KERN_PROC_PID, rawValue]
    }

    /// Returns the `sysctl` information struct (`kinfo_proc`) for the process.
    /// If the process is no longer running or an error occurred, `nil` is returned.
    public var sysctlInfo: kinfo_proc? {
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
            return nil
        }

        return procInfo
    }
}

// MARK: - SysCtl Info

extension PID {
    /// Returns the launch date and time of the process as `Date`.
    /// If the process is no longer running or an error occurred, `nil` is returned.
    public var launchDate: Date? {
        guard let secondsSinceEpoch = sysctlInfo?.kp_proc.p_starttime.tv_sec else { return nil }
        return Date(timeIntervalSince1970: TimeInterval(secondsSinceEpoch))
    }

    /// Returns the uptime of the process in seconds.
    /// If the process is no longer running or an error occurred, `nil` is returned.
    public var uptime: TimeInterval? {
        guard let launchDate else { return nil }
        return Date().timeIntervalSince(launchDate)
    }
}
