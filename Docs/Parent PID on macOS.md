# Parent PID on macOS

## Preface

On Linux/Unix systems, the BSD info API can be used to determine a process's parent PID.

However, on macOS Apple implements a top-level `launchd` process (always with a PID of `1`) that is responsible for spawning all other processes in the system, with few exceptions. That is why most processes report their parent PID as `1`.

When running the **Activity Monitor** utility application bundled with macOS, it is possible to view processes hierarchically ("All Processes, Hierarchically") in a way that is able to show a nesting tree structure of process spawns.

## Public API and Terminal Commands

For that reason, the available public API for querying the system's processes (`proc_bsdinfo`, `NSRunningApplication`, etc.) is almost useless for determining what a processes's actual parent process relationship is:

- `proc_bsdinfo.pbi_ppid == 1`

It is also not possible to reveal this relationship with most terminal commands. The usual suspects will all return a parent PID of `1`:

- `ps -o ppid= <pid>` (the space after `ppid=` is important) ([Reference](https://askubuntu.com/a/153979))
- (`pstree` only works on Linux)

## Private / Privileged API and Terminal Commands

The domain of this relationship belongs with the launch daemon, and is a privileged command which requires `sudo`:

- `sudo launchctl procinfo <pid> | grep responsible` ([Reference](https://stackoverflow.com/a/79856136/2805570))

Additionally, there is allegedly a private API to retrieve this information:

- `responsibility_get_pid_responsible_for_pid` from `libquarantine` ([Reference](https://apple.stackexchange.com/a/327353/51641))

```c
typedef pid_t (*pidResolver)(pid_t pid);
pidResolver resolver = dlsym(RTLD_NEXT, "responsibility_get_pid_responsible_for_pid");
pid_t trueParentPid = resolver(pid);
```

However it is a private API that is undocumented that requires root privileges. ([Reference](https://stackoverflow.com/a/54430777/2805570))

As a commenter notes:

> The symbol comes from `libquarantine.dylib`, which calls out to `Quarantine.kext` in the kernel to copy this information out of the process.
