//
//  PID+Metadata Tests.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) || targetEnvironment(macCatalyst)

import Foundation
import SwiftProcess
import Testing

@Suite
struct PID_Metadata_Tests {
    /// Provide a process identifier of a live process in the system to test against.
    private func exampleProcess() -> PID? {
        // we can just use the test target's process
        PID(ProcessInfo.processInfo.processIdentifier)
    }

    @Test
    func executablePath() throws {
        let id = try #require(exampleProcess())
        let path = try #require(id.executablePath)
        #expect(!path.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }

    @Test
    func executableURL() throws {
        let id = try #require(exampleProcess())
        let url = try #require(id.executableURL)
        #expect(url.path != "")
        #expect(url.path != "/")
    }

    @Test
    func isExists() throws {
        let id = try #require(exampleProcess())
        #expect(id.isExists)
    }

    @Test
    func isExists_NonExistentPID() throws {
        let id: PID = try .randomUnused
        #expect(!id.isExists)
    }
}

#endif
