//
//  PID+Ancestors.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension PID {
    /// Returns the process identifier of the parent process.
    /// If the process is no longer running or `self` is PID 1, `nil` is returned.
    ///
    /// > Note: Process info lookup is only available on macOS and Mac Catalyst.
    /// > On all other platforms, this property always returns `nil`.
    @available(macOS 10.15, macCatalyst 13, *)
    @available(iOS, deprecated, message: "Not available on iOS.")
    @available(tvOS, deprecated, message: "Not available on tvOS.")
    @available(watchOS, deprecated, message: "Not available on watchOS.")
    @available(visionOS, deprecated, message: "Not available on visionOS.")
    nonisolated
    public var parent: PID? {
        #if os(macOS) || targetEnvironment(macCatalyst)
        // proc_bsdshortinfo often has more information on non-user processes than proc_bsdinfo

        guard let parentPID = bsdShortInfo?.pbsi_ppid ?? bsdInfo?.pbi_ppid
        else { return nil }

        guard let pid = RawValue(exactly: parentPID) else { return nil }

        return PID(rawValue: pid)
        #else
        return nil
        #endif
    }
}
