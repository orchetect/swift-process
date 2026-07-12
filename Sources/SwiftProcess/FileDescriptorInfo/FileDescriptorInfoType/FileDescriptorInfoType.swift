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
    func readValue(fd: Int32, pid: PID) -> ReadValue? {
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

#endif
