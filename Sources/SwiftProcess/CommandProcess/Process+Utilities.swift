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

    func _extractOutput() -> (output: [String], errorOutput: [String], exitCode: Int32) {
        var output: [String] = []
        if let pipe = standardOutput as? Pipe,
           let data = try? pipe.fileHandleForReading.readToEnd(),
           var string = String(data: data, encoding: .utf8)
        {
            string = string.trimmingCharacters(in: .newlines)
            let components = string.components(separatedBy: "\n")
            if !components.isEmpty, !components.allSatisfy(\.isEmpty) {
                output = components
            }
        }

        var errorOutput: [String] = []
        if let pipe = standardError as? Pipe,
           let data = try? pipe.fileHandleForReading.readToEnd(),
           var string = String(data: data, encoding: .utf8)
        {
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
