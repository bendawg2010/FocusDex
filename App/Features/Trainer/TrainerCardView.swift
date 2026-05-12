import SwiftUI

/// A "Trainer ID Card" overlay — Pokemon-card style, summarizing the player's
/// FocusDex stats, chosen starter, ball stockpile, and league rank.
///
/// Designed to be presented over the popover content with a dimmed backdrop.
/// Tapping the backdrop or pressing the dismiss button calls `onDismiss`.
struct TrainerCardView: View {
    @EnvironmentObject private var focus: FocusManager
    @EnvironmentObject private var dex: DexStore

    @AppStorage(Persistence.Keys.starterId) private var starterId: Int = 1

    let onDismiss: () -> Void

    // MARK: - Derived values

    private var starterSprite: [String] { Sprites.forCreature(id: starterId) }

    private var starterCreature: Creature? {
        Creature.starters.first(where: { $0.id == starterId })
    }

    /// Type-driven glow color for the portrait halo.
    private var portraitGlow: Color {
        switch starterCreature?.primary {
        case .code:   return Theme.mint
        case .art:    return Theme.pink
        case .doc:    return Theme.yellow
        case .sound:  return Theme.blue
        case .pixel:  return Theme.mint
        case .spirit: return Theme.magenta
        default:      return Theme.magenta
        }
    }

    private var completionPercent: Int {
        Int((dex.completionRatio * 100).rounded())
    }

    private var totalCreatures: Int { 147 }

    private var totalFocusHours: Double { focus.totalFocusMin / 60.0 }

    private var leagueRank: (label: String, color: Color, emoji: String) {
        switch focus.totalFocusMin {
        case ..<60:        return ("Rookie",    Theme.mint,    "🌱")
        case 60..<300:     return ("Apprentice", Theme.blue,   "📘")
        case 300..<1200:   return ("Adept",     Theme.yellow, "⚡️")
        case 1200..<3000:  return ("Veteran",   Theme.pink,   "🛡️")
        default:           return ("Champion",  Theme.magenta, "👑")
        }
    }

