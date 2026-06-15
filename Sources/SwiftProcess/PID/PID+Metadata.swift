//
//  PID+Metadata.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension PID {
    #if os(macOS) || targetEnvironment(macCatalyst)
    
    /// Returns the BSD info struct for the process.
    /// If the process is no longer running or an error occurred, `nil` is returned.
    nonisolated
    public var bsdInfo: proc_bsdinfo? {
        // The `proc_bsdinfo` struct holds assorted information about a BSD process
        var bsdInfo = proc_bsdinfo()

        // Call `proc_pidinfo`, requesting `PROC_PIDTBSDINFO`
        // This populates `bsdInfo` if successful
        let size = MemoryLayout<proc_bsdinfo>.stride
        let result = withUnsafeMutablePointer(to: &bsdInfo) {
            $0.withMemoryRebound(to: CChar.self, capacity: size) {
                proc_pidinfo(rawValue, PROC_PIDTBSDINFO, 0, $0, Int32(size))
            }
        }

        // If the call returns the size of `proc_bsdinfo`, it succeeded
        guard result == size else {
            return nil // failed, or pid doesn't exist
        }

        return bsdInfo
    }

    #endif
    
    /// Returns the name of the process.
    /// If the process is no longer running or no name is returned from the system, `nil` is returned.
    ///
    /// > Note: Process info lookup is only available on macOS and Mac Catalyst.
    /// > On all other platforms, this property always returns `nil`.
    @available(macOS 10.15, *)
    @available(iOS, deprecated, message: "Not available on iOS.")
    @available(tvOS, deprecated, message: "Not available on tvOS.")
    @available(watchOS, deprecated, message: "Not available on watchOS.")
    @available(visionOS, deprecated, message: "Not available on visionOS.")
    nonisolated
    public var name: String? {
        #if os(macOS) || targetEnvironment(macCatalyst)
        guard let bsdInfo else { return nil }

        // swiftformat:options --wrap-collections preserve --allow-partial-wrapping true
        typealias NameTuple = (
            CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar,
            CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar,
            CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar,
            CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar
        )
        // swiftformat:options --wrap-collections before-first --allow-partial-wrapping false

        let tuple: NameTuple = bsdInfo.pbi_name
        let charCount = MemoryLayout<NameTuple>.stride // 32 bytes
        let string = withUnsafePointer(to: tuple) { ptr in
            ptr.withMemoryRebound(to: CChar.self, capacity: charCount) { pointer in
                String(cString: pointer)
            }
        }
        return string
        #else
        return nil
        #endif
    }
}
