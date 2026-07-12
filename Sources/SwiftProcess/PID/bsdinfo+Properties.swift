//
//  bsdinfo+Properties.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) || targetEnvironment(macCatalyst)

import Foundation

@available(macOS 10.15, *)
@available(iOS, deprecated, message: "Not available on iOS.")
@available(tvOS, deprecated, message: "Not available on tvOS.")
@available(watchOS, deprecated, message: "Not available on watchOS.")
@available(visionOS, deprecated, message: "Not available on visionOS.")
extension proc_bsdinfo {
    /// Returns the command name of the process (Limited to 15 characters).
    ///
    /// This field requires at least one trailing null byte, which is why the limit is 15 characters
    /// and not 16 (the field size).
    nonisolated
    func getCommandName() -> String {
        // swiftformat:options --wrap-collections preserve --allow-partial-wrapping true
        typealias Tuple = (
            CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar,
            CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar
        )
        // swiftformat:options --wrap-collections before-first --allow-partial-wrapping false

        let tuple: Tuple = pbi_comm
        let charCount = MemoryLayout<Tuple>.stride // 16 bytes
        let string = withUnsafePointer(to: tuple) { ptr in
            ptr.withMemoryRebound(to: CChar.self, capacity: charCount) { pointer in
                String(cString: pointer)
            }
        }
        return string
    }

    /// Returns the name of the process (Limited to 31 characters).
    ///
    /// This field requires at least one trailing null byte, which is why the limit is 31 characters
    /// and not 32 (the field size).
    nonisolated
    func getName() -> String {
        // swiftformat:options --wrap-collections preserve --allow-partial-wrapping true
        typealias NameTuple = (
            CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar,
            CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar,
            CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar,
            CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar
        )
        // swiftformat:options --wrap-collections before-first --allow-partial-wrapping false

        let tuple: NameTuple = pbi_name
        let charCount = MemoryLayout<NameTuple>.stride // 32 bytes
        let string = withUnsafePointer(to: tuple) { ptr in
            ptr.withMemoryRebound(to: CChar.self, capacity: charCount) { pointer in
                String(cString: pointer)
            }
        }
        return string
    }
}

#endif
