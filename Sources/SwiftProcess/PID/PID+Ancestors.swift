//
//  PID+Ancestors.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) || targetEnvironment(macCatalyst)

import Foundation

extension PID {
    /// Returns the process identifier of the parent process.
    /// If the process is no longer running or `self` is PID 1, `nil` is returned.
    nonisolated
    public var parent: PID? {
        guard let bsdInfo else { return nil }
        let parentPID = RawValue(bsdInfo.pbi_ppid)
        return PID(rawValue: parentPID)
    }
}

#endif
