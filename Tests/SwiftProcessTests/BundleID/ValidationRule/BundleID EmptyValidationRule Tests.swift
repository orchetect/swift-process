//
//  BundleID EmptyValidationRule Tests.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import SwiftProcess
import Testing

@Suite
struct BundleID_EmptyValidationRule_Tests {
    @Test
    func nonEmpty_relaxed_valid() async throws {
        let strings = [
            "a",
            ".a.",
            ".a",
            "a.",
            ".finder",
            "com.apple.finder",
            "com.apple.Music",
            "com.company.app",
            "123.test.app",
            "a.b",
            "noDotsHere",
            "test.test.test",
            "com.really.long.bundle.id.that.is.valid",
            "com.my-company.app",
            "unity.Blizzard Entertainment.Hearthstone", // Technically " " is invalid
            "unity.Company Name.Game Name",
            "my_app.test", // Technically "_" is invalid
            "com.my_app", // Technically "_" is invalid
            "jp.co.日本語", // Technically only latin ASCII letters and numbers are allowed
            "日本語.app", // Technically only latin ASCII letters and numbers are allowed
            "com.mycompany.😀", // Technically only latin ASCII letters and numbers are allowed
            "coma😀.myapp", // Technically only latin ASCII letters and numbers are allowed
            "com.a😀b.myapp" // Technically only latin ASCII letters and numbers are allowed
        ]

        for string in strings {
            #expect(
                BundleID.EmptyValidationRule().isValid(string: string),
                "'\(string)' should be valid"
            )
        }
    }

    @Test
    func nonEmpty_relaxed_invalid() async throws {
        let strings = [
            "",
            " ",
            ".",
            "..",
            " . ",
            ". .",
            " . . ",
            "...."
        ]

        for string in strings {
            #expect(
                !BundleID.EmptyValidationRule().isValid(string: string),
                "'\(string)' should be invalid"
            )
        }
    }
}
