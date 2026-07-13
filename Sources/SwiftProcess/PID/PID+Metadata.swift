//
//  PID+Metadata.swift
//  SwiftProcess • https://github.com/orchetect/swift-process
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - BSD Info

@available(macOS 10.15, macCatalyst 13, *)
@available(iOS, deprecated, message: "Not available on iOS.")
@available(tvOS, deprecated, message: "Not available on tvOS.")
@available(watchOS, deprecated, message: "Not available on watchOS.")
@available(visionOS, deprecated, message: "Not available on visionOS.")
extension PID {
    /// Returns the command name of the process (Limited to 15 characters).
    /// If the process is no longer running or no name is returned from the system, `nil` is returned.
    ///
    /// > Note: Process info lookup is only available on macOS and Mac Catalyst.
    /// > On all other platforms, this property always returns `nil`.
    nonisolated
    public var commandName: String? {
        #if os(macOS) || targetEnvironment(macCatalyst)
        // proc_bsdshortinfo often has more information on non-user processes than proc_bsdinfo
        return bsdShortInfo?.getCommandName() ?? bsdInfo?.getCommandName()
        #else
        return nil
        #endif
    }

    /// Returns the name of the process.
    /// If the process is no longer running or no name is returned from the system, `nil` is returned.
    ///
    /// > Note: Process info lookup is only available on macOS and Mac Catalyst.
    /// > On all other platforms, this property always returns `nil`.
    nonisolated
    public var name: String? {
        #if os(macOS) || targetEnvironment(macCatalyst)
        guard let bsdInfo else { return nil }
        return bsdInfo.getName()
        #else
        return nil
        #endif
    }
}

// MARK: - SysCtl Info

@available(macOS 10.15, macCatalyst 13, *)
@available(iOS, deprecated, message: "Not available on iOS.")
@available(tvOS, deprecated, message: "Not available on tvOS.")
@available(watchOS, deprecated, message: "Not available on watchOS.")
@available(visionOS, deprecated, message: "Not available on visionOS.")
extension PID {
    /// Returns the launch date and time of the process as `Date`.
    /// If the process is no longer running or an error occurred, `nil` is returned.
    ///
    /// > Note: Process info lookup is only available on macOS and Mac Catalyst.
    /// > On all other platforms, this property always returns `nil`.
    nonisolated
    public var launchDate: Date? {
        #if os(macOS) || targetEnvironment(macCatalyst)
        guard let secondsSinceEpoch = try? sysctlInfo.kp_proc.p_starttime.tv_sec else { return nil }
        return Date(timeIntervalSince1970: TimeInterval(secondsSinceEpoch))
        #else
        return nil
        #endif
    }

    /// Returns the uptime of the process in seconds.
    /// If the process is no longer running or an error occurred, `nil` is returned.
    ///
    /// > Note: Process info lookup is only available on macOS and Mac Catalyst.
    /// > On all other platforms, this property always returns `nil`.
    nonisolated
    public var uptime: TimeInterval? {
        guard let launchDate else { return nil }
        return Date().timeIntervalSince(launchDate)
    }
}

// MARK: - Executable Path

@available(macOS 10.15, macCatalyst 13, *)
@available(iOS, deprecated, message: "Not available on iOS.")
@available(tvOS, deprecated, message: "Not available on tvOS.")
@available(watchOS, deprecated, message: "Not available on watchOS.")
@available(visionOS, deprecated, message: "Not available on visionOS.")
extension PID {
    nonisolated
    static let PROC_PIDPATHINFO_MAXSIZE: UInt32 = 4096

    nonisolated
    static let kProcPidPathInfoMaxSize = Int(PROC_PIDPATHINFO_MAXSIZE)

    /// Returns the path to the executable for the process.
    ///
    /// > Note: Path lookup is only available on macOS and Mac Catalyst.
    /// > On all other platforms, this property always returns an empty string.

    nonisolated
    public var executablePath: String? {
        #if os(macOS) || targetEnvironment(macCatalyst)
        var path = [CChar](repeating: 0x00, count: Self.kProcPidPathInfoMaxSize)

        // returns number of bytes if successful, or -1 if it failed
        let result = proc_pidpath(rawValue, &path, Self.PROC_PIDPATHINFO_MAXSIZE)
        guard result > 0 else { return nil }

        let string = String(cString: &path)
        guard !string.isEmpty else { return nil }
        return string
        #else
        return ""
        #endif
    }

    /// Returns the file URL of the executable for the process.
    ///
    /// > Note: Path lookup is only available on macOS and Mac Catalyst.
    /// > On all other platforms, this property always returns an empty URL.
    nonisolated
    public var executableURL: URL? {
        guard let executablePath else { return nil }
        return URL(fileURLWithPath: executablePath)
    }

