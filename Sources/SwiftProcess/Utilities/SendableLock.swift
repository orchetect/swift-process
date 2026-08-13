//
//  SendableLock.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

final class SendableLock<T>: Sendable {
    nonisolated
    var value: T {
        get {
            lock.withLock { _value }
        }
        _modify {
            lock.lock()
            defer { lock.unlock() }
            yield &_value
        }
        set {
            lock.withLock { _value = newValue }
        }
    }

    nonisolated(unsafe)
    private var _value: T

    nonisolated
    let lock = NSLock()

    nonisolated
    init(_ initialValue: T) {
        _value = initialValue
    }
}

#endif
