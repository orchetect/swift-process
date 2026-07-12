//
//  Collection+PID Tests.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftProcess
import Testing

@Suite
struct Collection_PID_Tests {
    /// Provide a process identifier of a live process in the system to test against.
    private func exampleProcess() -> PID? {
        // we can just use the test target's process
        PID(ProcessInfo.processInfo.processIdentifier)
    }

    @Test
    func first_dummyPIDs() {
        let sequence: [PID] = [PID(123), PID(456), PID(789)]

        // ensure first is the correct result
        #expect(sequence.first == PID(123))
        // ensure it returns the same result each time it's called
        #expect(sequence.first == PID(123))
        #expect(sequence.first == PID(123))
    }

    #if os(macOS) || targetEnvironment(macCatalyst)
    @Test
    func first_RealPIDs() {
        guard let pid = exampleProcess() else { return }

        let sequence = PID.AncestorsSequence(
            initialPID: pid,
            isInitialIncluded: true,
            isPID0Included: true,
            isPID1Included: true
        )

        // ensure first is the correct result
        #expect(sequence.first == pid)
        // ensure it returns the same result each time it's called
        #expect(sequence.first == pid)
        #expect(sequence.first == pid)
    }
    #endif

    @Test
    func contains_dummyPIDs() {
        let sequence: [PID] = [PID(123), PID(456), PID(789)]

        #expect(sequence.contains(PID(123)))
        #expect(sequence.contains(PID(456)))
        #expect(!sequence.contains(PID(100)))
    }
}
