//
//  PID+Methods.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension PID {
    /// Terminates the process.
    /// If the process is no longer running or the operation fails, an error is thrown.
    ///
    /// - Parameters:
    ///   - isForced: If enabled, the `SIGKILL` signal is sent to the process, killing
    ///     the process without first allowing it to clean up and terminate gracefully.
    ///     Otherwise, the `SIGTERM` signal is sent which allows graceful termination.
    nonisolated
    public func terminate(force isForced: Bool = false) throws(PIDError) {
        #if !os(Android)
        let result = kill(rawValue, isForced ? SIGKILL : SIGTERM)

        // On success, 0 is returned.
        // If signals were sent to a process group, success means that at least one signal was delivered.
        // On error, -1 is returned, and errno is set to indicate the error.

        switch result {
        case 0: break
        case -1: throw .systemControl(errno: &errno)
        default: return
        }
        #else
        throw .notSupported
        #endif
    }
}
