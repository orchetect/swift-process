//
//  BundleID+Validation.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

extension BundleID {
    /// Creates a new instance by validating a bundle identifier string.
    /// If validation fails, `nil` is returned.
    public init?(
        validating string: some StringProtocol,
        using validationRules: [any ValidationRule] = [.nonEmpty, .strictFormat]
    ) {
        guard validationRules.allSatisfy({ $0.isValid(string: string) }) else { return nil }
        self.init(string)
    }
}

extension BundleID {
    /// Returns the result of evaluating a set of validation rules.
    /// The default ruleset applies strict format validation.
    public func isValid(
        using validationRules: [any ValidationRule] = [.nonEmpty, .strictFormat]
    ) -> Bool {
        validationRules
            .allSatisfy { $0.isValid(string: rawValue) }
    }
}
