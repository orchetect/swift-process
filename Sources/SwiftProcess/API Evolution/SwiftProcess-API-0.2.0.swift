//
//  SwiftProcess-API-0.2.0.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) || targetEnvironment(macCatalyst)

extension PID.AncestorsIterator {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "init(pid:isPID0Included:isPID1Included:)")
    nonisolated
    public init(pid: PID, isInitialIncluded: Bool, isPID1Included: Bool) {
        self.init(pid: pid, isInitialIncluded: isInitialIncluded, isPID0Included: true, isPID1Included: isPID1Included)
    }
}

extension PID.AncestorsSequence {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "init(pid:isPID0Included:isPID1Included:)")
    nonisolated
    public init(initialPID: PID, isInitialIncluded: Bool, isPID1Included: Bool) {
        self.init(initialPID: initialPID, isInitialIncluded: isInitialIncluded, isPID0Included: true, isPID1Included: isPID1Included)
    }

    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "init(pid:isPID0Included:isPID1Included:)")
    nonisolated
    public init(initialPID: PID.RawValue, isInitialIncluded: Bool, isPID1Included: Bool) {
        self.init(initialPID: initialPID, isInitialIncluded: isInitialIncluded, isPID0Included: true, isPID1Included: isPID1Included)
    }
}

#endif
