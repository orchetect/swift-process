//
//  PID+Collection Tests.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) || targetEnvironment(macCatalyst) || os(Linux)

import Foundation
import SwiftProcess
import Testing

@Suite
struct PID_Collection_Tests {
    /// Provide a process identifier of a live process in the system to test against.
    private func exampleProcess() -> PID? {
        // we can just use the test target's process
        PID(rawValue: ProcessInfo.processInfo.processIdentifier)
    }

    @Test
    func first() {
        guard let pid = exampleProcess() else { return }

        let sequence = PID.AncestorsSequence(
            initialPID: pid,
            isInitialIncluded: true,
            isPID1Included: true
        )

        // ensure first is the correct result
        #expect(sequence.first == pid)
        // ensure it returns the same result each time it's called
        #expect(sequence.first == pid)
        #expect(sequence.first == pid)
    }
}

#endif
