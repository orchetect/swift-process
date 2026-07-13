//
//  PID+Static.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - Static Constructors

extension PID {
    /// PID 0.
    ///
    /// Process ID "0" is assigned to kernel processes.
    @inline(__always) nonisolated
    public static let pid0 = PID(0)

    /// PID 1.
    ///
    /// Process ID "1" is the first user-mode application started by the kernel, and its parent is always PID 0.
    /// All other processes in the system are a descendent of PID 1.
    ///
    /// On Apple platforms, the process with PID 1 is always `launchd`.
    ///
    /// In most Linux distributions, the process with PID 1 is `init` or a more modern replacement like `systemd`.
    @inline(__always) nonisolated
    public static let pid1 = PID(1)
}

// MARK: - Current Process

extension PID {
    /// Returns the process identifier for the current process.
    nonisolated
    public static var current: PID {
        PID(ProcessInfo.processInfo.processIdentifier)
    }
}

// MARK: - Random

extension PID {
    /// Returns a random process identifier that does not exist (does not belong to any process
    /// currently running in the system).
    ///
    /// This is mainly useful for debugging and unit testing and has no real use case in production code.
    ///
    /// > Note: Process info lookup is only available on macOS and Mac Catalyst.
    /// > On all other platforms, this property always returns an empty sequence.
    @available(macOS 10.15, macCatalyst 13, *)
    @available(iOS, deprecated, message: "Not available on iOS.")
    @available(tvOS, deprecated, message: "Not available on tvOS.")
    @available(watchOS, deprecated, message: "Not available on watchOS.")
    @available(visionOS, deprecated, message: "Not available on visionOS.")
    nonisolated
    public static var randomUnused: PID {
        get throws(PIDError) {
            let allPIDs = try Self.all
            var pid: pid_t = 0
            while pid == 0 || allPIDs.contains(where: { $0.rawValue == pid }) {
                pid = PID.RawValue.random(in: 1000 ... PID.RawValue.max)
            }
            return PID(pid)
        }
    }
}

// MARK: - System Processes Iterators

extension PID {
    /// Returns process identifiers (PIDs) for all currently running processes in the system.
    /// This returns a sequence that iterates lazily.
    ///
    /// > Note: Process info lookup is only available on macOS and Mac Catalyst.
    /// > On all other platforms, this property always returns an empty sequence.
    @available(macOS 10.15, macCatalyst 13, *)
    @available(iOS, deprecated, message: "Not available on iOS.")
    @available(tvOS, deprecated, message: "Not available on tvOS.")
    @available(watchOS, deprecated, message: "Not available on watchOS.")
    @available(visionOS, deprecated, message: "Not available on visionOS.")
    nonisolated
    public static var all: InfoSequence<PID> {
        get throws(PIDError) {
            #if os(macOS) || targetEnvironment(macCatalyst)
            let iterator = try InfoIterator(elementTransform: {
                PID($0.kp_proc.p_pid)
            })
            return InfoSequence(iterator)
            #else
            return InfoSequence(InfoIterator<PID>())
            #endif
        }
    }

    /// Returns process identifiers (PIDs) for all currently running processes in the system.
    /// This returns a sequence that iterates lazily.
    ///
    /// This method allows excluding specific identifiers from the sequence.
    /// Commonly excluded identifiers include PID 0 (``pid0``), PID 1 (``pid1``), and the
    /// current process (``current``).
    ///
    /// > Note: Process info lookup is only available on macOS and Mac Catalyst.
    /// > On all other platforms, this property always returns an empty sequence.
    @available(macOS 10.15, macCatalyst 13, *)
    @available(iOS, deprecated, message: "Not available on iOS.")
    @available(tvOS, deprecated, message: "Not available on tvOS.")
    @available(watchOS, deprecated, message: "Not available on watchOS.")
    @available(visionOS, deprecated, message: "Not available on visionOS.")
    nonisolated
    public static func all(
        excluding excludedPIDs: some Sequence<PID>
    ) throws(PIDError) -> InfoSequence<PID> {
        #if os(macOS) || targetEnvironment(macCatalyst)
        let iterator = try InfoIterator<PID>(elementTransform: {
            let rawPID = $0.kp_proc.p_pid
            guard !excludedPIDs.contains(pid: rawPID) else { return nil }
            return PID(rawPID)
        })
        return InfoSequence(iterator)
        #else
        return InfoSequence(InfoIterator<PID>())
        #endif
    }
}
