//
//  PID+Metadata.swift
//  swift-process
//
//  Created by Steffan Andrews on 2026-07-11.
//

#if os(macOS) || targetEnvironment(macCatalyst)

import Foundation
import Security

// MARK: - Code Signing

extension PID {
    enum CodeSigningInformationFlags: UInt32 {
        case internalInformation
        case signingInformation
        case requirementInformation
        case dynamicInformation
        case contentInformation
        case skipResourceDirectory
        case calculateCMSDigest

        nonisolated
        var rawValue: UInt32 {
            switch self {
            case .internalInformation: kSecCSInternalInformation
            case .signingInformation: kSecCSSigningInformation
            case .requirementInformation: kSecCSRequirementInformation
            case .dynamicInformation: kSecCSDynamicInformation
            case .contentInformation: kSecCSContentInformation
            case .skipResourceDirectory: kSecCSSkipResourceDirectory
            case .calculateCMSDigest: kSecCSCalculateCMSDigest
            }
        }

        nonisolated
        var asSecCSFlags: SecCSFlags {
            SecCSFlags(rawValue: rawValue)
        }
    }

    /// Returns the code signing info dictionary for the process's executable.
    /// This returns `nil` if no running application matches the process identifier.
    nonisolated
    public var codeSigningInfo: [String: Any]? {
        var signingInfo: CFDictionary?
        guard let securityStaticCode = securityStaticCode else { return nil }

        let result = SecCodeCopySigningInformation(
            securityStaticCode,
            CodeSigningInformationFlags.signingInformation.asSecCSFlags,
            &signingInfo
        )

        guard result == errSecSuccess else { return nil }
        guard let signingInfo = signingInfo as? [String: Any]  else { return nil }

        return signingInfo
    }
}

// MARK: - Utilities

extension PID {
    nonisolated
    private var securityStaticCode: SecStaticCode? {
        guard let executableURL else { return nil }
        return SecStaticCode.make(executableURL: executableURL)
    }
}

extension SecStaticCode {
    nonisolated
    static func make(executableURL: URL) -> SecStaticCode? {
        var secStaticCode: SecStaticCode?

        let result = SecStaticCodeCreateWithPath(
            executableURL as CFURL,
            SecCSFlags(),
            &secStaticCode
        )

        guard result == errSecSuccess else { return nil }

        guard let secStaticCode else { return nil }
        return secStaticCode
    }
}

#endif
