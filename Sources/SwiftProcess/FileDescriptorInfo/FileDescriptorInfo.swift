//
//  FileDescriptorInfo.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation

public enum FileDescriptorInfo {
    #if os(macOS) || targetEnvironment(macCatalyst)
    case appleTalk(fd: Int32) // TODO: Implement info
    case channel(fd: Int32) // TODO: Implement info
    case fsEvents(fd: Int32, pipeInfo: kqueue_info)
    case kqueue(fd: Int32) // TODO: Implement info
    case netPolicy(fd: Int32) // TODO: Implement info
    case nexus(fd: Int32) // TODO: Implement info
    case pipe(fd: Int32, pipeInfo: pipe_info)
    case psem(fd: Int32) // TODO: Implement info
    case pshm(fd: Int32) // TODO: Implement info
    case socket(fd: Int32, socketInfo: socket_info)
    #endif

    case vNode(fd: Int32, path: String)
}

extension FileDescriptorInfo: Sendable { }

extension FileDescriptorInfo {
    /// Proxy property to return the `fd` associated value.
    nonisolated
    public var fd: Int32 {
        switch self {
        #if os(macOS) || targetEnvironment(macCatalyst)
        case let .appleTalk(fd: fd): fd
        case let .channel(fd: fd): fd
        case let .fsEvents(fd: fd, pipeInfo: _): fd
        case let .kqueue(fd: fd): fd
        case let .netPolicy(fd: fd): fd
        case let .nexus(fd: fd): fd
        case let .pipe(fd: fd, pipeInfo: _): fd
        case let .psem(fd: fd): fd
        case let .pshm(fd: fd): fd
        case let .socket(fd: fd, socketInfo: _): fd
        #endif

        case let .vNode(fd: fd, path: _): fd
        }
    }

    nonisolated
    public var flavor: FileDescriptorFlavor {
        switch self {
        #if os(macOS) || targetEnvironment(macCatalyst)
        case .appleTalk: .appleTalk
        case .channel: .channel
        case .fsEvents: .fsEvents
        case .kqueue: .kqueue
        case .netPolicy: .netPolicy
        case .nexus: .nexus
        case .pipe: .pipe
        case .psem: .psem
        case .pshm: .pshm
        case .socket: .socket
        #endif

        case .vNode: .vNode
        }
    }
}

#if os(macOS) || targetEnvironment(macCatalyst)

extension FileDescriptorInfo {
    nonisolated
    public init?(fdInfo: proc_fdinfo, pid: PID) {
        let fd = fdInfo.proc_fd

        guard let fdTypeInt32 = Int32(exactly: fdInfo.proc_fdtype),
              let fileDescriptorFlavor = FileDescriptorFlavor(rawValue: fdTypeInt32)
        else {
            assertionFailure("Unhandled file descriptor flavor with raw value: \(fdInfo.proc_fdtype)")
            return nil
        }

        switch fileDescriptorFlavor {
        case .appleTalk:
            self = .appleTalk(fd: fd) // TODO: implement info

        case .channel:
            self = .channel(fd: fd) // TODO: implement info

        case .fsEvents:
            guard let pipeInfo = pid.fdInfo(type: .fsEventsInfo, forFD: fd) else { return nil }
            self = .fsEvents(fd: fd, pipeInfo: pipeInfo)

        case .kqueue:
            self = .kqueue(fd: fd) // TODO: implement info

        case .netPolicy:
            self = .netPolicy(fd: fd) // TODO: implement info

        case .nexus:
            self = .nexus(fd: fd) // TODO: implement info

        case .pipe:
            guard let pipeInfo = pid.fdInfo(type: .pipeInfo, forFD: fd) else { return nil }
            self = .pipe(fd: fd, pipeInfo: pipeInfo)

        case .psem:
            self = .psem(fd: fd) // TODO: implement info

        case .pshm:
            self = .pshm(fd: fd) // TODO: implement info

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
