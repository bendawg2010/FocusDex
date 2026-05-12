import Foundation
import ServiceManagement

/// Thin wrapper around `SMAppService.mainApp` for macOS 13+.
enum LaunchAtLogin {
    static var isEnabled: Bool {
        get { SMAppService.mainApp.status == .enabled }
        set { newValue ? enable() : disable() }
    }

    static func enable() {
        do { try SMAppService.mainApp.register() }
        catch { NSLog("FocusDex: launch-at-login enable failed: \(error)") }
    }

    static func disable() {
        do { try SMAppService.mainApp.unregister() }
        catch { NSLog("FocusDex: launch-at-login disable failed: \(error)") }
    }
}