    /// Pseudo-unique 8-char trade ID derived from starter + caught count.
    private var tradeID: String {
        let seed = (starterId &* 8675309) &+ (dex.caught.count &* 1337) &+ Int(focus.totalFocusMin)
        let alphabet = Array("0123456789ABCDEFGHJKMNPQRSTVWXYZ")
        var rng = SeededRNG(seed: UInt64(bitPattern: Int64(seed)))
        let chars = (0..<8).map { _ in alphabet[Int(rng.next() % UInt64(alphabet.count))] }
        return String(chars)
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            // Dim backdrop — tap to dismiss
            Color.black.opacity(0.65)
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture { onDismiss() }

            cardBody
                .padding(20)
        }
    }

    private var cardBody: some View {
        VStack(spacing: 14) {
            AnimatedGradientText(
                text: "TRAINER CARD",
                font: .system(size: 22, weight: .black, design: .rounded)
            )
            .kerning(2)

            portrait

            trainerNameBlock

            statsGrid

            ballsRow

            leagueBadge

            tradeIDFooter

            Button(action: onDismiss) {
                Text("CLOSE")
                    .kerning(1.5)
            }
            .buttonStyle(PrimaryGradientButtonStyle())
            .padding(.top, 4)
        }
        .padding(20)
        .background(cardBackground)
        .overlay(cardBorder)
        .overlay(alignment: .topTrailing) {
            Sigil(tier: 4, size: 44)
                .offset(x: -10, y: 10)
                .brandGlow(Theme.mint, radius: 10)
        }
        .overlay(alignment: .topLeading) {
            FocusDexWordmark(fontSize: 12)
                .offset(x: 16, y: 14)
                .opacity(0.85)
        }
        .frame(maxWidth: 340)
        .shadow(color: Theme.magenta.opacity(0.5), radius: 30, y: 12)
        .shadow(color: Theme.blue.opacity(0.3), radius: 50, y: 0)
    }

    // MARK: - Subviews

    private var portrait: some View {
        ZStack {
            // Halo
            RadialGradient(
                colors: [portraitGlow.opacity(0.6), .clear],
                center: .center,
                startRadius: 4,
                endRadius: 90
            )
            .frame(width: 170, height: 170)

            // Frame
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .strokeBorder(
                            LinearGradient(
                                colors: [portraitGlow.opacity(0.9), portraitGlow.opacity(0.2)],
                                startPoint: .top, endPoint: .bottom
                            ),
                            lineWidth: 2
                        )
                )
                .frame(width: 140, height: 140)

            PixelArt(
                grid: starterSprite,
                scale: 6,
                glowColor: portraitGlow.opacity(0.7),
                glowRadius: 14
            )
        }
        .frame(height: 170)
    }

    private var trainerNameBlock: some View {
        VStack(spacing: 2) {
            Text("Trainer Notch")
                .font(.system(size: 18, weight: .black, design: .rounded))
                .foregroundStyle(.white)
            if let c = starterCreature {
                Text("Partner: \(c.name) \(c.dexNumber)")
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.6))
            }
        }
    }

    private var statsGrid: some View {
        let cols = [GridItem(.flexible()), GridItem(.flexible())]
        return LazyVHGrid(columns: cols, spacing: 8) {
            statCell(
                label: "DEX",
                value: "\(completionPercent)%",
                detail: "\(dex.caught.count) / \(totalCreatures)",
                color: Theme.mint
            )
            statCell(
                label: "SESSIONS",
                value: "\(focus.totalSessions)",
                detail: "completed",
                color: Theme.blue
            )
            statCell(
                label: "FOCUS",
                value: String(format: "%.1fh", totalFocusHours),
                detail: "lifetime",
                color: Theme.yellow
            )
            statCell(
                label: "STREAK",
                value: "🔥 \(focus.currentStreak)",
                detail: "🏆 best \(focus.bestStreak)",
                color: Theme.pink
            )
        }
    }

    private func statCell(label: String, value: String, detail: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.system(size: 9, weight: .black, design: .rounded))
                .kerning(1.2)
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 18, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
            Text(detail)
                .font(.system(size: 9, weight: .medium, design: .monospaced))
                .foregroundStyle(.white.opacity(0.55))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(color.opacity(0.35), lineWidth: 1)
        )
    }

    private var ballsRow: some View {
        HStack(spacing: 10) {
            ballPill(count: focus.pokeballs,   tint: Theme.mint)
            ballPill(count: focus.greatBalls,  tint: Theme.blue)
            ballPill(count: focus.ultraBalls,  tint: Theme.yellow)
            ballPill(count: focus.masterBalls, tint: Theme.magenta)
        }
        .padding(.vertical, 4)
    }

    private func ballPill(count: Int, tint: Color) -> some View {
        VStack(spacing: 2) {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [tint, tint.opacity(0.55)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(Circle().strokeBorder(Color.black.opacity(0.6), lineWidth: 1))
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.5), lineWidth: 0.5)
                        .padding(3)
                )
                .frame(width: 28, height: 28)
                .shadow(color: tint.opacity(0.6), radius: 6)
            Text("\(count)")
                .font(.system(size: 11, weight: .heavy, design: .monospaced))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
    }

    private var leagueBadge: some View {
        let rank = leagueRank
        return HStack(spacing: 8) {
            Text(rank.emoji)
                .font(.system(size: 18))
            VStack(alignment: .leading, spacing: 1) {
                Text("LEAGUE RANK")
                    .font(.system(size: 9, weight: .black, design: .rounded))
                    .kerning(1.4)
                    .foregroundStyle(.white.opacity(0.6))
                Text(rank.label.uppercased())
                    .font(.system(size: 14, weight: .black, design: .rounded))
                    .foregroundStyle(rank.color)
                    .kerning(1.0)
            }
            Spacer()
            Image(systemName: "rosette")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(rank.color)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    LinearGradient(
                        colors: [rank.color.opacity(0.18), rank.color.opacity(0.04)],
                        startPoint: .leading, endPoint: .trailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(rank.color.opacity(0.5), lineWidth: 1)
        )
    }

    private var tradeIDFooter: some View {
        HStack(spacing: 6) {
            Image(systemName: "barcode")
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(.white.opacity(0.5))
            Text("TRADE ID")
                .font(.system(size: 9, weight: .black, design: .rounded))
                .kerning(1.2)
                .foregroundStyle(.white.opacity(0.5))
            Text(tradeID)
                .font(.system(size: 11, weight: .heavy, design: .monospaced))
                .foregroundStyle(.white)
                .kerning(2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.4))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(Color.white.opacity(0.08), lineWidth: 0.5)
        )
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 22)
            .fill(
                LinearGradient(
                    colors: [Theme.bgCard, Theme.bgDeep],
                    startPoint: .top, endPoint: .bottom
                )
            )
            .overlay(
                // Subtle inner brand wash
                RadialGradient(
                    colors: [Theme.magenta.opacity(0.18), .clear],
                    center: .topLeading,
                    startRadius: 0, endRadius: 240
                )
                .clipShape(RoundedRectangle(cornerRadius: 22))
            )
            .overlay(
                RadialGradient(
                    colors: [Theme.blue.opacity(0.18), .clear],
                    center: .bottomTrailing,
                    startRadius: 0, endRadius: 240
                )
                .clipShape(RoundedRectangle(cornerRadius: 22))
            )
    }

    private var cardBorder: some View {
        RoundedRectangle(cornerRadius: 22)
            .strokeBorder(
                LinearGradient(
                    colors: [Theme.pink, Theme.magenta, Theme.blue, Theme.mint, Theme.yellow],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 1.5
            )
    }
}

// MARK: - Tiny 2-column grid wrapper (avoids requiring a separate file)

private struct LazyVHGrid<Content: View>: View {
    let columns: [GridItem]
    let spacing: CGFloat
    @ViewBuilder let content: () -> Content

    init(columns: [GridItem], spacing: CGFloat = 8, @ViewBuilder content: @escaping () -> Content) {
        self.columns = columns
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        LazyVGrid(columns: columns, spacing: spacing) {
            content()
        }
    }
}

// MARK: - Tiny deterministic RNG for trade IDs

private struct SeededRNG: RandomNumberGenerator {
    var state: UInt64
    init(seed: UInt64) { self.state = seed == 0 ? 0xDEADBEEFCAFEBABE : seed }
    mutating func next() -> UInt64 {
        state ^= state << 13
        state ^= state >> 7
        state ^= state << 17
        return state
    }
}

// MARK: - Preview

#if DEBUG
#Preview {
    TrainerCardView(onDismiss: {})
        .environmentObject(FocusManager())
        .environmentObject(DexStore())
        .frame(width: 380, height: 700)
        .background(OrbBackground())
}
#endif
