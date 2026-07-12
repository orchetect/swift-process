//
//  PID+Static Tests.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftProcess
import Testing

@Suite
struct PID_Static_Tests {
    // MARK: - Static Constructors

    @Test
    func pid0() {
        #expect(PID.pid0.rawValue == 0)
    }

    @Test
    func pid1() {
        #expect(PID.pid1.rawValue == 1)
    }

    @Test
    func current() {
        #expect(PID.current.rawValue == ProcessInfo.processInfo.processIdentifier)
    }

    #if os(macOS) || targetEnvironment(macCatalyst)
    
    // MARK: - System Processes Iterators

    @Test
    func all() throws {
        let pids = try Array(PID.all)
        #expect(!pids.isEmpty)
        print("PID count:", pids.count)
    }

    @Test
    func all_excluding() throws {
        let pids = try Array(PID.all)
        #expect(!pids.isEmpty)

        let pidsWithout0Or1 = try Array(PID.all(excluding: [.pid0, .pid1]))
        #expect(!pidsWithout0Or1.isEmpty)

        #expect(!pidsWithout0Or1.contains { $0.rawValue == 0 })
        #expect(!pidsWithout0Or1.contains { $0.rawValue == 1 })
    }

    @Test
    func randomUnused() throws {
        let id: PID = try .randomUnused
        #expect(try !PID.all.contains(id))
    }

    #endif
}
