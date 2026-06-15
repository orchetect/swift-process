//
//  PID InfoSequence.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

extension PID {
    /// Iterate over raw info for all processes in the system lazily.
    public typealias InfoSequence<Element> = IteratorSequence<InfoIterator<Element>>
}
