//
//  BundleID.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

/// Bundle identifier.
///
/// This type provides a strongly-typed, lightweight box containing a bundle identifier.
///
/// # Lookup from PID
///
/// To lookup the bundle identifier for a specific process, first construct a ``PID`` instance with
/// the pid value and then read its ``PID/bundleID`` property.
public struct BundleID {
    @inline(__always) nonisolated
    public let rawValue: String

    /// Construct a new instance from a bundle identifier string.
    @inline(__always)
    nonisolated
    public init(_ identifier: String) {
        self.init(rawValue: identifier)
    }

    /// Construct a new instance from a bundle identifier string.
    @inline(__always) @_disfavoredOverload
    nonisolated
    public init(_ identifier: some StringProtocol) {
        self.init(rawValue: String(identifier))
    }
}

extension BundleID: Equatable { }

extension BundleID: Comparable {
    public static func < (lhs: BundleID, rhs: BundleID) -> Bool {
        // use default string comparison, not localized
        lhs.rawValue < rhs.rawValue
    }
}

extension BundleID: Hashable { }

extension BundleID: Sendable { }

// MARK: - RawRepresentable

extension BundleID: RawRepresentable {
    /// Construct a new instance from a bundle identifier string.
    @inline(__always)
    nonisolated
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension BundleID: ExpressibleByStringLiteral {
    @inline(__always) @_disfavoredOverload
    nonisolated
    public init(stringLiteral: StaticString) {
        self.init(rawValue: stringLiteral.description)
    }
}

// MARK: - CustomStringConvertible

extension BundleID: CustomStringConvertible {
    @inline(__always)
    public var description: String {
        rawValue
    }
}

// MARK: - CustomDebugStringConvertible

extension BundleID: CustomDebugStringConvertible {
    public var debugDescription: String {
        "BundleID(\(rawValue))"
    }
}
