import SwiftUI

struct FocusTab: View {
    @EnvironmentObject var focus: FocusManager

    var body: some View {
        Group {
            switch focus.phase {
            case .idle:     IdleView()
            case .focusing: SessionView()
            case .safari:   SafariView()
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: focus.phase)
    }
}

// MARK: - Idle (pre-session)

private struct IdleView: View {
    @EnvironmentObject var focus: FocusManager
    @State private var customMinutes: Double = 25

    var body: some View {
        VStack(spacing: 16) {
            Spacer(minLength: 4)

            VStack(spacing: 4) {
                Text("Ready to focus?")
                    .font(.system(.title3, design: .rounded).weight(.heavy))
                Text("Pick a duration. Catch what you spawn.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 10) {
                ForEach(FocusManager.durationPresets, id: \.self) { d in
                    DurationChip(minutes: Int(d / 60), selected: focus.plannedDuration == d) {
                        focus.plannedDuration = d
                        customMinutes = d / 60
                    }
                }
            }

            VStack(spacing: 4) {
                HStack {
                    Text("Custom").font(.caption.weight(.semibold))
                    Spacer()
                    Text("\(Int(customMinutes)) min")
                        .font(.caption.monospacedDigit())
                        .foregroundStyle(.secondary)
                }
                Slider(value: $customMinutes, in: 5...240, step: 5)
                    .tint(Theme.magenta)
                    .onChange(of: customMinutes) { new in
                        focus.plannedDuration = new * 60
                    }
            }
            .padding(.horizontal, 16)

            BallStockpileRow()

            Spacer()

            Button(action: { focus.start() }) {
                HStack(spacing: 6) {
                    Image(systemName: "play.fill")
                    Text("Start Focus")
                }
            }
            .buttonStyle(PrimaryGradientButtonStyle())
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
    }
}

private struct DurationChip: View {
    let minutes: Int
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 1) {
                Text("\(minutes)")
                    .font(.system(.title3, design: .rounded).weight(.black))
                    .monospacedDigit()
                Text("min")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            .frame(width: 68, height: 56)
            .background {
                RoundedRectangle(cornerRadius: 14)
                    .fill(selected ? AnyShapeStyle(Theme.primaryGradient) : AnyShapeStyle(Color.white.opacity(0.06)))
            }
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(selected ? Color.white.opacity(0.25) : Color.white.opacity(0.08), lineWidth: 1)
            )
            .foregroundStyle(selected ? .white : .primary)
            .shadow(color: selected ? Theme.magenta.opacity(0.5) : .clear, radius: 12, y: 4)
            .scaleEffect(selected ? 1.03 : 1)
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selected)
    }
}

private struct BallStockpileRow: View {
    @EnvironmentObject var focus: FocusManager
    var body: some View {
        HStack(spacing: 8) {
            BallStat(count: focus.pokeballs, label: "Focus", color: Theme.mint)
            BallStat(count: focus.greatBalls, label: "Great", color: Theme.blue)
            BallStat(count: focus.ultraBalls, label: "Ultra", color: Theme.yellow)
            BallStat(count: focus.masterBalls, label: "Master", color: Theme.magenta)
        }
        .padding(.horizontal, 16)
    }
}

private struct BallStat: View {
    let count: Int
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Circle()
                .fill(color.gradient)
                .frame(width: 16, height: 16)
                .overlay(Circle().strokeBorder(.white.opacity(0.4), lineWidth: 1))
                .shadow(color: color.opacity(0.5), radius: 6)
            Text("\(count)")
                .font(.system(.subheadline, design: .rounded).weight(.heavy))
                .monospacedDigit()
                .foregroundStyle(.white)
            Text(label)
                .font(.system(size: 8, weight: .heavy, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(color.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(color.opacity(0.25), lineWidth: 0.5))
    }
}

// MARK: - Session (in-progress)

private struct SessionView: View {
    @EnvironmentObject var focus: FocusManager
    @State private var pulse: Bool = false

