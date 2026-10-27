import Foundation

// launchd starts this when the agent is registered. Proof it ran is a file.
let variant = ProcessInfo.processInfo.environment["SPIKE_VARIANT"] ?? "unknown"
let line = "ran at \(Date()) as pid \(getpid())\n"
try? line.write(toFile: "/tmp/spike-agent-\(variant)", atomically: true, encoding: .utf8)
