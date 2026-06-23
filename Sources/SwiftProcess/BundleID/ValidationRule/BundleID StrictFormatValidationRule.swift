//
//  BundleID StrictFormatValidationRule.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension BundleID {
    /// Validation rule that applies a strict evaluation of bundle identifier format.
    ///
    /// This format follows Apple's specification: Only alphanumeric (A-Z, a-z, 0-9),
    /// hyphen (-) and period (.) characters.
    public struct StrictFormatValidationRule: ValidationRule {
        public init() { }

        public func isValid(string: some StringProtocol) -> Bool {
            let pattern = #"^[A-Za-z0-9\-]+(\.[\A-Za-z0-9\-]+)+$"#
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

extension BundleID.ValidationRule where Self == BundleID.StrictFormatValidationRule {
    /// Validation rule that applies a strict evaluation of bundle identifier format.
    ///
    /// This format follows Apple's specification: Only alphanumeric (A-Z, a-z, 0-9),
    /// hyphen (-) and period (.) characters.
    public static var strictFormat: Self {
        BundleID.StrictFormatValidationRule()
    }
}