    /// Returns a boolean value describing whether a process with the process identifier
    /// currently exists and belongs to a running process.
    /// If the process is no longer running or an error occurred, `nil` is returned.
    ///
    /// > Note: Process info lookup is only available on macOS and Mac Catalyst.
    /// > On all other platforms, this property always returns `false`.
    nonisolated
    public var isExists: Bool {
        (try? Self.all.contains(self)) == true
    }
}

// MARK: - File Descriptors / Ports

extension PID {
    /// Returns a list of open file and port descriptors for the process.
    /// If the process is no longer running or an error occurred, an empty collection is returned.
    ///
    /// > Note: File descriptor lookup is only available on macOS (not including Mac Catalyst).
    /// > On all other platforms, this property always returns an empty collection.
    nonisolated
    public var fileDescriptors: [FileDescriptorInfo] {
        #if os(macOS) || targetEnvironment(macCatalyst)
        let bufferByteCount = proc_pidinfo(rawValue, PROC_PIDLISTFDS, 0, nil, 0)
        guard bufferByteCount > 0 else { return [] }

        // the buffer is typically sized larger than the number of `proc_fdinfo` elements
        // that proc_pidinfo() actually ends up returning for PROC_PIDLISTFDS.
        let stride = MemoryLayout<proc_fdinfo>.stride
        let maximumPossibleCount = Int(bufferByteCount) / stride
        let fds = [proc_fdinfo](unsafeUninitializedCapacity: maximumPossibleCount) { buffer, initializedCount in
            let initializedByteCount = proc_pidinfo(rawValue, PROC_PIDLISTFDS, 0, buffer.baseAddress!, bufferByteCount)
            assert(Int(initializedByteCount).isMultiple(of: stride))
            // this actual count is often less than the "maximum possible" count (original buffer size)
            let actualCount = Int(initializedByteCount) / stride
            initializedCount = actualCount
        }

        let fileDescriptors = fds.compactMap { FileDescriptorInfo(fdInfo: $0, pid: self) }

        return fileDescriptors
        #else
        return []
        #endif
    }

    #if os(macOS) || targetEnvironment(macCatalyst)

    /// Returns a list of open file and mach port descriptors for the process.
    /// If the process is no longer running or an error occurred, an empty collection is returned.
    ///
    /// > Note: File descriptor lookup is only available on macOS (not including Mac Catalyst).
    /// > On all other platforms, this property always returns an empty collection.
    nonisolated
    public var filePorts: [proc_fileportinfo] {
        let bufferByteCount = proc_pidinfo(rawValue, PROC_PIDLISTFILEPORTS, 0, nil, 0)
        guard bufferByteCount > 0 else { return [] }

        // the buffer is typically sized larger than the number of `proc_fileportinfo` elements
        // that proc_pidinfo() actually ends up returning for PROC_PIDLISTFILEPORTS.
        let stride = MemoryLayout<proc_fileportinfo>.stride
        let maximumPossibleCount = Int(bufferByteCount) / stride
        let fpInfos = [proc_fileportinfo](unsafeUninitializedCapacity: maximumPossibleCount) { buffer, initializedCount in
            let initializedByteCount = proc_pidinfo(rawValue, PROC_PIDLISTFILEPORTS, 0, buffer.baseAddress!, bufferByteCount)
            assert(Int(initializedByteCount).isMultiple(of: stride))
            // this actual count is often less than the "maximum possible" count (original buffer size)
            let actualCount = Int(initializedByteCount) / stride
            initializedCount = actualCount
        }

        return fpInfos
    }

    #endif
}

// MARK: - lsof Descriptors

