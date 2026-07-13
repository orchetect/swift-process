//
//  CommandProcess.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

/// Run a shell command as a subprocess and return its standard output & error output upon completion.
///
/// ```swift
/// var command = CommandProcess(
///     command: "defaults read com.apple.finder somekey"
/// )
///
/// try command.runAndWait()
///
/// print(command.output) // stdout lines
/// print(command.errorOutput) // stderr lines
/// print(command.exitCode) // exit code integer
/// ```
///
/// The underlying mechanism uses `Process` (`NSTask`).
///
/// > Note:
/// >
/// > In a sandboxed app, child processes that are created inherit the sandbox of the parent app.
@available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *)
public struct CommandProcess {
    /// The shell command to execute.
    public let command: String
    public let qualityOfService: QualityOfService?

    public private(set) var output: [String] = []
    public private(set) var errorOutput: [String] = []
    public private(set) var exitCode: Int32 = 0

    /// Initialize a new process command.
    ///
    /// - Parameters:
    ///   - command: The shell command to execute.
    ///   - qos: Optionally specify the quality of service level to use.
    public init(
        command: String,
        qos: QualityOfService? = nil
    ) {
        self.qualityOfService = qos
        self.command = command
    }
}

// MARK: - Lifecycle

@available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *)
extension CommandProcess {
    /// Run the subprocess and wait for it to complete before returning.
    /// The result of the command is written to the ``output``, ``errorOutput``, and ``exitCode`` properties.
    public mutating func runAndWait() throws {
        let process = Process(command: command, qualityOfService: qualityOfService)
        defer { (output, errorOutput, exitCode) = process._extractOutput() }
        try process.run()
        process.waitUntilExit()
    }

    /// Run the subprocess and wait for it to complete before returning.
    /// The result of the command is written to the ``output``, ``errorOutput``, and ``exitCode`` properties.
    @concurrent
    public mutating func runAndWait() async throws {
        let process = Process(command: command, qualityOfService: qualityOfService)
        defer { (output, errorOutput, exitCode) = process._extractOutput() }
        try process.run()
        process.waitUntilExit()
    }
}

#endif
