//
//  PIDError.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import protocol Foundation.LocalizedError
import func Foundation.perror

/// Errors thrown by ``PID`` methods that call system functions.
public enum PIDError {
    /// Command execution failed.
    case commandExecutionFailed(command: String, reason: String)

    /// Feature is not supported on this platform.
    case notSupported

    /// The PID does not belong to a process currently running in the system, or
    /// the current process has insufficient privileges to retrieve information for it.
    case pidDoesNotExist

    /// Error returned by a call to the `sysctl` command.
    case systemControl(errno: Int32, message: String)
}

extension PIDError: Equatable { }

extension PIDError: Hashable { }

extension PIDError: Sendable { }

// MARK: - Static Constructors

extension PIDError {
    /// Errors thrown by ``PID`` methods that call system functions.
    /// The error message will be populated automatically with this constructor.
    public static func systemControl(errno errorNumber: Int32) -> Self {
        var errorNumber = errorNumber
        return systemControl(errno: &errorNumber)
    }

    /// Initialize from a mutable error number.
    /// The error message will be populated automatically.
    public static func systemControl(errno errorNumber: inout Int32) -> Self {
        // capture error to a String variable
        var errorMessage = String()
        dump(perror(&errorNumber), to: &errorMessage)
        let message = errorMessage

        return .systemControl(errno: errorNumber, message: message)
    }
}

// MARK: - LocalizedError

extension PIDError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .commandExecutionFailed(command: command, reason: reason):
            "\(command) command execution failed. \(reason)"
        case .notSupported:
            "Not supported on this platform."
        case .pidDoesNotExist:
            "PID does not exist, or insufficient privileges."
        case let .systemControl(errno, message):
            "\(message) (errno: \(errno))"
        }
    }
}

// MARK: - CustomStringConvertible

extension PIDError: CustomStringConvertible {
    public var description: String {
        errorDescription ?? localizedDescription
    }
}

// MARK: - CustomStringConvertible

extension PIDError: CustomDebugStringConvertible {
    public var debugDescription: String {
        errorDescription ?? localizedDescription
    }
}
