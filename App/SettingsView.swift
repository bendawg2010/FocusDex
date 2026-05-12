import SwiftUI

struct SettingsView: View {
    @AppStorage(Persistence.Keys.soundEnabled) private var soundEnabled = true
    @State private var launchAtLogin = LaunchAtLogin.isEnabled
    @State private var confirmReset = false

    var body: some View {
        Form {
            Section("General") {
                Toggle("Launch FocusDex at login", isOn: $launchAtLogin)
                    .onChange(of: launchAtLogin) { new in
                        LaunchAtLogin.isEnabled = new
                    }
                Toggle("Sound effects", isOn: $soundEnabled)
            }

            Section("About") {
                LabeledContent("Version", value: appVersion)
                Link("GitHub repo", destination: URL(string: "https://github.com/bendawg2010/FocusDex")!)
                Link("Tip jar — $Dryeetsolutions", destination: URL(string: "https://cash.app/$Dryeetsolutions")!)
                Link("Sponsor", destination: URL(string: "https://github.com/sponsors/bendawg2010")!)
            }

            Section("Danger zone") {
                Button(role: .destructive) {
                    confirmReset = true
                } label: {
                    Label("Reset all progress", systemImage: "trash")
                }
            }
        }
        .formStyle(.grouped)
        .frame(width: 460, height: 380)
        .confirmationDialog(
            "Reset all FocusDex progress?",
            isPresented: $confirmReset,
            titleVisibility: .visible
        ) {
            Button("Wipe everything", role: .destructive) {
                Persistence.wipe()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This deletes your Pokédex, Pokéballs, streak, and starter choice. Cannot be undone.")
        }
    }

    private var appVersion: String {
        let v = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "?"
        let b = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "?"
        return "\(v) (\(b))"
    }
}
