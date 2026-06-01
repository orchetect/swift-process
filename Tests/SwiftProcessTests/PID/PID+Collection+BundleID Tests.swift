//
//  PID+Collection+BundleID Tests.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

// Bundle ID lookup is only available on macOS (not including macCatalyst)

#if os(macOS)

import AppKit
import Foundation
import SwiftProcess
import Testing

@Suite
struct PID_Collection_BundleID_Tests {
    /// Provide a process identifier of a live process in the system to test against.
    private func exampleProcess() -> PID? {
        let pids = BundleID("com.apple.finder").pids
        assert(pids.count == 1) // should only ever be one running Finder process
        return pids.first
    }

    @Test
    func contains_caseInsensitiveBundleID() {
        guard let pid = exampleProcess() else { return }

        let sequence = PID.AncestorsSequence(
            initialPID: pid,
            isInitialIncluded: true,
            isPID1Included: true
        )

        let ids = sequence.compactMap(\.bundleID)
        guard !ids.isEmpty else {
            withKnownIssue("No bundle IDs found for process ID. Skipping test.") {
                Issue.record()
            }
            return
        }

        print("Finder process's ancestral bundle identifier(s):")
        dump(ids)

        for id in ids {
            #expect(sequence.contains(caseInsensitiveBundleID: id.rawValue))
            #expect(sequence.contains(caseInsensitiveBundleID: id.rawValue.uppercased()))
            #expect(sequence.contains(caseInsensitiveBundleID: id.rawValue.lowercased()))
        }
    }

    @Test
    func bundleIdentifiers() {
        guard let pid = exampleProcess() else { return }

        let sequence = PID.AncestorsSequence(
            initialPID: pid,
            isInitialIncluded: true,
            isPID1Included: true
        )

        let ids = Array(sequence.bundleIDs)

        // won't test specific values, just check if it contains at least one
        #expect(!ids.isEmpty)
    }

    @Test
    func firstBundleID() {
        guard let pid = exampleProcess() else { return }

        let sequence = PID.AncestorsSequence(
            initialPID: pid,
            isInitialIncluded: true,
            isPID1Included: true
        )

        let id = sequence.firstBundleID

        #expect(id != nil)
        #expect(id == "com.apple.finder")
    }
}

#endif
