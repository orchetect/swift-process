//
//  PID+Metadata+FileDescriptors Tests.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) || targetEnvironment(macCatalyst)

import Foundation
import SwiftProcess
import Testing

@Suite
struct PID_Metadata_FileDescriptors_Tests {
    /// Provide a process identifier of a live process in the system to test against.
    private func exampleProcess() -> PID? {
        // we can just use the test target's process
        PID(ProcessInfo.processInfo.processIdentifier)
    }

    @Test
    func fileDescriptors() throws {
        let id = try #require(PID.all.first(where: { $0.name == "Finder" }))
        let descriptors = id.fileDescriptors
        #expect(!descriptors.isEmpty)
    }
}

#endif
