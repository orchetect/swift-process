//
//  BundleID ValidationRule Tests.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import SwiftProcess
import Testing

@Suite
struct BundleID_ValidationRule_Tests {
    @Test
    func nonEmpty_relaxed_valid() async throws {
        let strings = [
            "com.apple.finder",
            "com.apple.Music",
            "com.company.app",
            "123.test.app",
            "a.b",
            "test.test.test",
            "com.really.long.bundle.id.that.is.valid",
            "com.my-company.app",
            "unity.Blizzard Entertainment.Hearthstone", // Technically " " is invalid but is being used
            "unity.Company Name.Game Name",
            "my_app.test", // Technically "_" is invalid
            "com.my_app", // Technically "_" is invalid
            "jp.co.日本語", // Technically only latin ASCII letters and numbers are allowed
            "日本語.app" // Technically only latin ASCII letters and numbers are allowed
        ]

        for string in strings {
            #expect(
                BundleID(string).isValid(using: [.nonEmpty, .relaxedFormat]),
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
                !BundleID(string).isValid(using: [.nonEmpty, .relaxedFormat]),
                "'\(string)' should be invalid"
            )
        }
    }
}
