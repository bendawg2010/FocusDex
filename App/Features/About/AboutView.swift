import SwiftUI

/// The on-brand About panel for FocusDex.
///
/// Designed to feel like the macOS About box but tuned for the Notchyverse —
/// dark card background, animated mascot, gradient wordmark, and a Sigil
/// tucked into the corner for a bit of arcane sparkle.
struct AboutView: View {
    let onClose: () -> Void

    @State private var bob: CGFloat = 0
    @State private var waving = false

    // MARK: - Bundle metadata

    private var version: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
    }

    private var build: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"
    }

    private var sprite: [String] {
        waving ? Sprites.notchyWave : Sprites.notchy
    }

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Card background with brand glow.
            RoundedRectangle(cornerRadius: 24)
                .fill(Theme.popoverBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(
                            LinearGradient(
                                colors: [Theme.magenta.opacity(0.5), Theme.blue.opacity(0.3)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Theme.magenta.opacity(0.35), radius: 24, x: 0, y: 8)

            // Decorative sigil — corner sparkle.
            Sigil(tier: 4, size: 44)
                .opacity(0.65)
                .padding(14)

            VStack(spacing: 14) {
                // 1. Bobbing Notchy mascot.
                PixelArt(
                    grid: sprite,
                    scale: 3,
                    glowColor: Theme.magenta.opacity(0.6),
                    glowRadius: 14
                )
                .offset(y: bob)
                .padding(.top, 18)

                // 2. Animated wordmark.
                FocusDexWordmark(fontSize: 38)

                // 3. Tagline.
                Text("Catch your year of work.")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)

                // 4. Version + build pill.
                Text("v\(version) (\(build))")
                    .font(.system(size: 11, weight: .heavy, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.85))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule().fill(
                            LinearGradient(
                                colors: [Theme.magenta.opacity(0.35), Theme.blue.opacity(0.35)],
                                startPoint: .leading, endPoint: .trailing
                            )
                        )
                    )
                    .overlay(Capsule().strokeBorder(Theme.magenta.opacity(0.5), lineWidth: 0.5))

                // 5. Author line.
                Text("Made by @bendawg2010 in the Notchyverse")
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundStyle(Theme.mint)

                Divider().opacity(0.25).padding(.horizontal, 32)

                // 6. Acknowledgments.
                VStack(spacing: 4) {
                    sectionHeader("Acknowledgments")
                    creditRow("Claude", "design + code partner", Theme.magenta)
                    creditRow("Sparkle", "auto-update framework (soon)", Theme.blue)
                    creditRow("SwiftUI", "the canvas itself", Theme.mint)
                }
                .padding(.horizontal, 24)

                // 7. Links row.
                HStack(spacing: 10) {
                    linkPill("GitHub", system: "chevron.left.forwardslash.chevron.right",
                             url: "https://github.com/bendawg2010/FocusDex", color: Theme.blue)
                    linkPill("Tip Jar", system: "dollarsign.circle.fill",
                             url: "https://cash.app/$Dryeetsolutions", color: Theme.mint)
                    linkPill("Sponsor", system: "heart.fill",
                             url: "https://github.com/sponsors/bendawg2010", color: Theme.pink)
                    linkPill("Twitter", system: "bird.fill",
                             url: "https://twitter.com/bendawg2010", color: Theme.magenta)
                }
                .padding(.top, 2)

                // 8. Notchyverse fam.
                VStack(spacing: 5) {
                    sectionHeader("Notchyverse fam")
                    HStack(spacing: 6) {
                        famPill("NotchPop", url: "#")
                        famPill("WallPop", url: "#")
                        famPill("Boulder", url: "#")
                        famPill("SkyJournal", url: "#")
                        famPill("Campfire", url: "#")
                    }
                }

                Spacer(minLength: 4)

                // 10. License + Close.
                VStack(spacing: 10) {
                    Text("MIT licensed · free forever")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundStyle(.secondary)
                        .kerning(0.5)

                    Button(action: onClose) {
                        Text("Close")
                            .frame(maxWidth: 140)
                    }
                    .buttonStyle(PrimaryGradientButtonStyle())
                    .keyboardShortcut(.cancelAction)
                }
                .padding(.bottom, 18)
            }
            .padding(.horizontal, 20)
        }
        .frame(width: 380, height: 620)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) {
                bob = -4
            }
            // Swap wave frame every ~1.2s for a sprite-anim effect.
            Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) { _ in
                waving.toggle()
            }
        }
    }

    // MARK: - Subviews

    private func sectionHeader(_ text: String) -> some View {
        Text(text.uppercased())
            .font(.system(size: 9, weight: .black, design: .rounded))
            .kerning(1.4)
            .foregroundStyle(Theme.yellow.opacity(0.85))
    }

    private func creditRow(_ name: String, _ note: String, _ tint: Color) -> some View {
        HStack(spacing: 6) {
            Circle().fill(tint).frame(width: 5, height: 5)
            Text(name).font(.system(size: 11, weight: .heavy, design: .rounded))
                .foregroundStyle(.white.opacity(0.92))
            Text("·").foregroundStyle(.secondary)
            Text(note).font(.system(size: 11, design: .rounded))
                .foregroundStyle(.secondary)
            Spacer()
        }
    }

    private func linkPill(_ label: String, system: String, url: String, color: Color) -> some View {
        Link(destination: URL(string: url) ?? URL(string: "https://focusdex.app")!) {
            HStack(spacing: 4) {
                Image(systemName: system).font(.system(size: 10, weight: .heavy))
                Text(label).font(.system(size: 10, weight: .heavy, design: .rounded))
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule().fill(
                    LinearGradient(
                        colors: [color.opacity(0.85), color.opacity(0.55)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )
            )
            .overlay(Capsule().strokeBorder(color.opacity(0.9), lineWidth: 0.5))
            .shadow(color: color.opacity(0.5), radius: 6, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }

    private func famPill(_ name: String, url: String) -> some View {
        Link(destination: URL(string: url) ?? URL(string: "https://focusdex.app")!) {
            Text(name)
                .font(.system(size: 9, weight: .black, design: .rounded))
                .kerning(0.5)
                .foregroundStyle(.white.opacity(0.92))
                .padding(.horizontal, 7)
                .padding(.vertical, 3)
                .background(
                    Capsule().fill(Color.white.opacity(0.06))
                )
                .overlay(Capsule().strokeBorder(Theme.mint.opacity(0.45), lineWidth: 0.5))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    AboutView(onClose: {})
        .padding(24)
        .background(Color.black)
}
