//
//  VNodeFileDescriptorInfoType.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) || targetEnvironment(macCatalyst)

import Foundation

struct VNodeFileDescriptorInfoType: FileDescriptorInfoType {
    let rawValue: Int32 = PROC_PIDFDVNODEPATHINFO

    nonisolated
    func process(readValue: vnode_fdinfowithpath) -> String? {
        withUnsafeBytes(of: readValue.pvip.vip_path) { rawPtr in
            let ptr = rawPtr.baseAddress!.assumingMemoryBound(to: CChar.self)
            return String(cString: ptr)
        }
    }
}

extension FileDescriptorInfoType where Self == VNodeFileDescriptorInfoType {
    nonisolated
    static var vNodeInfo: Self {
        Self()
    }
}

#endif
