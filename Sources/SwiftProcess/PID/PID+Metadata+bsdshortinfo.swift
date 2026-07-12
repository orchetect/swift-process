//
//  PID+Metadata+bsdshortinfo.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension PID {
    #if os(macOS) || targetEnvironment(macCatalyst)

    /// Returns the BSD short information struct for the process.
    /// If the process is no longer running or an error occurred, `nil` is returned.
    nonisolated
    public var bsdShortInfo: proc_bsdshortinfo? {
        var bsdInfo = proc_bsdshortinfo()

        let size = MemoryLayout<proc_bsdshortinfo>.stride
        let result = withUnsafeMutablePointer(to: &bsdInfo) {
            $0.withMemoryRebound(to: CChar.self, capacity: size) {
                proc_pidinfo(rawValue, PROC_PIDT_SHORTBSDINFO, 0, $0, Int32(size))
            }
        }

        guard result == size else {
            return nil
        }

        return bsdInfo
    }

    #endif
}
