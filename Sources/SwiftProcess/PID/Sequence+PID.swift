//
//  Sequence+PID.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation

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

    /// Returns the `lsof` command file and port descriptors by gathering them concurrently
    /// and emitted them as an async sequence.
    @available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *)
    public func lsofDescriptorsSequence(
        maxConcurrentTasks: Int? = nil
    ) -> AsyncStream<(PID, Result<[String], PID.SystemError>)> where Self: Sendable {
        let array = Array(self)
        let maxConcurrentChildTasks = Swift.max(1, (maxConcurrentTasks ?? array.count))

        return AsyncStream { continuation in
            guard !array.isEmpty else {
                continuation.finish()
                return
            }
            
            let task = Task { @concurrent in
                await withTaskGroup(of: (PID, Result<[String], PID.SystemError>).self) { group in
                    var submittedChildTaskCount = 0

                    func getResult(for pid: PID) async -> (PID, Result<[String], PID.SystemError>) {
                        do throws(PID.SystemError) {
                            let descriptors = try await pid.lsofDescriptors()
                            return (pid, .success(descriptors))
                        } catch {
                            return (pid, .failure(error))
                        }
                    }

                    for _ in 0 ..< maxConcurrentChildTasks {
                        let pid = array[submittedChildTaskCount]
                        group.addTaskUnlessCancelled {
                            await getResult(for: pid)
                        }
                        submittedChildTaskCount += 1
                    }

                    for await result in group {
                        continuation.yield(result)

                        // Every time we get a result back, check if there's more work we should submit and do so
                        if submittedChildTaskCount < array.count {
                            let pid = array[submittedChildTaskCount]
                            group.addTaskUnlessCancelled {
                                await getResult(for: pid)
                            }
                            submittedChildTaskCount += 1
                        }
                    }

                    continuation.finish()
                }
            }

            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
