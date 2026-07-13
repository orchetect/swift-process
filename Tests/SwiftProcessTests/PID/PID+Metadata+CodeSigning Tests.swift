//
//  PID+Metadata+CodeSigning Tests.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) || targetEnvironment(macCatalyst)

import Foundation
import SwiftProcess
import Testing

@Suite
struct PID_Metadata_CodeSigning_Tests {
    /// Provide a process identifier of a live process in the system to test against.
    private func exampleProcess() -> PID? {
        // we can just use the test target's process
        PID(ProcessInfo.processInfo.processIdentifier)
    }

    @Test
    func codeSigningInfo() throws {
        let id = try #require(exampleProcess())
        let infoDict = try #require(id.codeSigningInfo)
        #expect(!infoDict.isEmpty)
    }

    @Test
    func codeSigningInfo_NonExistentPID() throws {
        let id: PID = try .randomUnused
        let infoDict = id.codeSigningInfo
        #expect(infoDict == nil)
    }

    #if os(macOS)
    @Test
    func codeSigningInfo_Finder() throws {
        let id = try #require(PID.all.first(where: { $0.name == "Finder" }))
        let infoDict = try #require(id.codeSigningInfo)
        let bundleIDString = try #require(infoDict["identifier"] as? String)
        #expect(bundleIDString.caseInsensitiveCompare("com.apple.finder") == .orderedSame)
    }
    #endif
}

#endif
