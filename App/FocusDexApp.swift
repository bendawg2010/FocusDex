import SwiftUI

@main
struct FocusDexApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        Settings { SettingsView() }
    }
}
