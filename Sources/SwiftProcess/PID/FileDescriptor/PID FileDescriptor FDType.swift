//
//  PID FileDescriptor FDType.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension PID.FileDescriptor {
    public enum FDType {
        case appleTalk
        case channel
        case fsEvents
        case kqueue
        case netPolicy
        case nexus
        case pipe
        case psem
        case pshm
        case socket
        case vNode
    }
}

extension PID.FileDescriptor.FDType: Equatable { }

extension PID.FileDescriptor.FDType: Hashable { }

extension PID.FileDescriptor.FDType: Sendable { }

extension PID.FileDescriptor.FDType: CaseIterable { }

#if os(macOS) || targetEnvironment(macCatalyst)

extension PID.FileDescriptor.FDType: RawRepresentable {
    public init?(rawValue: Int32) {
        guard let match = Self.allCases.first(where: { $0.rawValue == rawValue }) else {
            return nil
        }
        self = match
    }

    public var rawValue: Int32 {
        switch self {
        case .appleTalk: PROX_FDTYPE_ATALK
        case .channel: PROX_FDTYPE_CHANNEL
        case .fsEvents: PROX_FDTYPE_FSEVENTS
        case .kqueue: PROX_FDTYPE_KQUEUE
        case .netPolicy: PROX_FDTYPE_NETPOLICY
        case .nexus: PROX_FDTYPE_NEXUS
        case .pipe: PROX_FDTYPE_PIPE
        case .psem: PROX_FDTYPE_PSEM
        case .pshm: PROX_FDTYPE_PSHM
        case .socket: PROX_FDTYPE_SOCKET
        case .vNode: PROX_FDTYPE_VNODE
        }
    }
}

#endif
