//
//  PID+Metadata+bsdinfo Tests.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) || targetEnvironment(macCatalyst)

import Foundation
import SwiftProcess
import Testing

@Suite
struct PID_Metadata_bsdinfo_Tests {
    /// Provide a process identifier of a live process in the system to test against.
    private func exampleProcess() -> PID? {
        // we can just use the test target's process
        PID(ProcessInfo.processInfo.processIdentifier)
    }

    @Test
    func commandName() throws {
        let id = try #require(exampleProcess())
        let commandName = try #require(id.commandName)
        #expect(!commandName.isEmpty)
    }

    @Test
    func commandName_Finder() throws {
        let id = try #require(BundleID("com.apple.finder").pids.first)
        let commandName = try #require(id.commandName)
        #expect(commandName == "Finder")
    }

    @Test
    func name() throws {
        let id = try #require(exampleProcess())
        let name = try #require(id.name)
        #expect(!name.isEmpty)
    }

    @Test
    func name_Finder() throws {
        let id = try #require(BundleID("com.apple.finder").pids.first)
        let name = try #require(id.name)
        #expect(name == "Finder")
    }
}

#endif
