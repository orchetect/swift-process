//
//  CommandProcess Tests.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftProcess
import Testing

@Suite
struct CommandProcess_NonAsync_Tests {
    @Test
    func empty() /* NOT ASYNC */ throws {
        var command = CommandProcess(command: "")
        try command.runAndWait()
        #expect(command.output.isEmpty)
        #expect(command.errorOutput.isEmpty)
        #expect(command.exitCode == 0)
    }

    @Test
    func lsOutput() /* NOT ASYNC */ throws {
        var command = CommandProcess(command: "ls")
        try command.runAndWait()
        #expect(!command.output.isEmpty)
        #expect(command.errorOutput.isEmpty)
        #expect(command.exitCode == 0)
    }

    @Test
    func echoOutput() /* NOT ASYNC */ throws {
        var command = CommandProcess(command: #"echo "Test""#)
        try command.runAndWait()
        #expect(command.output == ["Test"])
        #expect(command.errorOutput.isEmpty)
        #expect(command.exitCode == 0)
    }

    @Test
    func echoMultilineOutput() /* NOT ASYNC */ throws {
        var command = CommandProcess(command: #"echo "Test"; echo " Line 2 ""#)
        try command.runAndWait()
        #expect(command.output == ["Test", " Line 2 "])
        #expect(command.errorOutput.isEmpty)
        #expect(command.exitCode == 0)
    }

    @Test
    func nonZeroExitCode() /* NOT ASYNC */ throws {
        var command = CommandProcess(command: "exit 65")
        try command.runAndWait()
        #expect(command.output.isEmpty)
        #expect(command.errorOutput.isEmpty)
        #expect(command.exitCode == 65)
    }
}

@Suite
struct CommandProcess_Async_Tests {
    @Test
    func empty() async throws {
        var command = CommandProcess(command: "")
        try await command.runAndWait()
        #expect(command.output.isEmpty)
        #expect(command.errorOutput.isEmpty)
        #expect(command.exitCode == 0)
    }

    @Test
    func lsOutput() async throws {
        var command = CommandProcess(command: "ls")
        try await command.runAndWait()
        #expect(!command.output.isEmpty)
        #expect(command.errorOutput.isEmpty)
        #expect(command.exitCode == 0)
    }

    @Test
    func echoOutput() async throws {
        var command = CommandProcess(command: #"echo "Test""#)
        try await command.runAndWait()
        #expect(command.output == ["Test"])
        #expect(command.errorOutput.isEmpty)
        #expect(command.exitCode == 0)
    }

    @Test
    func echoMultilineOutput() async throws {
        var command = CommandProcess(command: #"echo "Test"; echo " Line 2 ""#)
        try await command.runAndWait()
        #expect(command.output == ["Test", " Line 2 "])
        #expect(command.errorOutput.isEmpty)
        #expect(command.exitCode == 0)
    }

    @Test
    func nonZeroExitCode() async throws {
        var command = CommandProcess(command: "exit 65")
        try await command.runAndWait()
        #expect(command.output.isEmpty)
        #expect(command.errorOutput.isEmpty)
        #expect(command.exitCode == 65)
    }
}

#endif
