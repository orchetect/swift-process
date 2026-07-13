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
    public func terminate(force isForced: Bool = false) throws(SystemError) {
        let result = kill(rawValue, isForced ? SIGKILL : SIGTERM)
        guard result != 0 else {
            throw .systemControl(errno: errno)
        }
    }
}
