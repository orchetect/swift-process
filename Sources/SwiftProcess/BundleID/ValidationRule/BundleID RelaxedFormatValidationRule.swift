//
//  BundleID RelaxedFormatValidationRule.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension BundleID {
    /// Validation rule that applies a relaxed evaluation of bundle identifier format.
    ///
    /// This allows for common non-standard identifier strings.
    ///
    /// For example, some developers add whitespaces in the bundle ID, such as
    /// `"unity.Blizzard Entertainment.Hearthstone"` which does not comply with Apple's strict
    /// bundle ID format rules, but it is still a bundle ID that is usable in the system.
    public struct RelaxedFormatValidationRule: ValidationRule {
        public init() { }

        public func isValid(string: some StringProtocol) -> Bool {
            let pattern = #"^\w[\w\s\-]*(\.[\w\s\-]*\w)+$"#
            let string = String(string)
            let range = NSRange(location: 0, length: string.count)
            let matches = try? NSRegularExpression(pattern: pattern)
                .matches(in: string, range: range)
            guard let matches else { return false }
            return !matches.isEmpty
        }
    }
}

// MARK: - Static Constructor

extension BundleID.ValidationRule where Self == BundleID.RelaxedFormatValidationRule {
    /// Validation rule that applies a relaxed evaluation of bundle identifier format.
    ///
    /// This allows for common non-standard identifier strings.
    ///
    /// For example, some developers add whitespaces in the bundle ID, such as
    /// `"unity.Blizzard Entertainment.Hearthstone"` which does not comply with Apple's strict
    /// bundle ID format rules, but it is still a bundle ID that is usable in the system.
    public static var relaxedFormat: Self {
        BundleID.RelaxedFormatValidationRule()
    }
}
