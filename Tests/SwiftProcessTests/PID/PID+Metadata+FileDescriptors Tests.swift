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

    // MARK: fileDescriptors

    @Test
    func fileDescriptors() throws {
        let id = try #require(exampleProcess())
        let descriptors = id.fileDescriptors
        #expect(!descriptors.isEmpty)
    }

    @Test
    func fileDescriptors_NonExistentPID() throws {
        let id: PID = try .randomUnused
        let descriptors = id.fileDescriptors
        #expect(descriptors.isEmpty)
    }

    #if os(macOS)
    @Test
    func fileDescriptors_Finder() throws {
        let id = try #require(PID.all.first(where: { $0.name == "Finder" }))
        let descriptors = id.fileDescriptors
        #expect(!descriptors.isEmpty)
    }
    #endif

    // MARK: filePorts

    @Test
    func filePorts() throws {
        let id = try #require(exampleProcess())
        let descriptors = id.filePorts
        // TODO: ports are always empty for some reason, even when running as `sudo`
        #expect(descriptors.isEmpty)
    }

    @Test
    func filePorts_NonExistentPID() throws {
        let id: PID = try .randomUnused
        let descriptors = id.filePorts
        #expect(descriptors.isEmpty)
    }

    #if os(macOS)
    @Test
    func filePorts_Finder() throws {
        let id = try #require(PID.all.first(where: { $0.name == "Finder" }))
        let descriptors = id.filePorts
        // TODO: ports are always empty for some reason, even when running as `sudo`
        #expect(descriptors.isEmpty)
    }
    #endif

    // MARK: lsofDescriptors

    #if os(macOS)

    @Test
    func lsofDescriptors() throws {
        let id = try #require(exampleProcess())
        let descriptors = try id.lsofDescriptors()
        #expect(!descriptors.isEmpty)
    }

    @Test
    func lsofDescriptors_NonExistentPID() throws {
        let id: PID = try .randomUnused
        #expect(throws: (any Error).self) {
            try id.lsofDescriptors()
        }
    }

    @Test
    func lsofDescriptors_Finder() throws {
        let id = try #require(PID.all.first(where: { $0.name == "Finder" }))
        let descriptors = try id.lsofDescriptors()
        #expect(!descriptors.isEmpty)
    }

    #else

    @Test
    func lsofDescriptors_Finder_UnsupportedPlatform() throws {
        let id = try #require(PID.all.first(where: { $0.name == "Finder" }))
        #expect(throws: PID.SystemError.notSupported) {
            let _ = try id.lsofDescriptors()
        }
    }

    #endif
}

#endif
