//
//  FileDescriptorInfoType.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) || targetEnvironment(macCatalyst)

import Foundation

// MARK: - Protocol

protocol FileDescriptorInfoType {
    associatedtype ReadValue
    associatedtype ReturnValue
    var rawValue: Int32 { get }

    func process(readValue: ReadValue) -> ReturnValue?
}

extension FileDescriptorInfoType {
    nonisolated
    func get(fd: Int32, pid: PID) -> ReturnValue? {
        guard let readValue = readValue(fd: fd, pid: pid) else { return nil }
        return process(readValue: readValue)
    }

    nonisolated
    private func readValue(fd: Int32, pid: PID) -> ReadValue? {
        let pid = pid.rawValue
        let fdInfoType = rawValue

        let size = MemoryLayout<ReadValue>.size
        var buffer: ReadValue?
        let isNonEmpty = withUnsafeMutablePointer(to: &buffer) { ptr in
            let byteCount = proc_pidfdinfo(pid, fd, fdInfoType, ptr, Int32(size))
            return byteCount > 0
        }

        guard isNonEmpty else { return nil }
        return buffer
    }
}

// MARK: - Utilities

extension PID {
    /// Internal method to return a FD info value for the process.
    nonisolated
    func fdInfo<T: FileDescriptorInfoType>(type infoType: T, forFD fd: Int32) -> T.ReturnValue? {
        infoType.get(fd: fd, pid: self)
    }
}

#endif