extension PID {
    /// Returns the file and port descriptors returned by the `lsof` command.
    /// This typically contains a more thorough list of descriptors than calling ``fileDescriptors`` or ``filePorts``.
    ///
    /// > Note: This method is time-consuming and on average completes in several hundred millisconds, but
    /// > may take several seconds to complete.
    ///
    /// > Note: File descriptor lookup is only available on macOS (not including Mac Catalyst).
    /// > On all other platforms, this property always throws an error.
    @available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *)
    nonisolated
    public func lsofDescriptors() throws(SystemError) -> [String] {
        #if os(macOS)
        var command = try _lsofDescriptorsCommandFactory()
        do { try command.runAndWait() }
        catch { throw .commandExecutionFailed(command: "lsof", reason: error.localizedDescription) }
        let names = try _lsofDescriptorNames(fromCompletedCommand: command)
        return names
        #else
        throw .notSupported
        #endif
    }

    /// Returns the file and port descriptors returned by the `lsof` command.
    /// This typically contains a more thorough list of descriptors than calling ``fileDescriptors`` or ``filePorts``.
    ///
    /// > Note: This method is time-consuming and on average completes in several hundred millisconds, but
    /// > may take several seconds to complete.
    ///
    /// > Note: File descriptor lookup is only available on macOS (not including Mac Catalyst).
    /// > On all other platforms, this property always throws an error.
    @available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *)
    @concurrent
    public func lsofDescriptors() async throws(SystemError) -> [String] {
        #if os(macOS)
        var command = try _lsofDescriptorsCommandFactory()
        do { try await command.runAndWait() }
        catch { throw .commandExecutionFailed(command: "lsof", reason: error.localizedDescription) }
        let names = try _lsofDescriptorNames(fromCompletedCommand: command)
        return names
        #else
        throw .notSupported
        #endif
    }

    #if os(macOS)

    @available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *)
    nonisolated
    func _lsofDescriptorsCommandFactory() throws(SystemError) -> CommandProcess {
        #if DEBUG
        // When the Xcode debugger is attached, calling `lsof` on the Xcode process causes the current process
        // to hang.
        guard !ancestors(isInitialIncluded: true)
            .contains(where: { $0.name == "Xcode" })
        else { throw .notSupported }
        #endif

        // don't call `lsof` for private frameworks, which can cause hangs due to insufficient permissions
//        guard !ancestors(isInitialIncluded: true)
//            .contains(where: { $0.executablePath?.starts(with: "/System/Library/PrivateFrameworks") == true })
//        else { throw .notSupported }

        // Reference for parsing `lsof` output:
        // https://stackoverflow.com/questions/44240818/formatting-lsof-output-into-parsable-structure

        // -F option trailing IDs:
        //
        // ID  Field Description
        // --  -----------------
        // a   access: r = read; w = write; u = read/write
        // c   command name
        // d   device character code
        // D   major/minor device number as 0x<hex>
        // f   file descriptor
        // G   file flaGs
        // i   inode number
        // k   link count
        // K   task ID (TID)
        // l   lock: r/R = read; w/W = write; u = read/write
        // L   login name
        // m   marker between repeated output
        // M   task comMand name
        // n   comment, name, Internet addresses
        // o   file offset as 0t<dec> or 0x<hex>
        // p   process ID (PID)
        // g   process group ID (PGID)
        // P   protocol name
        // r   raw device number as 0x<hex>
        // R   paRent PID
        // s   file size
        // S   stream module and device names
        // t   file type
        // T   TCP/TPI info
        // u   user ID (UID)
        // 0   (zero) use NUL field terminator instead of NL

        // when using the -F option with `lsof`, each PID always begins with the PID number header,
        // which starts with "p" followed by the PID (for example, PID 600 would be output as `p600`
        // with a trailing newline character (unless the `-Fn` option is specified, in which case it
        // will have a trailing null byte instead of a newline).
        //
        // -Fn0 returns each descriptor as a single line with its name, having fields separated by a null byte

        let arguments: [String] = ["-b", "-l", "-Fn0", "-S 2", "-w"]
        let argumentsString = arguments.joined(separator: " ") + " "

        let command = CommandProcess(command: "lsof \(argumentsString)-p \(rawValue)")
        return command
    }

    @available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *)
    nonisolated
    func _lsofDescriptorNames(fromCompletedCommand command: CommandProcess) throws(SystemError) -> [String] {
        // if output is empty or the first line is not a header line, the likely cause is that the PID does
        // not exist or the current process does not have enough permissions
        let lines = command.output
        guard lines.first == "p\(rawValue)\0" else {
            throw .pidDoesNotExist
        }

        let descriptorLines = lines.dropFirst() // remove header line
        var names: [String] = []
        for descriptorLine in descriptorLines {
            let fields = descriptorLine
                .split(separator: "\0", omittingEmptySubsequences: true)
            guard fields.count == 2 else {
                assertionFailure("Unexpected lsof output.")
                continue
            }

            // field 1: descriptor type
            let descType = fields[fields.startIndex]
            _ = descType // ignore; not used at this time.

            // field 2: name
            let name = fields[fields.startIndex.advanced(by: 1)]
            // name field is prefixed by `n`
            guard name.hasPrefix("n") else {
                assertionFailure("Unexpected lsof output.")
                continue
            }
            names.append(String(name[name.index(name.startIndex, offsetBy: 1)...]))
        }
        return names
    }

    #endif
}
