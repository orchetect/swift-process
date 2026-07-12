//
//  PipeFileDescriptorInfoType.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) || targetEnvironment(macCatalyst)

import Foundation

struct PipeFileDescriptorInfoType: FileDescriptorInfoType {
    let rawValue: Int32 = PROC_PIDFDPIPEINFO

    nonisolated
    func process(readValue: pipe_fdinfo) -> pipe_info? {
        readValue.pipeinfo
    }
}

extension FileDescriptorInfoType where Self == PipeFileDescriptorInfoType {
    nonisolated
    static var pipeInfo: Self { Self() }
}

#endif
