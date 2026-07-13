//
//  BackgroundCommandProcess.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

/// Run a shell command as a subprocess asynchronously in the background.
///
/// ```swift
/// var command = BackgroundCommandProcess(
///     command: "defaults read com.apple.finder somekey"
/// )
///
/// try command.runInBackground()
/// ```
///
/// The underlying mechanism uses `Process` (`NSTask`).
///
/// > Note:
/// >
/// > In a sandboxed app, child processes that are created inherit the sandbox of the parent app.
@available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *)
public struct BackgroundCommandProcess {
    /// The shell command to execute.
    public let command: String
    public let qualityOfService: QualityOfService?

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
extension BackgroundCommandProcess {
    /// Run the subprocess without waiting for its completion before returning.
    /// The output of the command is discarded.
    public mutating func runInBackground() throws {
        let process = Process(command: command, qualityOfService: qualityOfService)
        try process.run()
    }

    /// Run the subprocess without waiting for its completion before returning.
    /// The output of the command is discarded.
    public mutating func runInBackground() async throws {
        let process = Process(command: command, qualityOfService: qualityOfService)
        Task {
            try process.run()
        }
    }
}

#endif
