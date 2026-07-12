//
//  Sequence+FileDescriptorInfo.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Sequence<FileDescriptorInfo> {
    nonisolated
    public func contains(whereVNodePath predicate: (_ path: String) -> Bool) -> Bool {
        contains {
            guard case let .vNode(fd: _, path: path) = $0 else { return false }
            return predicate(path)
        }
    }

    nonisolated
    public func filter(whereVNodePath predicate: @escaping (_ path: String) -> Bool) -> LazyFilterSequence<Self> {
        lazy.filter { [predicate] in
            guard case let .vNode(fd: _, path: path) = $0 else { return false }
            return predicate(path)
        }
    }
}
