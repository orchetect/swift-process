//
//  BundleID StrictFormatValidationRule Tests.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import SwiftProcess
import Testing

@Suite
struct BundleID_StrictFormatValidationRule_Tests {
    @Test
    func valid() async throws {
        let strings = [
            "com.apple.finder",
            "com.apple.Music",
            "com.company.app",
            "123.test.app",
            "a.b",
            "test.test.test",
            "com.really.long.bundle.id.that.is.valid",
            "com.my-company.app"
        ]

        for string in strings {
            #expect(
                BundleID.StrictFormatValidationRule().isValid(string: string),
                "'\(string)' should be valid"
            )
        }
    }

    @Test
    func invalid() async throws {
        let strings = [
            "",
            " ",
            ".",
            "..",
            " . ",
            ". .",
            " . . ",
            "....",
            "a",
            ".a",
            "a.",
            ".a.",
            "com",
            "com.",
            ".com.apple",
            "com.apple.",
            "com..apple",
            "com...apple",
            "com apple test",
            "com/apple/test",
            "com:apple:test",
            "com.apple..TextEdit",
            "com.apple.",
            ".finder",
            "noDotsHere",
            "unity.Blizzard Entertainment.Hearthstone", // " " is invalid
            "unity.Company Name.Game Name",
            "my_app.test", // "_" is invalid
            "com.my_app", // "_" is invalid
            "jp.co.日本語", // Only Latin ASCII letters/numbers are allowed
            "日本語.app", // Only Latin ASCII letters/numbers are allowed
            "com.mycompany.😀", // Only latin ASCII letters and numbers are allowed
            "coma😀.myapp", // Only latin ASCII letters and numbers are allowed
            "com.a😀b.myapp" // Only latin ASCII letters and numbers are allowed
        ]

        for string in strings {
            #expect(
                !BundleID.StrictFormatValidationRule().isValid(string: string),
                "'\(string)' should be invalid"
            )
        }
    }
}
