//
//  PID Tests.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) || targetEnvironment(macCatalyst) || os(Linux)

import SwiftProcess
import Testing

@Suite
struct PID_Tests {
    @Test
    func init_zero() {
        let id = PID(0)
        #expect(id.rawValue == 0)
    }

    @Test
    func init_typical() {
        let id = PID(123)
        #expect(id.rawValue == 123)
    }

    @Test
    func init_rawValue_zero() {
        let id = PID(rawValue: 0)
        #expect(id.rawValue == 0)
    }

    @Test
    func init_rawValue_typical() {
        let id = PID(rawValue: 123)
        #expect(id.rawValue == 123)
    }

    @Test
    func expressibleByIntegerLiteral_assign() {
        let id: PID = 123
        #expect(id.rawValue == 123)
    }

    @Test
    func expressibleByIntegerLiteral_cast() {
        let id = 123 as PID
        #expect(id.rawValue == 123)
    }

    @Test
    func static_pid1() {
        let id: PID = .pid1
        #expect(id.rawValue == 1)
    }

    @Test
    func stringInterpolation() {
        let id: PID = 123
        #expect("\(id)" == "123")
    }
}

#endif
