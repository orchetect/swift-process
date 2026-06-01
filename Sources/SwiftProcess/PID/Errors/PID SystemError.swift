//
//  PID SystemError.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) || targetEnvironment(macCatalyst) || os(Linux)

import protocol Foundation.LocalizedError
import func Foundation.perror

extension PID {
    /// Errors thrown by ``PID`` methods that call system functions.
    public struct SystemError {
        /// Error number.
        public let errno: Int32

        /// Error message.
        public let message: String

        /// Construct a new instance by populating its properties.
        public init(errno: Int32, message: String) {
            self.errno = errno
            self.message = message
        }
    }
}

extension PID.SystemError: Equatable { }

extension PID.SystemError: Hashable { }

extension PID.SystemError: Sendable { }

// MARK: - Inits

extension PID.SystemError {
    /// Initialize from an immutable error number.
    /// The error message will be populated automatically.
    public init(errno errorNumber: Int32) {
        var errorNumber = errorNumber
        self.init(errno: &errorNumber)
    }

    /// Initialize from a mutable error number.
    /// The error message will be populated automatically.
    public init(errno errorNumber: inout Int32) {
        errno = errorNumber

        // capture error to a String variable
        var errorMessage = String()
        dump(perror(&errorNumber), to: &errorMessage)
        message = errorMessage
    }
}

// MARK: - LocalizedError

extension PID.SystemError: LocalizedError {
    public var errorDescription: String? {
        "\(message) (errno: \(errno))"
    }
}

#endif
