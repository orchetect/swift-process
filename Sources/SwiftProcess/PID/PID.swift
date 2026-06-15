//
//  PID.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Process Identifier.
///
/// This type provides a strongly-typed, lightweight box containing a platform-native raw PID value.
///
/// It also serves as a namespace for sequences, iterators, and related utilities.
///
/// Instance properties and methods offer ways to safely retrieve strongly-typed process information.
///
/// ## Common PIDs
///
/// Static properties are available for special PIDs: ``pid0``, ``pid1``, and ``current``.
///
/// ## Sequences
///
/// All PIDs for processes running in the system can be iterated over lazily with ``InfoSequence``. Convenience
/// static methods are provided including ``all`` and ``all(excluding:)``.
///
/// Ancestor processes of a process can be iterated over lazily using ``AncestorsSequence``. Convenience static
/// methods are provided included ``parent`` and ``ancestors``.
///
/// ## Lookup from Bundle ID
///
/// To lookup process identifiers for a specific bundle ID, first construct a ``BundleID`` instance
/// with the identifier string and then read its ``BundleID/pids`` property.
public struct PID {
    /// Raw PID value.
    @inline(__always) nonisolated
    public let rawValue: RawValue

    @inline(__always)
    nonisolated
    public init(_ pid: RawValue) {
        rawValue = pid
    }
}

extension PID: Equatable { }

extension PID: Hashable { }

extension PID: Sendable { }

// MARK: - RawRepresentable

extension PID: RawRepresentable {
    public typealias RawValue = pid_t

    @inline(__always)
    nonisolated
    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension PID: ExpressibleByIntegerLiteral {
    @inline(__always)
    nonisolated
    public init(integerLiteral value: RawValue) {
        self.init(rawValue: value)
    }
}

// MARK: - CustomStringConvertible

extension PID: CustomStringConvertible {
    @inline(__always)
    public var description: String {
        "\(rawValue)"
    }
}

// MARK: - CustomDebugStringConvertible

extension PID: CustomDebugStringConvertible {
    public var debugDescription: String {
        "PID(\(rawValue))"
    }
}