    var body: some View {
        VStack(spacing: 14) {
            Spacer(minLength: 6)

            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.07), lineWidth: 10)
                    .frame(width: 210, height: 210)
                Circle()
                    .trim(from: 0, to: focus.plannedDuration > 0 ? CGFloat(focus.elapsed / focus.plannedDuration) : 0)
                    .stroke(Theme.focusGradient, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .frame(width: 210, height: 210)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.4), value: focus.elapsed)
                    .shadow(color: Theme.mint.opacity(0.6), radius: 14)

                VStack(spacing: 4) {
                    Text(focus.formattedRemaining)
                        .font(.system(size: 46, weight: .black, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(.white)
                    Text("focusing")
                        .font(.caption.weight(.bold))
                        .kerning(2)
                        .foregroundStyle(Theme.mint.opacity(pulse ? 1 : 0.5))
                }
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1.6).repeatForever()) { pulse.toggle() }
            }

            BallStockpileRow()
                .padding(.top, 6)

            Spacer()

            Button(role: .destructive, action: { focus.stopEarly() }) {
                Text("Stop early")
                    .font(.caption.weight(.bold))
            }
            .buttonStyle(.borderless)
            .foregroundStyle(.secondary)
            .padding(.bottom, 12)
        }
    }
}

// MARK: - Safari Mode (catching)

private struct SafariView: View {
    @EnvironmentObject var focus: FocusManager
    @EnvironmentObject var dex: DexStore
    @State private var caught: [Int: Bool] = [:]
    @State private var throwing: Int? = nil
    @State private var revealCard: Creature? = nil
    @State private var confettiID = UUID()
    @State private var showConfetti = false

    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                HStack {
                    AnimatedGradientText(
                        text: "SAFARI MODE",
                        font: .system(size: 13, weight: .black, design: .rounded)
                    )
                    .kerning(2)
                    Spacer()
                    Button(action: { focus.dismissSafari() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 16).padding(.top, 8)

                Text("Tap a creature to throw your best ball.")
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                ZStack {
                    ForEach(Array(focus.pendingSpawns.enumerated()), id: \.offset) { i, creature in
                        if caught[creature.id] != false {
                            FloatingCreature(
                                creature: creature,
                                index: i,
                                throwing: throwing == creature.id,
                                caught: caught[creature.id] == true,
                                onTap: { attemptCatch(creature) }
                            )
                        }
                    }
                    ForEach(focus.pendingSpawns, id: \.id) { c in
                        if caught[c.id] == false {
                            Text("💨 \(c.name) got away")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .offset(y: CGFloat(c.id % 50) - 20)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                Spacer()
                BallStockpileRow().padding(.bottom, 10)
            }

            if showConfetti {
                ConfettiBurst(burstID: confettiID, count: 70)
                    .allowsHitTesting(false)
            }

            if let rev = revealCard {
                CatchRevealCard(creature: rev) {
                    withAnimation(.spring()) { revealCard = nil }
                }
                .transition(.scale.combined(with: .opacity))
                .zIndex(20)
            }
        }
    }

    private func attemptCatch(_ creature: Creature) {
        guard caught[creature.id] == nil else { return }

        let tier: FocusManager.BallTier = {
            if focus.masterBalls > 0 { return .master }
            if focus.ultraBalls > 0 { return .ultra }
            if focus.greatBalls > 0 { return .great }
            return .pokeball
        }()

        guard focus.totalBalls > 0 else { return }

        throwing = creature.id
        let success = focus.attemptCatch(creature, with: tier)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            throwing = nil
            caught[creature.id] = success
            if success {
                dex.catchCreature(creature)
                confettiID = UUID()
                showConfetti = true
                withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                    revealCard = creature
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    showConfetti = false
                }
            }
        }
    }
}

private struct FloatingCreature: View {
    let creature: Creature
    let index: Int
    let throwing: Bool
    let caught: Bool
    let onTap: () -> Void

    @State private var bob: CGFloat = 0
    @State private var ballY: CGFloat = 400
    @State private var wobble: CGFloat = 0

    private var baseX: CGFloat {
        let columns: CGFloat = 3
        let col = CGFloat(index % Int(columns))
        return (col - (columns - 1) / 2) * 110
    }
    private var baseY: CGFloat { CGFloat(index / 3) * 90 - 40 }

