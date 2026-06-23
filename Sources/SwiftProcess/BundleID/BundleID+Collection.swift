//
//  BundleID+Collection.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

extension Sequence<BundleID> {
    /// Returns a Boolean value indicating whether the sequence contains a bundle ID using
    /// case-insensitive string comparison.
    public func contains(caseInsensitive bundleID: BundleID) -> Bool {
        contains(where: {
            $0.isEqualTo(caseInsensitive: bundleID)
        })
    }
}
