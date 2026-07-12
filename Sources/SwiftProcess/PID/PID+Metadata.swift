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
    public var executablePath: String {
        #if os(macOS) || targetEnvironment(macCatalyst)
        var path = [CChar](repeating: 0x00, count: Self.kProcPidPathInfoMaxSize)
        proc_pidpath(rawValue, &path, Self.PROC_PIDPATHINFO_MAXSIZE)
        let string = withUnsafePointer(to: path) { ptr in
            ptr.withMemoryRebound(to: CChar.self, capacity: Self.kProcPidPathInfoMaxSize) { pointer in
                String(cString: pointer)
            }
        }
        return string
        #else
        return ""
        #endif
    }
}
