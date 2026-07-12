//
//  PID FileDescriptor.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension PID {
    public enum FileDescriptor {
        #if os(macOS) || targetEnvironment(macCatalyst)
        case socket(fd: Int32, socketInfo: socket_info)
        #endif

        case vNode(fd: Int32, path: String)
    }
}

extension PID.FileDescriptor: Sendable { }

extension PID.FileDescriptor {
    public var fd: Int32 {
        switch self {
        #if os(macOS) || targetEnvironment(macCatalyst)
        case let .socket(fd: fd, socketInfo: _): fd
        #endif
            
        case let .vNode(fd: fd, path: _): fd
        }
    }
}

#if os(macOS) || targetEnvironment(macCatalyst)

extension PID.FileDescriptor {
    public init?(fdInfo: proc_fdinfo, pid: PID) {
        self.init(fdInfo: fdInfo, pid: pid.rawValue)
    }

    public init?(fdInfo: proc_fdinfo, pid: PID.RawValue) {
        let fd = fdInfo.proc_fd

        guard let fdTypeInt32 = Int32(exactly: fdInfo.proc_fdtype),
              let fdType = FDType(rawValue: fdTypeInt32)
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
            return nil // TODO: implement
        case .psem:
            return nil // TODO: implement
        case .pshm:
            return nil // TODO: implement
        case .socket:
            var socketInfo = socket_fdinfo()
            let want = Int32(MemoryLayout<socket_fdinfo>.size)
            let byteCount = withUnsafeMutablePointer(to: &socketInfo) { ptr -> Int32 in
                proc_pidfdinfo(pid, fd, PROC_PIDFDSOCKETINFO, ptr, want)
            }
            // check for the fixed-size socket_info size as a minimum
            guard byteCount >= MemoryLayout<socket_info>.size else { return nil }

            let psi = socketInfo.psi
            self = .socket(fd: fd, socketInfo: psi)

        case .vNode:
            var vnodeInfo = vnode_fdinfowithpath()
            let vnodeInfoSize = Int32(MemoryLayout<vnode_fdinfowithpath>.size)
            let byteCount = proc_pidfdinfo(pid, fd, PROC_PIDFDVNODEPATHINFO, &vnodeInfo, vnodeInfoSize)
            guard byteCount > 0 else { return nil }

            let path = withUnsafeBytes(of: vnodeInfo.pvip.vip_path) { rawPtr in
                let ptr = rawPtr.baseAddress!.assumingMemoryBound(to: CChar.self)
                return String(cString: ptr)
            }
            self = .vNode(fd: fd, path: path)
        }
    }
}

#endif
