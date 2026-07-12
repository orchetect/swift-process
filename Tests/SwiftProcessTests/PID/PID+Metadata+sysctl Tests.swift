//
//  PID+Metadata+sysctl Tests.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) || targetEnvironment(macCatalyst)

import Foundation
import SwiftProcess
import Testing

@Suite
struct PID_Metadata_sysctl_Tests {
    /// Provide a process identifier of a live process in the system to test against.
    private func exampleProcess() -> PID? {
        // we can just use the test target's process
        PID(ProcessInfo.processInfo.processIdentifier)
    }

    @Test
    func launchDate() throws {
        let id = try #require(exampleProcess())
        let launchDate = try #require(id.launchDate)
        #expect(launchDate < Date())
    }

    #if os(macOS)
    @Test
    func launchDate_Finder() throws {
        let id = try #require(PID.all.first(where: { $0.name == "Finder" }))
        let launchDate = try #require(id.launchDate)
        #expect(launchDate < Date())
    }
    #endif

    @Test
    func uptime() throws {
        let id = try #require(exampleProcess())
        let uptime = try #require(id.uptime)
        #expect(uptime > 0.0)
    }

    #if os(macOS)
    @Test
    func uptime_Finder() throws {
        let id = try #require(PID.all.first(where: { $0.name == "Finder" }))
        let uptime = try #require(id.uptime)
        #expect(uptime > 0.0)
    }
    #endif
}

#endif
