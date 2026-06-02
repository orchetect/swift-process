//
//  PID AncestorsSequence Tests.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) || targetEnvironment(macCatalyst)

import Foundation
import SwiftProcess
import Testing

@Suite
struct PID_AncestorsSequence_Tests {
    /// Provide a process identifier of a live process in the system to test against.
    private func exampleProcess() throws -> PID? {
        #if os(macOS)
        try PID.all
            .first(where: { $0.name == "Finder" })
        #else
        PID.current
        #endif
    }

    @Test
    func withInitial_withPID1() throws {
        guard let pid = try exampleProcess() else { return }

        let iterator = PID.AncestorsSequence(
            initialPID: pid,
            isInitialIncluded: true,
            isPID1Included: true
        )

        let pids = Array(iterator)

        // minimum number of PIDs is 2 (initial and PID 1)
        #expect(pids.count >= 2)
        #expect(pids.first == pid)
        #expect(pids.last == .pid1)
    }

    @Test
    func withInitial_withoutPID1() throws {
        guard let pid = try exampleProcess() else { return }

        let iterator = PID.AncestorsSequence(
            initialPID: pid,
            isInitialIncluded: true,
            isPID1Included: false
        )

        let pids = Array(iterator)

        // minimum number of PIDs is 1 (initial)
        #expect(pids.count >= 1)
        #expect(pids.first == pid)
    }

    @Test
    func withoutInitial_withPID1() throws {
        guard let pid = try exampleProcess() else { return }

        let iterator = PID.AncestorsSequence(
            initialPID: pid,
            isInitialIncluded: false,
            isPID1Included: true
        )

        let pids = Array(iterator)

        // minimum number of PIDs is 1 (PID 1)
        #expect(pids.count >= 1)
        #expect(pids.last == .pid1)
    }

    @Test
    func withoutInitial_withoutPID1() throws {
        guard let pid = try exampleProcess() else { return }

        let iterator = PID.AncestorsSequence(
            initialPID: pid,
            isInitialIncluded: false,
            isPID1Included: false
        )

        let pids = Array(iterator)

        // minimum number of PIDs is 0
        // (if initial PID has PID 1 as its parent, then both are omitted and no PIDs are returned)
        #expect(pids.count >= 0)
    }
}
#endif
