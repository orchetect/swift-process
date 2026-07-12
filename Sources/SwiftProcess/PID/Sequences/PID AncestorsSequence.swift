//
//  PID AncestorsSequence.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) || targetEnvironment(macCatalyst)

extension PID {
    /// Sequence of ancestors of a process.
    ///
    /// > Note: Process info lookup is only available on macOS and Mac Catalyst.
    /// > On all other platforms, this type has undefined behavior.
    @available(macOS 10.15, macCatalyst 13, *)
    @available(iOS, deprecated, message: "Not available on iOS.")
    @available(tvOS, deprecated, message: "Not available on tvOS.")
    @available(watchOS, deprecated, message: "Not available on watchOS.")
    @available(visionOS, deprecated, message: "Not available on visionOS.")
    public struct AncestorsSequence {
        nonisolated
        public let initialPID: PID

        nonisolated
        public let isInitialIncluded: Bool

        nonisolated
        public let isPID0Included: Bool

        nonisolated
        public let isPID1Included: Bool

        @_disfavoredOverload
        nonisolated
        public init(initialPID: PID, isInitialIncluded: Bool, isPID0Included: Bool, isPID1Included: Bool) {
            self.initialPID = initialPID
            self.isInitialIncluded = isInitialIncluded
            self.isPID0Included = isPID0Included
            self.isPID1Included = isPID1Included
        }

        nonisolated
        public init(initialPID: PID.RawValue, isInitialIncluded: Bool, isPID0Included: Bool, isPID1Included: Bool) {
            self.initialPID = PID(rawValue: initialPID)
            self.isInitialIncluded = isInitialIncluded
            self.isPID0Included = isPID0Included
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
            isPID0Included: isPID0Included,
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
            isPID0Included: true,
            isPID1Included: true
        )
    }

    /// Returns a sequence of process identifiers for ancestors of the process.
    /// The sequence starts with the immediate parent of this process and in turn continues with its parent, etc.
    ///
    /// - Parameters:
    ///   - isInitialIncluded: Include the initial process identifier (`self`) as the first element in the sequence.
    ///   - isPID0Included: Allow the PID 0 process to be included in the sequence.
    ///   - isPID1Included: Allow the PID 1 process to be included in the sequence.
    nonisolated
    public func ancestors(
        isInitialIncluded: Bool = false,
        isPID0Included: Bool = false,
        isPID1Included: Bool = false
    ) -> AncestorsSequence {
        AncestorsSequence(
            initialPID: self,
            isInitialIncluded: isInitialIncluded,
            isPID0Included: isPID0Included,
            isPID1Included: isPID1Included
        )
    }
}

#endif
