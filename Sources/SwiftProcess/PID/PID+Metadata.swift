//
//  PID+Metadata.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension PID {
    static let PROC_PIDPATHINFO_MAXSIZE: UInt32 = 4096
    static let kProcPidPathInfoMaxSize = Int(PROC_PIDPATHINFO_MAXSIZE)

    /// Returns the path to the executable for the process.
    ///
    /// > Note: Path lookup is only available on macOS and Mac Catalyst.
    /// > On all other platforms, this property always returns an empty string.
    @available(macOS 10.15, *)
    @available(iOS, deprecated, message: "Not available on iOS.")
    @available(tvOS, deprecated, message: "Not available on tvOS.")
    @available(watchOS, deprecated, message: "Not available on watchOS.")
    @available(visionOS, deprecated, message: "Not available on visionOS.")
    nonisolated
    public var executablePath: String? {
        #if os(macOS) || targetEnvironment(macCatalyst)
        var path = [CChar](repeating: 0x00, count: Self.kProcPidPathInfoMaxSize)

        // returns number of bytes if successful, or -1 if it failed
        let result = proc_pidpath(rawValue, &path, Self.PROC_PIDPATHINFO_MAXSIZE)
        guard result > 0 else { return nil }

        let string = String(cString: &path)
        guard !string.isEmpty else { return nil }
        return string
        #else
        return ""
        #endif
    }

    /// Returns the file URL of the executable for the process.
    ///
    /// > Note: Path lookup is only available on macOS and Mac Catalyst.
    /// > On all other platforms, this property always returns an empty URL.
    @available(macOS 10.15, *)
    @available(iOS, deprecated, message: "Not available on iOS.")
    @available(tvOS, deprecated, message: "Not available on tvOS.")
    @available(watchOS, deprecated, message: "Not available on watchOS.")
    @available(visionOS, deprecated, message: "Not available on visionOS.")
    nonisolated
    public var executableURL: URL? {
        guard let executablePath else { return nil }
        return URL(fileURLWithPath: executablePath)
    }

    /// Returns a boolean value describing whether a process with the process identifier
    /// currently exists and belongs to a running process.
    /// If the process is no longer running or an error occurred, `nil` is returned.
    ///
    /// > Note: Process info lookup is only available on macOS and Mac Catalyst.
    /// > On all other platforms, this property always returns `false`.
    nonisolated
    public var isExists: Bool {
        (try? Self.all.contains(self)) == true
    }
}
