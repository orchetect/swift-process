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
            .first(where: { $0.name == "Finder" && $0.bundleID == BundleID("com.apple.finder") })
        #else
        PID(ProcessInfo.processInfo.processIdentifier)
        #endif
    }

    @Test
    func withInitial_withPID1AndPID0() throws {
        guard let pid = try exampleProcess() else { return }

        let iterator = PID.AncestorsSequence(
            initialPID: pid,
            isInitialIncluded: true,
            isPID0Included: true,
            isPID1Included: true
        )

        let pids = Array(iterator)

        // minimum number of PIDs is 2 (initial and PID 1 & PID 0)
        #expect(pids.count >= 3)
        #expect(pids.first == pid)
        #expect(pids.suffix(2) == [.pid1, .pid0])
    }

    @Test
    func withInitial_withoutPID1withPID0() throws {
        guard let pid = try exampleProcess() else { return }

        let iterator = PID.AncestorsSequence(
            initialPID: pid,
            isInitialIncluded: true,
            isPID0Included: true,
            isPID1Included: false
        )

        let pids = Array(iterator)

        // minimum number of PIDs is 2 (initial and PID 0)
        #expect(pids.count >= 2)
        #expect(pids.first == pid)
        #expect(pids.last == .pid0)
        #expect(pids.suffix(2) != [.pid1, .pid0]) // shouldn't contain PID 1
    }

    @Test
    func withoutInitial_withPID1AndPID0() throws {
        guard let pid = try exampleProcess() else { return }

        let iterator = PID.AncestorsSequence(
            initialPID: pid,
            isInitialIncluded: false,
            isPID0Included: true,
            isPID1Included: true
        )

        let pids = Array(iterator)

        // minimum number of PIDs is 2 (PID 1 and PID 0)
        #expect(pids.count >= 2)
        #expect(pids.suffix(2) == [.pid1, .pid0])
    }

    @Test
    func withoutInitial_withoutPID1AndPID0() throws {
        guard let pid = try exampleProcess() else { return }

        let iterator = PID.AncestorsSequence(
            initialPID: pid,
            isInitialIncluded: false,
            isPID0Included: false,
            isPID1Included: false
        )

        let pids = Array(iterator)

        // minimum number of PIDs is 0
        // (if initial PID has PID 1 as its parent, then no PIDs are returned)
        #expect(pids.count >= 0)
    }
}
#endif
