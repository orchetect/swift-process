//
//  FileDescriptorInfo.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation

public enum FileDescriptorInfo {
    #if os(macOS) || targetEnvironment(macCatalyst)
    case pipe(fd: Int32, pipeInfo: pipe_info)
    case socket(fd: Int32, socketInfo: socket_info)
    #endif

    case vNode(fd: Int32, path: String)
}

extension FileDescriptorInfo: Sendable { }

extension FileDescriptorInfo {
    public var fd: Int32 {
        switch self {
        #if os(macOS) || targetEnvironment(macCatalyst)
        case let .pipe(fd: fd, pipeInfo: _): fd
        case let .socket(fd: fd, socketInfo: _): fd
        #endif
            
        case let .vNode(fd: fd, path: _): fd
        }
    }
}

#if os(macOS) || targetEnvironment(macCatalyst)

extension FileDescriptorInfo {
    public init?(fdInfo: proc_fdinfo, pid: PID) {
        let fd = fdInfo.proc_fd

        guard let fdTypeInt32 = Int32(exactly: fdInfo.proc_fdtype),
              let fdType = FileDescriptorType(rawValue: fdTypeInt32)
        else { return nil }

        switch fdType {
        case .appleTalk:
            return nil // TODO: implement

        case .channel:
            return nil // TODO: implement

        case .fsEvents:
            return nil // TODO: implement

        case .kqueue:
            return nil // TODO: implement

        case .netPolicy:
            return nil // TODO: implement

        case .nexus:
            return nil // TODO: implement

        case .pipe:
            guard let pipeInfo = pid.fdInfo(type: .pipeInfo, forFD: fd) else { return nil }
            self = .pipe(fd: fd, pipeInfo: pipeInfo)

        case .psem:
            return nil // TODO: implement

        case .pshm:
            return nil // TODO: implement

        case .socket:
            guard let socketInfo = pid.fdInfo(type: .socketInfo, forFD: fd) else { return nil }
            self = .socket(fd: fd, socketInfo: socketInfo)

        case .vNode:
            guard let path = pid.fdInfo(type: .vNodeInfo, forFD: fd) else { return nil }
            self = .vNode(fd: fd, path: path)
        }
    }
}

#endif
