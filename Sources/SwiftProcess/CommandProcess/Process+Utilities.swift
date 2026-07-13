//
//  Process+Utilities.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

@available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *)
extension Process {
    private static let shellExecutablePath = ProcessInfo.processInfo.environment["SHELL"] ?? "/bin/zsh"

    convenience init(command: String, qualityOfService: QualityOfService?) {
        // Flag  Description
        // ----  -----------
        // -c    Interprets first argument as command to run. Arg should be wrapped in quotes.
        // -l    Interprets command as if it had been invoked in a login shell
        //
        // zsh -cl '<command>'

        self.init()

        executableURL = URL(fileURLWithPath: Self.shellExecutablePath)
        if let qualityOfService { self.qualityOfService = qualityOfService }
        arguments = ["-cl", command]

        let stdPipe = Pipe()
        standardOutput = stdPipe
        let errPipe = Pipe()
        standardError = errPipe
    }

    func _runAndExtractOutput() throws -> (output: [String], errorOutput: [String], exitCode: Int32) {
        final class SendableData: Sendable {
            var data: Data {
                get { lock.withLock { _data } }
                _modify {
                    lock.lock()
                    defer { lock.unlock() }
                    yield &_data
                }
                set { lock.withLock { _data = newValue } }
            }
            nonisolated(unsafe) private var _data: Data = .init()
            let lock = NSLock()
            init() { }
        }

        let outputData = SendableData()
        let errorOutputData = SendableData()

        // solution for preventing deadlocks
        // see: https://forums.swift.org/t/the-problem-with-a-frozen-process-in-swift-process-class/39579/6

        try DispatchQueue.global().sync {
            let outputGroup = DispatchGroup()
            if let pipe = standardOutput as? Pipe {
                outputGroup.enter()
                pipe.fileHandleForReading.readabilityHandler = { fh in
                    let data = fh.availableData
                    if data.isEmpty { // EOF on the pipe
                        pipe.fileHandleForReading.readabilityHandler = nil
                        outputGroup.leave()
                    } else {
                        outputData.data.append(data)
                    }
                }
            }

            let outputErrorGroup = DispatchGroup()
            if let pipe = standardError as? Pipe {
                outputErrorGroup.enter()
                pipe.fileHandleForReading.readabilityHandler = { fh in
                    let data = fh.availableData
                    if data.isEmpty { // EOF on the pipe
                        pipe.fileHandleForReading.readabilityHandler = nil
                        outputErrorGroup.leave()
                    } else {
                        outputData.data.append(data)
                    }
                }
            }
            
            try run()
            waitUntilExit()
            outputGroup.wait() // Wait for EOF on the pipe.
            outputErrorGroup.wait() // Wait for EOF on the pipe.
        }

        var output: [String] = []
        if var string = String(data: outputData.data, encoding: .utf8) {
            string = string.trimmingCharacters(in: .newlines)
            let components = string.components(separatedBy: "\n")
            if !components.isEmpty, !components.allSatisfy(\.isEmpty) {
                output = components
            }
        }

        var errorOutput: [String] = []
        if var string = String(data: errorOutputData.data, encoding: .utf8) {
            string = string.trimmingCharacters(in: .newlines)
            let components = string.components(separatedBy: "\n")
            if !components.isEmpty, !components.allSatisfy(\.isEmpty) {
                errorOutput = components
            }
        }

        let exitCode = terminationStatus

        return (output: output, errorOutput: errorOutput, exitCode: exitCode)
    }
}

#endif
