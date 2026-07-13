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
}
