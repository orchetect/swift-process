//
//  BackgroundCommandProcess Tests.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import SwiftProcess
import Testing
import TestingExtensions

@Suite
struct BackgroundCommandProcess_NonAsync_Tests {
    @Test
    func empty() /* NOT ASYNC */ throws {
        var command = BackgroundCommandProcess(command: "")
        #expect(throws: Never.self) {
            try command.runInBackground()
        }
    }

    @Test
    func checkAsynchronously() async throws {
        let tempFilePath = URL.temporaryDirectory
            .appendingPathComponent("\(UUID().uuidString).txt")
            .path
        var command = BackgroundCommandProcess(command: "echo \"Foo\" > \"\(tempFilePath)\"")
        defer { try? FileManager.default.removeItem(atPath: tempFilePath) } // cleanup on scope exit

        #expect(throws: Never.self) {
            try /* NOT AWAIT */ command.runInBackground()
        }

        try await Task.sleep(for: .milliseconds(500))
        try await wait(require: { FileManager.default.fileExists(atPath: tempFilePath) }, timeout: 5.0)
    }
}

@Suite
struct BackgroundCommandProcess_Async_Tests {
    @Test
    func empty() async throws {
        var command = BackgroundCommandProcess(command: "")
        await #expect(throws: Never.self) {
            try await command.runInBackground()
        }
    }

    @Test
    func checkAsynchronously() async throws {
        let tempFilePath = URL.temporaryDirectory
            .appendingPathComponent("\(UUID().uuidString).txt")
            .path
        var command = BackgroundCommandProcess(command: "echo \"Foo\" > \"\(tempFilePath)\"")
        defer { try? FileManager.default.removeItem(atPath: tempFilePath) } // cleanup on scope exit

        await #expect(throws: Never.self) {
            try await command.runInBackground()
        }

        try await Task.sleep(for: .milliseconds(500))
        try await wait(require: { FileManager.default.fileExists(atPath: tempFilePath) }, timeout: 5.0)
    }
}

#endif
