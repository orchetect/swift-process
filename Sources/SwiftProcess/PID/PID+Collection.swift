//
//  PID+Collection.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) || targetEnvironment(macCatalyst) || os(Linux)

extension Sequence<PID> {
    /// Returns the first element in the sequence.
    nonisolated
    public var first: PID? {
        first(where: { _ in true })
    }

    /// Returns a Boolean value indicating whether the sequence contains a process with the specified raw PID.
    @_disfavoredOverload
    nonisolated
    public func contains(pid rawPID: PID.RawValue) -> Bool {
        contains { $0.rawValue == rawPID }
    }
}

#endif