    var body: some View {
        ZStack {
            Text(emoji)
                .font(.system(size: 48))
                .foregroundStyle(typeColor)
                .shadow(color: typeColor.opacity(0.6), radius: 14)
                .offset(x: baseX, y: baseY + bob)
                .scaleEffect(caught ? 0 : 1)
                .opacity(throwing && !caught ? 0.5 : 1)
                .onTapGesture(perform: onTap)
                .onAppear {
                    withAnimation(.easeInOut(duration: 2 + Double(index % 3) * 0.3).repeatForever(autoreverses: true)) {
                        bob = -10
                    }
                }

            if throwing {
                Circle()
                    .fill(LinearGradient(colors: [.white, typeColor], startPoint: .top, endPoint: .bottom))
                    .frame(width: 18, height: 18)
                    .overlay(Circle().strokeBorder(.white, lineWidth: 1))
                    .offset(x: baseX + wobble, y: ballY)
                    .onAppear {
                        withAnimation(.timingCurve(0.3, 0.0, 0.6, 1.0, duration: 0.4)) {
                            ballY = baseY
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                            withAnimation(.spring(response: 0.18, dampingFraction: 0.4).repeatCount(3, autoreverses: true)) {
                                wobble = 8
                            }
                        }
                    }
            }
        }
    }

    private var typeColor: Color {
        switch creature.primary {
        case .code: return Theme.mint
        case .art: return Theme.pink
        case .pixel: return Theme.yellow
        case .doc: return Theme.blue
        case .sound: return Theme.magenta
        case .sun: return Theme.yellow
        case .moon: return Theme.magenta
        case .dream: return Theme.blue
        case .caffeine: return Theme.pink
        case .glitch: return Theme.magenta
        case .storm: return Theme.blue
        case .spirit: return Theme.magenta
        default: return Theme.mint
        }
    }

    private var emoji: String {
        switch creature.primary {
        case .code: return "⌬"
        case .art:  return "✒︎"
        case .pixel: return "✦"
        case .doc:  return "📄"
        case .sound: return "♫"
        case .sun:  return "☀︎"
        case .moon: return "☾"
        case .dream: return "☁︎"
        case .caffeine: return "☕"
        case .glitch: return "▒"
        case .storm: return "⚡"
        case .spirit: return "❂"
        default: return "✶"
        }
    }
}

private struct CatchRevealCard: View {
    let creature: Creature
    let onDismiss: () -> Void
    @State private var sparkle = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.65).ignoresSafeArea()
                .onTapGesture(perform: onDismiss)

            VStack(spacing: 10) {
                AnimatedGradientText(
                    text: "✨ CAUGHT ✨",
                    font: .system(size: 13, weight: .black, design: .rounded)
                )
                .kerning(2)

                Text("⌬")
                    .font(.system(size: 80))
                    .foregroundStyle(Theme.mint)
                    .shadow(color: Theme.mint.opacity(0.7), radius: 22)
                    .scaleEffect(sparkle ? 1.05 : 1)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                            sparkle.toggle()
                        }
                    }

                Text(creature.dexNumber)
                    .font(.system(.caption, design: .monospaced).weight(.bold))
                    .foregroundStyle(.secondary)

                Text(creature.name)
                    .font(.system(.title2, design: .rounded).weight(.black))

                Text(creature.signatureMove)
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10).padding(.vertical, 4)
                    .background(Theme.primaryGradient.opacity(0.4), in: Capsule())

                Text(creature.blurb)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 14)

                Button("Nice", action: onDismiss)
                    .buttonStyle(PrimaryGradientButtonStyle())
                    .padding(.horizontal, 24)
                    .padding(.top, 4)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(Color.black.opacity(0.75))
                    .overlay(RoundedRectangle(cornerRadius: 22).strokeBorder(Theme.magenta.opacity(0.5), lineWidth: 1))
            )
            .padding(24)
            .shadow(color: Theme.magenta.opacity(0.55), radius: 44)
        }
    }
}
