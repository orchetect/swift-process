//
//  BundleID ValidationRule.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

extension BundleID {
    public protocol ValidationRule: Equatable, Hashable, Sendable {
        /// Returns validation status for a bundle identifier string.
        func isValid(string: some StringProtocol) -> Bool
    }
}
