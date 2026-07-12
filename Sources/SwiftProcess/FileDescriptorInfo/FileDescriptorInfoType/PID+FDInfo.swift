//
//  PID+FDInfo.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) || targetEnvironment(macCatalyst)

import Foundation

extension PID {
    /// Internal method to return a FD info value for the process.
    func fdInfo<T: FileDescriptorInfoType>(type infoType: T, forFD fd: Int32) -> T.ReturnValue? {
        guard let readValue = infoType.readValue(fd: fd, pid: self) else { return nil }
        return infoType.process(readValue: readValue)
    }
}

#endif
