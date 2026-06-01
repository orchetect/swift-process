//
//  PID InfoIterator.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) || targetEnvironment(macCatalyst) || os(Linux)

import Foundation

extension PID {
    /// Iterate over raw info for all processes in the system lazily.
    public class InfoIterator<Element> {
        // MARK: Typealiases

        /// Closure used to transform process info for each process into a return value or error.
        ///
        /// The return value of this closure allows for opaquely compact-mapping elements.
        /// Returning a non-`nil` value emits the value to the consumer, whereas returning `nil` discards
        /// the value from the iterator sequence.
        public typealias ElementTransform = (_ processInfo: kinfo_proc) -> Element?

        // MARK: Parameters

        nonisolated
        private let elementTransform: ElementTransform

        // MARK: State

        private let processCount: Int
        private var processList: UnsafeMutablePointer<kinfo_proc>
        private var currentIndex: Int = 0

        // MARK: Init

        /// Returns the raw PID value for each process.
        nonisolated
        public init(
            memoryInformationBase: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_ALL]
        ) throws(SystemError) where Element == PID.RawValue {
            elementTransform = { $0.kp_proc.p_pid }
            (processList, processCount) = try Self._pidList(mib: memoryInformationBase)
        }

        /// Allows transforming the process info to return a custom value type for each process.
        nonisolated
        public init(
            memoryInformationBase: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_ALL],
            elementTransform: @escaping ElementTransform
        ) throws(SystemError) {
            self.elementTransform = elementTransform
            (processList, processCount) = try Self._pidList(mib: memoryInformationBase)
        }

        deinit {
            processList.deallocate()
        }
    }
}

// MARK: - IteratorProtocol

extension PID.InfoIterator: IteratorProtocol {
    nonisolated
    public func next() -> Element? {
        while currentIndex < processCount {
            defer { currentIndex += 1 }
            let processInfo = processList[currentIndex]
            if let value = elementTransform(processInfo) { return value }
        }
        return nil
    }
}

// MARK: - Data

extension PID.InfoIterator {
    /// Returns a pointer to an allocated array of `kinfo_proc` instances in memory.
    /// The pointer returned must not escape the scope of the class, and must be deallocated on class deinit.
    ///
    /// - See Also: https://gaitatzis.medium.com/listing-running-system-processes-using-swift-43e24c20789c
    /// - See Also: https://stackoverflow.com/a/62801035/2805570
    nonisolated
    private static func _pidList(mib: [Int32]) throws(PID.SystemError) -> (pointer: UnsafeMutablePointer<kinfo_proc>, count: Int) {
        var memoryInformationBase = mib
        let mibCount = memoryInformationBase.count

        var bufferSize = 0
        let bufferSizeResult = sysctl(
            &memoryInformationBase,
            UInt32(mibCount),
            nil,
            &bufferSize,
            nil,
            0
        )
        if bufferSizeResult < 0 {
            throw .init(errno: &errno)
        }

        let entryCount = bufferSize / MemoryLayout<kinfo_proc>.stride
        let processList: UnsafeMutablePointer<kinfo_proc> = .allocate(capacity: entryCount)

        let populateProcessListResult = sysctl(
            &memoryInformationBase,
            UInt32(memoryInformationBase.count),
            processList,
            &bufferSize,
            nil,
            0
        )
        if populateProcessListResult < 0 {
            throw .init(errno: &errno)
        }

        return (pointer: processList, count: entryCount)
    }
}

#endif
