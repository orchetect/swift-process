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
    @available(macOS 10.15, *)
    @available(iOS, deprecated, message: "Not available on iOS.")
    @available(tvOS, deprecated, message: "Not available on tvOS.")
    @available(watchOS, deprecated, message: "Not available on watchOS.")
    @available(visionOS, deprecated, message: "Not available on visionOS.")
    nonisolated
    public var parent: PID? {
        #if os(macOS) || targetEnvironment(macCatalyst)
        guard let bsdInfo else { return nil }
        let parentPID = RawValue(bsdInfo.pbi_ppid)
        return PID(rawValue: parentPID)
        #else
        return nil
        #endif
    }
}
