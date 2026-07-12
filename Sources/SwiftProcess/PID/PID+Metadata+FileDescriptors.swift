//
//  PID+Metadata+FileDescriptors.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension PID {
    /// Returns a list of open file and port descriptors for the process.
    /// If the process is no longer running or an error occurred, an empty collection is returned.
    ///
    /// > Note: File descriptor lookup is only available on macOS (not including Mac Catalyst).
    /// > On all other platforms, this property always returns an empty collection.
    nonisolated
    public var fileDescriptors: [FileDescriptorInfo] {
        #if os(macOS) || targetEnvironment(macCatalyst)
        let bufferSize = proc_pidinfo(rawValue, PROC_PIDLISTFDS, 0, nil, 0)

        guard bufferSize > 0 else { return [] }

        let stride = MemoryLayout<proc_fdinfo>.stride
        let fdCount = Int(bufferSize) / stride
        let allFDs = Array<proc_fdinfo>(unsafeUninitializedCapacity: fdCount) { buffer, initializedCount in
            let initializedByteCount = proc_pidinfo(rawValue, PROC_PIDLISTFDS, 0, buffer.baseAddress!, bufferSize)
            assert(Int(initializedByteCount).isMultiple(of: stride))
            initializedCount = Int(initializedByteCount) / stride
        }

        let fileDescriptors = allFDs.compactMap { FileDescriptorInfo(fdInfo: $0, pid: self) }

        return fileDescriptors
        #else
        return []
        #endif
    }
}
