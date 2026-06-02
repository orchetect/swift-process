//
//  PID AncestorsSequence.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) || targetEnvironment(macCatalyst)

extension PID {
    /// Sequence of ancestors of a process.
    public struct AncestorsSequence {
        nonisolated
        public let initialPID: PID

        nonisolated
        public let isInitialIncluded: Bool

        nonisolated
        public let isPID1Included: Bool

        @_disfavoredOverload
        nonisolated
        public init(initialPID: PID, isInitialIncluded: Bool, isPID1Included: Bool) {
            self.initialPID = initialPID
            self.isInitialIncluded = isInitialIncluded
            self.isPID1Included = isPID1Included
        }

        nonisolated
        public init(initialPID: PID.RawValue, isInitialIncluded: Bool, isPID1Included: Bool) {
            self.initialPID = PID(rawValue: initialPID)
            self.isInitialIncluded = isInitialIncluded
            self.isPID1Included = isPID1Included
        }
    }
}

// MARK: - Sequence

extension PID.AncestorsSequence: Sequence {
    nonisolated
    public func makeIterator() -> PID.AncestorsIterator {
        PID.AncestorsIterator(
            pid: initialPID,
            isInitialIncluded: isInitialIncluded,
            isPID1Included: isPID1Included
        )
    }
}

// MARK: - Static Constructors

extension PID {
    /// Returns a sequence of process identifiers for ancestors of the process.
    /// The sequence starts with the immediate parent of this process and in turn continues with its parent, etc.
    nonisolated
    public var ancestors: AncestorsSequence {
        AncestorsSequence(
            initialPID: self,
            isInitialIncluded: false,
            isPID1Included: true
        )
    }

    /// Returns a sequence of process identifiers for ancestors of the process.
    /// The sequence starts with the immediate parent of this process and in turn continues with its parent, etc.
    ///
    /// - Parameters:
    ///   - isInitialIncluded: Include the initial process identifier (`self`) as the first element in the sequence.
    ///   - isPID1Included: Include the PID 1 process in the sequence. If included, this process is always the
    ///     last element in the sequence. If not included, all ancestors up to but not including the PID 1 process
    ///     will be included.
    nonisolated
    public func ancestors(
        isInitialIncluded: Bool = false,
        isPID1Included: Bool = false
    ) -> AncestorsSequence {
        AncestorsSequence(
            initialPID: self,
            isInitialIncluded: isInitialIncluded,
            isPID1Included: isPID1Included
        )
    }
}

#endif
