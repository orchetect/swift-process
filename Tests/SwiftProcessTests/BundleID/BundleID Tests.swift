//
//  BundleID Tests.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import SwiftProcess
import Testing

@Suite
struct BundleID_Tests {
    @Test
    func init_empty() {
        let id = BundleID("")
        #expect(id.rawValue == "")
    }

    @Test
    func init_typical() {
        let id = BundleID("com.apple.Safari")
        #expect(id.rawValue == "com.apple.Safari")
    }

    @Test
    func init_substring() {
        let substring: Substring = "com.apple.Safari"[...]
        let id = BundleID(substring)
        #expect(id.rawValue == "com.apple.Safari")
    }

    @Test
    func init_rawValue_empty() {
        let id = BundleID(rawValue: "")
        #expect(id.rawValue == "")
    }

    @Test
    func init_rawValue_typical() {
        let id = BundleID(rawValue: "com.apple.Safari")
        #expect(id.rawValue == "com.apple.Safari")
    }

    @Test
    func expressibleByStringLiteral_assign() {
        let id: BundleID = "com.apple.Safari"
        #expect(id.rawValue == "com.apple.Safari")
    }

    @Test
    func expressibleByStringLiteral_cast() {
        let id = "com.apple.Safari" as BundleID
        #expect(id.rawValue == "com.apple.Safari")
    }

    @Test
    func stringInterpolation() {
        let id: BundleID = "com.apple.Safari"
        #expect("\(id)" == "com.apple.Safari")
    }
}
