//
//  BundleID+Metadata+Bundle Tests.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

// Bundle ID lookup is only available on macOS (not including macCatalyst)

#if os(macOS)

import AppKit
import SwiftProcess
import Testing

@Suite
struct BundleID_Metadata_Bundle_Tests {
    @Test
    func bundleURL() throws {
        let idString = "com.apple.Safari"
        let id = BundleID(idString)
        let bundleURL = try #require(id.bundleURL)
        #expect(bundleURL.isFileURL)
        #expect(FileManager.default.fileExists(atPath: bundleURL.path))
        #expect(bundleURL.lastPathComponent == "Safari.app")
    }
}

#endif
