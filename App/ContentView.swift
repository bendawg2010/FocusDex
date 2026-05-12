import SwiftUI

struct ContentView: View {
    @EnvironmentObject var focus: FocusManager
    @EnvironmentObject var dex: DexStore
    @State private var tab: Tab = .focus

    enum Tab: String, CaseIterable { case focus, dex, balls }

    var body: some View {
        VStack(spacing: 0) {
            Header()
            Picker("", selection: $tab) {
                ForEach(Tab.allCases, id: \.self) { t in
                    Text(t.rawValue.capitalized).tag(t)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)
            .padding(.top, 10)

            Group {
                switch tab {
                case .focus: FocusTab()
                case .dex:   DexTab()
                case .balls: BallsTab()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Footer()
        }
        .background(Color(.windowBackgroundColor))
    }
}

private struct Header: View {
    var body: some View {
        HStack {
            Text("FocusDex").font(.system(size: 18, weight: .black, design: .rounded))
            Spacer()
            Text("v0.1.0").font(.caption).foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.top, 14)
    }
}

private struct Footer: View {
    var body: some View {
        HStack {
            Link("⭐ GitHub", destination: URL(string: "https://github.com/bendawg2010/FocusDex")!)
            Spacer()
            Link("💸 Tip", destination: URL(string: "https://cash.app/$Dryeetsolutions")!)
        }
        .font(.caption)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.thinMaterial)
    }
}

struct SettingsView: View {
    var body: some View {
        Form {
            Text("FocusDex settings")
            Text("Coming soon.").foregroundStyle(.secondary)
        }
        .padding()
        .frame(width: 420, height: 240)
    }
}
