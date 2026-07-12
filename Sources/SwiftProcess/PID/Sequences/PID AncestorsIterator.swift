//
//  PID AncestorsIterator.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) || targetEnvironment(macCatalyst)

extension PID {
    /// Iterate over ancestors of a process.
    ///
    /// > Note: Process info lookup is only available on macOS and Mac Catalyst.
    /// > On all other platforms, this type has undefined behavior.
    @available(macOS 10.15, macCatalyst 13, *)
    @available(iOS, deprecated, message: "Not available on iOS.")
    @available(tvOS, deprecated, message: "Not available on tvOS.")
    @available(watchOS, deprecated, message: "Not available on watchOS.")
    @available(visionOS, deprecated, message: "Not available on visionOS.")
    public struct AncestorsIterator {
        // MARK: Parameters

        nonisolated
        public let initialPID: PID

        nonisolated
        public let isPID1Included: Bool

        // MARK: State

        var isInitialConsumed: Bool

        var currentPID: PID?

        // MARK: Init

        nonisolated
        public init(pid: PID, isInitialIncluded: Bool, isPID1Included: Bool) {
            // parameters
            initialPID = pid
            self.isPID1Included = isPID1Included

            // initial state
            isInitialConsumed = !isInitialIncluded
            currentPID = initialPID
        }
    }
}

// MARK: - IteratorProtocol

extension PID.AncestorsIterator: IteratorProtocol {
    nonisolated
    public mutating func next() -> PID? {
        currentPID = nextProposedPID()

        if let _currentPID = currentPID, _currentPID == .pid1 {
            if !isPID1Included { currentPID = nil }
        }

        guard let currentPID else { return nil }

        return currentPID
    }

    nonisolated
    private mutating func nextProposedPID() -> PID? {
        if !isInitialConsumed {
            isInitialConsumed = true
            return initialPID
        } else {
            guard let currentPID else { return nil }
            return currentPID.parent
        }
    }
}

#endif
