//
//  BundleID NonEmptyValidationRule.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

extension BundleID {
    /// Validation rule that considers empty bundle identifiers invalid, including those
    /// that may contain only periods.
    public struct NonEmptyValidationRule: ValidationRule {
        public init() { }

        public func isValid(string: some StringProtocol) -> Bool {
            let components = string.split(separator: ".")
            let isBundleIDEmpty = components
                .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
                .isEmpty
            return !isBundleIDEmpty
        }
    }
}

// MARK: - Static Constructor

extension BundleID.ValidationRule where Self == BundleID.NonEmptyValidationRule {
    /// Validation rule that considers empty bundle identifiers invalid, including those
    /// that may contain only periods.
    public static var nonEmpty: Self {
        BundleID.NonEmptyValidationRule()
    }
}
