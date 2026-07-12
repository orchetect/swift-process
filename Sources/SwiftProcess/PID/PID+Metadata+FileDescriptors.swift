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
        let bufferByteCount = proc_pidinfo(rawValue, PROC_PIDLISTFDS, 0, nil, 0)
        guard bufferByteCount > 0 else { return [] }

        // the buffer is typically sized larger than the number of `proc_fdinfo` elements
        // that proc_pidinfo() actually ends up returning for PROC_PIDLISTFDS.
        let stride = MemoryLayout<proc_fdinfo>.stride
        let maximumPossibleCount = Int(bufferByteCount) / stride
        let fds = Array<proc_fdinfo>(unsafeUninitializedCapacity: maximumPossibleCount) { buffer, initializedCount in
            let initializedByteCount = proc_pidinfo(rawValue, PROC_PIDLISTFDS, 0, buffer.baseAddress!, bufferByteCount)
            assert(Int(initializedByteCount).isMultiple(of: stride))
            // this actual count is often less than the "maximum possible" count (original buffer size)
            let actualCount = Int(initializedByteCount) / stride
            initializedCount = actualCount
        }

        let fileDescriptors = fds.compactMap { FileDescriptorInfo(fdInfo: $0, pid: self) }

        return fileDescriptors
        #else
        return []
        #endif
    }
}

// MARK: - Utilities

#if os(macOS) || targetEnvironment(macCatalyst)

extension PID {
    /// Internal method to return a FD info value for the process.
    func fdInfo<T: FileDescriptorInfoType>(type infoType: T, forFD fd: Int32) -> T.ReturnValue? {
        infoType.get(fd: fd, pid: self)
    }
}

#endif
