import Foundation
import ServiceManagement

// Usage: Spike <register|unregister|status> <plist name in Contents/Library/LaunchAgents>
let args = CommandLine.arguments
let command = args.count > 1 ? args[1] : "status"
let plist = args.count > 2 ? args[2] : "agent.plist"
let service = SMAppService.agent(plistName: plist)

func name(_ status: SMAppService.Status) -> String {
    switch status {
    case .notRegistered: return "notRegistered"
    case .enabled: return "enabled"
    case .requiresApproval: return "requiresApproval"
    case .notFound: return "notFound"
    @unknown default: return "unknown(\(status.rawValue))"
    }
}

print("bundle: \(Bundle.main.bundlePath)")
do {
    switch command {
    case "register":
        try service.register()
        print("register: ok")
    case "unregister":
        try service.unregister()
        print("unregister: ok")
    default:
        break
    }
} catch let error as NSError {
    print("\(command): error domain=\(error.domain) code=\(error.code) \(error.localizedDescription)")
}
print("status: \(name(service.status))")
