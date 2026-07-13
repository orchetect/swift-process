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

        let g = DispatchGroup()
        if let pipe = standardOutput as? Pipe {
            g.enter()
            pipe.fileHandleForReading.readabilityHandler = { fh in
                let data = fh.availableData
                if data.isEmpty { // EOF on the pipe
                    pipe.fileHandleForReading.readabilityHandler = nil
                    g.leave()
                } else {
                    outputData.data.append(data)
                }
            }
        }

        if let pipe = standardError as? Pipe {
            g.enter()
            pipe.fileHandleForReading.readabilityHandler = { fh in
                let data = fh.availableData
                if data.isEmpty { // EOF on the pipe
                    pipe.fileHandleForReading.readabilityHandler = nil
                    g.leave()
                } else {
                    errorOutputData.data.append(data)
                }
            }
        }

        try run()
        waitUntilExit()
        g.wait(timeout: .now() + 2.0)

        if let pipe = standardOutput as? Pipe {
            assert(pipe.fileHandleForReading.readabilityHandler == nil)
        }
        if let pipe = standardError as? Pipe {
            assert(pipe.fileHandleForReading.readabilityHandler == nil)
        }

        let output = outputData.data._parsedStringLines()
        let errorOutput = errorOutputData.data._parsedStringLines()
        let exitCode = terminationStatus

        return (output: output, errorOutput: errorOutput, exitCode: exitCode)
    }
}

// MARK: - Utilities

extension Data {
    fileprivate func _parsedStringLines() -> [String] {
        guard var string = String(data: self, encoding: .utf8) else { return [] }
        string = string.trimmingCharacters(in: .newlines)
        let components = string.components(separatedBy: "\n")
        guard !components.isEmpty, !components.allSatisfy(\.isEmpty) else { return [] }
        return components
    }
}

#endif
