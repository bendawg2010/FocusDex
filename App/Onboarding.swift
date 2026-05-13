import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var dex: DexStore
    @EnvironmentObject var focus: FocusManager
    @AppStorage(Persistence.Keys.hasChosenStarter) private var hasChosenStarter = false
    @AppStorage(Persistence.Keys.starterId) private var starterId = 0
    @State private var picked: Int? = nil
    @State private var burstID = UUID()

    var body: some View {
        ZStack {
            OrbBackground()

            VStack(spacing: 12) {
                Spacer(minLength: 12)

                Text("⌬")
                    .font(.system(size: 40))
                    .foregroundStyle(Theme.magenta)
                    .brandGlow(Theme.magenta, radius: 16)

                AnimatedGradientText(
                    text: "Welcome, trainer.",
                    font: .system(size: 22, weight: .black, design: .rounded)
                )

                Text("Pick your starter — your partner for the year.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)

                VStack(spacing: 10) {
                    ForEach(Creature.starters) { c in
                        StarterRow(creature: c, picked: picked == c.id) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                picked = c.id
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                choose(c)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 6)

                Spacer()

                Text("— Professor Notchy")
                    .font(.caption2.italic())
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 14)
            }

            if picked != nil {
                ConfettiBurst(burstID: burstID, count: 80)
                    .allowsHitTesting(false)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func choose(_ c: Creature) {
        starterId = c.id
        dex.catchCreature(c)
        focus.grantStarterPack()
        burstID = UUID()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            withAnimation { hasChosenStarter = true }
        }
    }
}

private struct StarterRow: View {
    let creature: Creature
    let picked: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [typeColor.opacity(0.35), typeColor.opacity(0.05)],
                                center: .center, startRadius: 0, endRadius: 32
                            )
                        )
                        .overlay(Circle().strokeBorder(typeColor.opacity(0.6), lineWidth: 1))
                        .frame(width: 64, height: 64)
                    PixelArt(
                        grid: Sprites.forCreature(id: creature.id),
                        scale: 2.6,
                        palette: Sprites.paletteFor(creature: creature),
                        glowColor: typeColor.opacity(0.7),
                        glowRadius: 12
                    )
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(creature.dexNumber)
                            .font(.caption2.monospacedDigit())
                            .foregroundStyle(.secondary)
                        Text(creature.name)
                            .font(.system(.headline, design: .rounded).weight(.heavy))
                    }
                    HStack(spacing: 4) {
                        TypePill(type: creature.primary)
                        if let s = creature.secondary {
                            TypePill(type: s)
                        }
                    }
                    Text(creature.blurb)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Spacer(minLength: 0)

                Image(systemName: picked ? "checkmark.circle.fill" : "chevron.right")
                    .font(.system(size: 16))
                    .foregroundStyle(picked ? Theme.mint : Color.secondary.opacity(0.6))
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(picked ? 0.10 : 0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(picked ? typeColor.opacity(0.7) : Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
            .scaleEffect(picked ? 1.02 : 1)
        }
        .buttonStyle(.plain)
    }

    private var typeColor: Color {
        switch creature.primary {
        case .code: return Theme.mint
        case .art: return Theme.pink
        case .pixel: return Theme.yellow
        case .doc: return Theme.blue
        default: return Theme.magenta
        }
    }
}
