//
//  SocketFileDescriptorInfoType.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) || targetEnvironment(macCatalyst)

import Foundation

struct SocketFileDescriptorInfoType: FileDescriptorInfoType {
    let rawValue: Int32 = PROC_PIDFDSOCKETINFO

    nonisolated
    func process(readValue: socket_fdinfo) -> socket_info? {
        readValue.psi
    }
}

extension FileDescriptorInfoType where Self == SocketFileDescriptorInfoType {
    nonisolated
    static var socketInfo: Self {
        Self()
    }
}

#endif
