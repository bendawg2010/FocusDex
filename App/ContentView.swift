import SwiftUI

struct ContentView: View {
    @EnvironmentObject var focus: FocusManager
    @EnvironmentObject var dex: DexStore
    @AppStorage(Persistence.Keys.hasChosenStarter) private var hasChosenStarter = false
    @State private var tab: Tab = .focus

    enum Tab: String, CaseIterable, Identifiable {
        case focus, dex, balls
        var id: String { rawValue }
        var icon: String {
            switch self {
            case .focus: return "timer"
            case .dex:   return "square.grid.3x3.fill"
            case .balls: return "circle.hexagongrid.fill"
            }
        }
        var label: String { rawValue.capitalized }
    }

    var body: some View {
        ZStack {
            OrbBackground()

            if !hasChosenStarter {
                OnboardingView()
                    .transition(.opacity.combined(with: .scale(scale: 1.02)))
            } else {
                VStack(spacing: 0) {
                    Header()
                    TabBar(tab: $tab)
                        .padding(.horizontal, 14)
                        .padding(.top, 6)
                        .padding(.bottom, 4)

                    Group {
                        switch tab {
                        case .focus: FocusTab()
                        case .dex:   DexTab()
                        case .balls: BallsTab()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.opacity)

                    Footer()
                }
                .animation(.easeInOut(duration: 0.18), value: tab)
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.85), value: hasChosenStarter)
        .preferredColorScheme(.dark)
    }
}

// MARK: - Header

private struct Header: View {
    @EnvironmentObject var dex: DexStore
    @EnvironmentObject var focus: FocusManager

    var body: some View {
        HStack(alignment: .center) {
            AnimatedGradientText(
                text: "FocusDex",
                font: .system(size: 20, weight: .black, design: .rounded)
            )

            Spacer()

            HStack(spacing: 4) {
                Image(systemName: "flame.fill")
                    .foregroundStyle(Theme.pink)
                    .font(.system(size: 10))
                Text("\(focus.currentStreak)")
                    .font(.caption.weight(.heavy).monospacedDigit())
                Text("·")
                    .foregroundStyle(.secondary)
                Text("\(dex.caught.count)/147")
                    .font(.caption.weight(.bold).monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.white.opacity(0.06), in: Capsule())
            .overlay(Capsule().strokeBorder(Color.white.opacity(0.08), lineWidth: 0.5))
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }
}

// MARK: - Custom tab bar

private struct TabBar: View {
    @Binding var tab: ContentView.Tab

    var body: some View {
        HStack(spacing: 6) {
            ForEach(ContentView.Tab.allCases) { t in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                        tab = t
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: t.icon).font(.system(size: 10, weight: .bold))
                        Text(t.label).font(.caption.weight(.heavy))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
                    .frame(maxWidth: .infinity)
                    .background(
                        ZStack {
                            if tab == t {
                                RoundedRectangle(cornerRadius: 9)
                                    .fill(Theme.primaryGradient)
                                    .matchedGeometryEffect(id: "tab", in: ns)
                            }
                        }
                    )
                    .foregroundStyle(tab == t ? .white : Color.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(Color.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.white.opacity(0.08), lineWidth: 0.5))
    }

    @Namespace private var ns
}

// MARK: - Footer

private struct Footer: View {
    var body: some View {
        HStack(spacing: 12) {
            Link(destination: URL(string: "https://github.com/bendawg2010/FocusDex")!) {
                Label("Star", systemImage: "star.fill")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)

            Link(destination: URL(string: "https://cash.app/$Dryeetsolutions")!) {
                Label("Tip", systemImage: "dollarsign.circle.fill")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(Theme.mint)
            }
            .buttonStyle(.plain)

            Spacer()

            Text("MIT · Notchyverse")
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.black.opacity(0.3))
    }
}
