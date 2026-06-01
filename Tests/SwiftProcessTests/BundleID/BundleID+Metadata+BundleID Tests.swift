//
//  BundleID+Metadata+BundleID Tests.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

// Bundle ID lookup is only available on macOS (not including macCatalyst)

#if os(macOS)

import AppKit
import SwiftProcess
import Testing

@Suite
struct BundleID_Metadata_BundleID_Tests {
    @Test
    func pids() {
        let idString = "com.apple.finder"
        let id = BundleID(idString)
        let pids = id.pids
        #expect(!pids.isEmpty)

        let apps = NSRunningApplication
            .runningApplications(withBundleIdentifier: idString)
        #expect(
            apps.contains(where: {
                pids
                    .map(\.rawValue)
                    .contains($0.processIdentifier)
            })
        )
    }
}

#endif
