//
//  FSEventsFileDescriptorInfoType.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) || targetEnvironment(macCatalyst)

import Foundation

struct FSEventsFileDescriptorInfoType: FileDescriptorInfoType {
    let rawValue: Int32 = PROC_PIDFDKQUEUEINFO

    func process(readValue: kqueue_fdinfo) -> kqueue_info? {
        readValue.kqueueinfo
    }
}

extension FileDescriptorInfoType where Self == FSEventsFileDescriptorInfoType {
    static var fsEventsInfo: Self { Self() }
}

#endif
