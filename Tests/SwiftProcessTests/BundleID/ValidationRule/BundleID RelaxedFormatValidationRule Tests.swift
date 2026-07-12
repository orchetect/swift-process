//
//  BundleID RelaxedFormatValidationRule Tests.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import SwiftProcess
import Testing

@Suite
struct BundleID_RelaxedFormatValidationRule_Tests {
    @Test
    func valid() {
        let strings = [
            "com.apple.finder",
            "com.apple.Music",
            "com.company.app",
            "123.test.app",
            "a.b",
            "test.test.test",
            "com.really.long.bundle.id.that.is.valid",
            "com.my-company.app",
            "unity.Blizzard Entertainment.Hearthstone", // " " is invalid
            "unity.Company Name.Game Name",
            "my_app.test", // "_" is invalid, but we'll permit it
            "com.my_app", // "_" is invalid, but we'll permit it
            "jp.co.日本語", // Only Latin ASCII letters/numbers are allowed, but we'll permit it
            "日本語.app" // Only Latin ASCII letters/numbers are allowed, but we'll permit it
        ]

        for string in strings {
            #expect(
                BundleID.RelaxedFormatValidationRule().isValid(string: string),
                "'\(string)' should be valid"
            )
        }
    }

    @Test
    func invalid() {
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
            "com.mycompany.😀", // emojis are invalid, even in relaxed validation rule
            "coma😀.myapp", // emojis are invalid, even in relaxed validation rule
            "com.a😀b.myapp" // emojis are invalid, even in relaxed validation rule
        ]

        for string in strings {
            #expect(
                !BundleID.RelaxedFormatValidationRule().isValid(string: string),
                "'\(string)' should be invalid"
            )
        }
    }
}
