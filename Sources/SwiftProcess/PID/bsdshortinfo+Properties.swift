//
//  bsdshortinfo+Properties.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) || targetEnvironment(macCatalyst)

import Foundation

@available(macOS 10.15, macCatalyst 13, *)
@available(iOS, deprecated, message: "Not available on iOS.")
@available(tvOS, deprecated, message: "Not available on tvOS.")
@available(watchOS, deprecated, message: "Not available on watchOS.")
@available(visionOS, deprecated, message: "Not available on visionOS.")
extension proc_bsdshortinfo {
    /// Returns the command name of the process (Limited to 15 characters).
    ///
    /// This field requires at least one trailing null byte, which is why the limit is 15 characters
    /// and not 16 (the field size).
    nonisolated
    func getCommandName() -> String {
        withUnsafeBytes(of: pbsi_comm) { rawPtr in
            let ptr = rawPtr.baseAddress!.assumingMemoryBound(to: CChar.self)
            return String(cString: ptr)
        }
    }
}

#endif
