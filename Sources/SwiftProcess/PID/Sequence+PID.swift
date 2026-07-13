//
//  Sequence+PID.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

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

    /// Returns a Boolean value indicating whether the sequence contains PIDs that have VNode file descriptors
    /// matching the given path predicate.
    nonisolated
    public func contains(whereFileDescriptorVNodePath predicate: @escaping (_ path: String) -> Bool) -> LazyFilterSequence<Self> {
        lazy.filter {
            $0.fileDescriptors.contains(whereVNodePath: predicate)
        }
    }

    /// Returns a lazy filter sequence of PIDs that have VNode file descriptors matching the given path predicate.
    nonisolated
    public func filter(whereFileDescriptorVNodePath predicate: @escaping (_ path: String) -> Bool) -> LazyFilterSequence<Self> {
        lazy.filter {
            $0.fileDescriptors.contains(whereVNodePath: predicate)
        }
    }

    /// Filters the collection to only PIDs that have VNode file descriptors matching the given path predicate,
    /// returning a dictionary keyed by PID with an array value of matching paths.
    nonisolated
    public func fileDescriptorVNodePaths(whereVNodePath predicate: @escaping (_ path: String) -> Bool) -> [PID: [String]] {
        lazy.reduce(into: [:]) { dict, pid in
            let paths: [String] = pid.fileDescriptors.compactMap {
                guard case let .vNode(fd: _, path: path) = $0 else { return nil }
                guard predicate(path) else { return nil }
                return path
            }
            if !paths.isEmpty { dict[pid] = paths }
        }
    }

    /// Filters the collection to only PIDs that have file/port descriptor names as returned by the `lsof` command
    /// matching the given path predicate, returning a dictionary keyed by PID with an array value of matching paths.
    /// This typically contains a more thorough list of descriptors than calling ``fileDescriptors`` or ``filePorts``.
    /// 
    /// > Note: File descriptor lookup is only available on macOS (not including Mac Catalyst).
    /// > On all other platforms, this property always throws an error.
    @available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *)
    nonisolated
    public func lsofPaths(whereName predicate: @escaping (_ name: String) -> Bool) throws(PID.SystemError) -> [PID: [String]] {
        var dict: [PID: [String]] = [:]
        for pid in self {
            let paths: [String] = try pid.lsofDescriptors()
                .filter { predicate($0) }
            if !paths.isEmpty { dict[pid] = paths }
        }
        return dict
    }

    /// Filters the collection to only PIDs that have file/port descriptor names as returned by the `lsof` command
    /// matching the given path predicate, returning a dictionary keyed by PID with an array value of matching paths.
    /// This typically contains a more thorough list of descriptors than calling ``fileDescriptors`` or ``filePorts``.
    ///
    /// > Note: File descriptor lookup is only available on macOS (not including Mac Catalyst).
    /// > On all other platforms, this property always throws an error.
    @available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *)
    @concurrent
    public func lsofPaths(whereName predicate: @escaping (_ name: String) -> Bool) async throws(PID.SystemError) -> [PID: [String]] {
        var dict: [PID: [String]] = [:]
        for pid in self {
            let paths: [String] = try await pid.lsofDescriptors()
                .filter { predicate($0) }
            if !paths.isEmpty { dict[pid] = paths }
        }
        return dict
    }
}
