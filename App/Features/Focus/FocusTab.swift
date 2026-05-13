import SwiftUI

struct FocusTab: View {
    @EnvironmentObject var focus: FocusManager

    var body: some View {
        Group {
            switch focus.phase {
            case .idle:        IdleView()
            case .focusing:    SessionView()
            case .celebration: CelebrationView()
            case .safari:      SafariView()
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
                        SoundFX.play(.tap)
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
            .keyboardShortcut("n", modifiers: .command)
            .padding(.horizontal, 16)

            // Free-play entry — the catch game isn't gated behind work.
            Button(action: { focus.enterSafari() }) {
                HStack(spacing: 6) {
                    Image(systemName: "pawprint.fill")
                    Text("Catch creatures")
                    Image(systemName: "arrow.right")
                        .font(.system(size: 10, weight: .heavy))
                }
                .font(.system(.subheadline, design: .rounded).weight(.heavy))
                .foregroundStyle(Theme.mint)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Theme.mint.opacity(0.10))
                        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Theme.mint.opacity(0.4), lineWidth: 1))
                }
            }
            .buttonStyle(.plain)
            .keyboardShortcut("g", modifiers: .command)
            .padding(.horizontal, 16)
            .padding(.bottom, 10)
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
                .contentTransition(.numericText())
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
    @State private var lastBall: Int = 0
    @State private var showBallToast: Bool = false

    var body: some View {
        ZStack {
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
                    lastBall = focus.pokeballs
                }
                .onChange(of: focus.pokeballs) { new in
                    if new > lastBall {
                        lastBall = new
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                            showBallToast = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                            withAnimation { showBallToast = false }
                        }
                    }
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
                .keyboardShortcut(".", modifiers: .command)
                .padding(.bottom, 12)
            }

            if showBallToast {
                BallEarnedToast()
                    .transition(.scale(scale: 0.7).combined(with: .opacity))
                    .padding(.top, 6)
                    .zIndex(10)
            }
        }
    }
}

private struct BallEarnedToast: View {
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(Theme.mint.gradient)
                .frame(width: 14, height: 14)
                .overlay(Circle().strokeBorder(.white, lineWidth: 1))
                .shadow(color: Theme.mint.opacity(0.7), radius: 8)
            Text("+1 Focus Ball")
                .font(.caption.weight(.heavy))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: Capsule())
        .overlay(Capsule().strokeBorder(Theme.mint.opacity(0.3), lineWidth: 0.5))
        .shadow(color: .black.opacity(0.3), radius: 12, y: 6)
    }
}

// MARK: - Celebration (between session end and safari)

private struct CelebrationView: View {
    @EnvironmentObject var focus: FocusManager
    @State private var burstID = UUID()
    @State private var pulse = false

    var body: some View {
        ZStack {
            VStack(spacing: 12) {
                Spacer()

                Text("🎉")
                    .font(.system(size: 72))
                    .scaleEffect(pulse ? 1.08 : 0.95)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.7).repeatForever(autoreverses: true)) {
                            pulse.toggle()
                        }
                    }

                AnimatedGradientText(
                    text: "SESSION COMPLETE",
                    font: .system(size: 16, weight: .black, design: .rounded)
                )
                .kerning(2)

                Text("\(focus.totalSessions) total · \(Int(focus.totalFocusMin)) min lifetime · 🔥 \(focus.currentStreak)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                HStack(spacing: 12) {
                    EarnedTile(label: "Focused", value: minuteLabel(focus.lastSessionDuration), color: Theme.mint)
                    EarnedTile(label: "Streak", value: "\(focus.currentStreak)", color: Theme.pink)
                }
                .padding(.horizontal, 24)
                .padding(.top, 6)

                if focus.lastSessionGreatEarned + focus.lastSessionUltraEarned + focus.lastSessionMasterEarned > 0 {
                    VStack(spacing: 4) {
                        Text("Earned:").font(.caption2.weight(.bold)).foregroundStyle(.secondary)
                        HStack(spacing: 8) {
                            if focus.lastSessionGreatEarned > 0 { BadgeChip(text: "Great Ball", color: Theme.blue) }
                            if focus.lastSessionUltraEarned > 0 { BadgeChip(text: "Ultra Ball", color: Theme.yellow) }
                            if focus.lastSessionMasterEarned > 0 { BadgeChip(text: "Master Ball", color: Theme.magenta) }
                        }
                    }
                    .padding(.top, 4)
                }

                Spacer()

                Text("Safari Mode opening…")
                    .font(.caption2.italic())
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 14)
            }

            ConfettiBurst(burstID: burstID, count: 100)
                .allowsHitTesting(false)
        }
    }

    private func minuteLabel(_ sec: TimeInterval) -> String {
        let m = Int(sec / 60); let s = Int(sec.truncatingRemainder(dividingBy: 60))
        return s > 0 ? "\(m)m \(s)s" : "\(m)m"
    }
}

private struct EarnedTile: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(.title3, design: .rounded).weight(.black))
                .monospacedDigit()
                .foregroundStyle(.white)
            Text(label)
                .font(.system(size: 9, weight: .heavy, design: .rounded))
                .foregroundStyle(.secondary)
                .kerning(0.8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.15), in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(color.opacity(0.4), lineWidth: 0.5))
    }
}

private struct BadgeChip: View {
    let text: String
    let color: Color
    var body: some View {
        Text(text)
            .font(.caption2.weight(.heavy))
            .padding(.horizontal, 8).padding(.vertical, 3)
            .background(color.opacity(0.25), in: Capsule())
            .foregroundStyle(color)
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
                    .keyboardShortcut(.cancelAction)
                }
                .padding(.horizontal, 16).padding(.top, 8)

                Text("Tap a creature to throw your best ball.")
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                ZStack {
                    MeadowBG()
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
                                .foregroundStyle(.white)
                                .padding(.horizontal, 6).padding(.vertical, 2)
                                .background(Color(hex: "06010f").opacity(0.7), in: Capsule())
                                .offset(y: CGFloat(c.id % 50) - 20)
                        }
                    }
                    // Pokemon-style "A WILD ... APPEARED!" banner
                    EncounterBanner(count: focus.pendingSpawns.count)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.top, 8)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(
                    // Gen-1 chunky frame: black outer, white inner
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(Color(hex: "06010f"), lineWidth: 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 11)
                                .strokeBorder(Color.white.opacity(0.9), lineWidth: 2)
                                .padding(3)
                        )
                )
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal, 8)

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
    @State private var press = false

    private var baseX: CGFloat {
        let columns: CGFloat = 3
        let col = CGFloat(index % Int(columns))
        return (col - (columns - 1) / 2) * 110
    }
    private var baseY: CGFloat { CGFloat(index / 3) * 90 - 40 }

    var body: some View {
        ZStack {
            // Grass platform under the creature (oval pixel disc)
            GrassPlatform()
                .frame(width: 80, height: 22)
                .offset(x: baseX, y: baseY + 30)
                .opacity(caught ? 0 : 1)

            PixelArt(
                grid: Sprites.forCreature(id: creature.id),
                scale: 4,
                glowColor: typeColor.opacity(0.7),
                glowRadius: 14
            )
                .offset(x: baseX, y: baseY + bob)
                .scaleEffect(caught ? 0 : (press ? 0.92 : 1))
                .opacity(throwing && !caught ? 0.5 : 1)
                .onTapGesture(perform: onTap)
                .onLongPressGesture(minimumDuration: 0.01, pressing: { p in
                    withAnimation(.spring(response: 0.15, dampingFraction: 0.7)) { press = p }
                }, perform: {})
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

// MARK: - Meadow background (Gen-1 Pokemon vibe)

private struct MeadowBG: View {
    var body: some View {
        ZStack {
            // Solid sky bands (Gen-1 horizon style)
            VStack(spacing: 0) {
                LinearGradient(colors: [Color(hex: "1a0830"), Color(hex: "6b1f7a")], startPoint: .top, endPoint: .bottom)
                    .frame(height: 60)
                LinearGradient(colors: [Color(hex: "6b1f7a"), Color(hex: "C147FF"), Color(hex: "FF6B6B")], startPoint: .top, endPoint: .bottom)
                    .frame(height: 100)
                LinearGradient(colors: [Color(hex: "FF6B6B"), Color(hex: "FFD960")], startPoint: .top, endPoint: .bottom)
                    .frame(height: 50)
                Color(hex: "2a6a3a")
                    .frame(minHeight: 0, maxHeight: .infinity)
            }

            // Pixel stars in upper sky
            StarFieldOverlay()
                .opacity(0.6)
                .frame(maxHeight: 100, alignment: .top)
                .frame(maxHeight: .infinity, alignment: .top)

            // Twin moons (upper-right)
            VStack {
                HStack { Spacer(); TwinMoons().padding(.trailing, 22).padding(.top, 10) }
                Spacer()
            }

            // Pixel mountain range (chunky, flat-color, Gen-1 style)
            PixelMountains()
                .frame(height: 60)
                .frame(maxHeight: .infinity, alignment: .center)
                .offset(y: 20)

            // Big trees flanking the scene
            HStack {
                PixelTree().offset(y: 40)
                Spacer()
                PixelTree(flipped: true).offset(y: 50)
            }
            .padding(.horizontal, 6)
            .frame(maxHeight: .infinity, alignment: .bottom)

            // Tiled grass field (square cross pattern, denser than vertical bars)
            VStack {
                Spacer()
                GrassField()
                    .frame(height: 80)
            }

            // Mint fireflies
            FireflyLayer()
        }
    }
}

private struct PixelMountains: View {
    var body: some View {
        Canvas { ctx, size in
            let w = size.width, h = size.height
            let backColor = Color(hex: "2a64a8").opacity(0.85)
            let frontColor = Color(hex: "47A0FF").opacity(0.7)
            // Two layered ridges with stair-stepped peaks (chunky pixel feel)
            func ridge(amp: CGFloat, steps: Int, color: Color, offsetX: CGFloat = 0) {
                var path = Path()
                path.move(to: CGPoint(x: 0, y: h))
                let stepW = w / CGFloat(steps)
                for i in 0..<steps {
                    let phase = sin((CGFloat(i) + offsetX) * 0.7)
                    let y = h - amp * (0.4 + 0.5 * phase * phase)
                    let yQuant = round(y / 4) * 4 // quantize for pixel feel
                    path.addLine(to: CGPoint(x: CGFloat(i) * stepW, y: yQuant))
                    path.addLine(to: CGPoint(x: CGFloat(i + 1) * stepW, y: yQuant))
                }
                path.addLine(to: CGPoint(x: w, y: h))
                path.closeSubpath()
                ctx.fill(path, with: .color(color))
            }
            ridge(amp: h * 0.95, steps: 14, color: backColor, offsetX: 0)
            ridge(amp: h * 0.65, steps: 20, color: frontColor, offsetX: 3)
        }
    }
}

private struct PixelTree: View {
    var flipped: Bool = false
    var body: some View {
        let cells: [String] = [
            "...kk...",
            "..kCCk..",
            ".kCCCCk.",
            "kCGGGCCk",
            "kGCCGGCk",
            "kCCGCGCk",
            ".kCGCCk.",
            ".kCCCCk.",
            "..kCCk..",
            "...kk...",
            "...kk...",
            "..bBBk..",
        ]
        // Reuse PixelArt with custom palette for tree colors
        let palette: [Character: Color] = [
            "k": Color(hex: "06010f"),
            "C": Color(hex: "159a6a"),
            "G": Color(hex: "1aa370"),
            "B": Color(hex: "4a2a14"),
            "b": Color(hex: "6a3a24"),
            ".": .clear,
        ]
        PixelArt(grid: cells, scale: 4, palette: palette)
            .scaleEffect(x: flipped ? -1 : 1)
            .shadow(color: .black.opacity(0.45), radius: 4, x: 0, y: 4)
    }
}

private struct GrassField: View {
    var body: some View {
        Canvas { ctx, size in
            let w = size.width, h = size.height
            // Background field
            ctx.fill(Path(CGRect(x: 0, y: 0, width: w, height: h)),
                     with: .color(Color(hex: "1a4a2a")))
            // Tiled grass tufts: cross-shaped 8x8 sprites repeated
            let tile: CGFloat = 16
            let cols = Int(ceil(w / tile))
            let rows = Int(ceil(h / tile))
            for r in 0..<rows {
                for c in 0..<cols {
                    let baseX = CGFloat(c) * tile + (r % 2 == 0 ? 0 : tile / 2)
                    let baseY = CGFloat(r) * tile
                    let mint = (c + r) % 3 == 0
                    let color = mint ? Color(hex: "2EE6A0") : Color(hex: "159a6a")
                    // 5-blade tuft pattern
                    let blades: [(CGFloat, CGFloat, CGFloat, CGFloat)] = [
                        (2, 4, 1, 6),   // left
                        (5, 2, 1, 8),   // center tall
                        (4, 5, 1, 5),
                        (7, 4, 1, 6),
                        (3, 6, 1, 4),
                    ]
                    for (bx, by, bw, bh) in blades {
                        ctx.fill(Path(CGRect(
                            x: baseX + bx, y: baseY + by,
                            width: bw, height: bh
                        )), with: .color(color))
                    }
                    // Dark base shadow line
                    ctx.fill(Path(CGRect(
                        x: baseX + 2, y: baseY + tile - 2,
                        width: 8, height: 2
                    )), with: .color(Color(hex: "06010f")))
                }
            }
        }
    }
}

private struct StarFieldOverlay: View {
    var body: some View {
        GeometryReader { geo in
            Canvas { ctx, size in
                let stars: [(CGFloat, CGFloat, CGFloat)] = [
                    (0.05, 0.12, 1), (0.15, 0.33, 1), (0.31, 0.22, 1.5),
                    (0.42, 0.52, 1), (0.51, 0.12, 1), (0.67, 0.21, 1.2),
                    (0.73, 0.10, 1), (0.79, 0.34, 1), (0.89, 0.18, 1.4),
                    (0.95, 0.27, 1)
                ]
                for (xf, yf, s) in stars {
                    let rect = CGRect(
                        x: xf * size.width, y: yf * size.height,
                        width: s, height: s
                    )
                    ctx.fill(Path(rect), with: .color(.white))
                }
            }
        }
    }
}

private struct TwinMoons: View {
    var body: some View {
        ZStack {
            // Big yellow moon
            Circle()
                .fill(Theme.yellow)
                .frame(width: 32, height: 32)
                .overlay(Circle().strokeBorder(Color(hex: "06010f"), lineWidth: 1.5))
                .shadow(color: Theme.yellow.opacity(0.5), radius: 14)
            // Small crescent moon offset
            Circle()
                .fill(Color(hex: "06010f"))
                .frame(width: 16, height: 16)
                .overlay(
                    Circle()
                        .stroke(Theme.yellow, lineWidth: 1)
                )
                .offset(x: 22, y: 6)
        }
    }
}

private struct HillsShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        p.move(to: CGPoint(x: 0, y: h))
        let peaks: [(CGFloat, CGFloat)] = [
            (0.00, 0.60), (0.08, 0.30), (0.20, 0.55), (0.32, 0.20),
            (0.50, 0.45), (0.65, 0.25), (0.80, 0.50), (1.00, 0.30)
        ]
        for (xf, yf) in peaks {
            p.addLine(to: CGPoint(x: xf * w, y: yf * h))
        }
        p.addLine(to: CGPoint(x: w, y: h))
        p.closeSubpath()
        return p
    }
}

private struct TallGrass: View {
    let count: Int
    var body: some View {
        HStack(spacing: 1) {
            ForEach(0..<count, id: \.self) { i in
                let h: CGFloat = 14 + CGFloat((i * 7) % 14)
                let c: Color = i % 3 == 0 ? Color(hex: "159a6a") : Theme.mint
                Rectangle()
                    .fill(c)
                    .frame(width: 6, height: h)
                    .overlay(
                        Rectangle().fill(Color(hex: "06010f")).frame(height: 2)
                            .frame(maxHeight: .infinity, alignment: .top)
                    )
                    .rotationEffect(.degrees(Double((i % 2 == 0 ? 1.0 : -1.0) * Double(3 + i % 5))))
            }
        }
    }
}

private struct FireflyLayer: View {
    @State private var phase = 0.0
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<8, id: \.self) { i in
                    Circle()
                        .fill(Theme.mint)
                        .frame(width: 4, height: 4)
                        .shadow(color: Theme.mint, radius: 4)
                        .position(
                            x: geo.size.width * CGFloat(0.08 + Double(i) * 0.11),
                            y: geo.size.height * CGFloat(0.5 + Double(i % 3) * 0.08)
                        )
                        .opacity(0.5 + 0.5 * sin(phase + Double(i)))
                }
            }
            .onAppear {
                withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                    phase = .pi * 2
                }
            }
        }
        .allowsHitTesting(false)
    }
}

private struct GrassPlatform: View {
    var body: some View {
        Canvas { ctx, size in
            let w = size.width, h = size.height
            let cx = w / 2, cy = h / 2
            // Outline (dark)
            var outline = Path(ellipseIn: CGRect(x: 0, y: 0, width: w, height: h))
            ctx.fill(outline, with: .color(Color(hex: "06010f")))
            // Mint fill (slightly smaller)
            outline = Path(ellipseIn: CGRect(x: 2, y: 2, width: w - 4, height: h - 4))
            ctx.fill(outline, with: .color(Color(hex: "159a6a")))
            // Highlight (top half lighter)
            let hi = Path(ellipseIn: CGRect(x: 4, y: 3, width: w - 8, height: (h - 6) * 0.6))
            ctx.fill(hi, with: .color(Color(hex: "2EE6A0")))
            // Speckles
            for i in 0..<6 {
                let x = cx + cos(Double(i) * 1.0) * (w * 0.30)
                let y = cy + sin(Double(i) * 1.0) * (h * 0.20)
                ctx.fill(Path(CGRect(x: x, y: y, width: 2, height: 2)),
                         with: .color(Color(hex: "9af2ce")))
            }
        }
    }
}

private struct EncounterBanner: View {
    let count: Int
    @State private var flash = false
    @State private var visible = true

    var body: some View {
        Group {
            if visible {
                HStack(spacing: 6) {
                    Text("⚡")
                    Text(count == 1 ? "A WILD CREATURE APPEARED!" : "WILD CREATURES APPEARED!")
                        .font(.system(size: 10, weight: .black, design: .monospaced))
                        .kerning(0.8)
                    Text("⚡")
                }
                .padding(.horizontal, 10).padding(.vertical, 4)
                .background(
                    Color(hex: "06010f").opacity(0.85),
                    in: RoundedRectangle(cornerRadius: 6)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .strokeBorder(Color.white, lineWidth: 1.5)
                )
                .foregroundStyle(flash ? Theme.yellow : .white)
                .shadow(color: Theme.yellow.opacity(0.7), radius: 8)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.3).repeatForever(autoreverses: true)) {
                        flash.toggle()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
                        withAnimation(.easeOut(duration: 0.4)) {
                            visible = false
                        }
                    }
                }
            }
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

                PixelArt(
                    grid: Sprites.forCreature(id: creature.id),
                    scale: 6,
                    glowColor: Theme.mint.opacity(0.8),
                    glowRadius: 22
                )
                .scaleEffect(sparkle ? 1.05 : 1)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                        sparkle.toggle()
                    }
                }
                HStack(spacing: 4) {
                    TypePill(type: creature.primary)
                    if let s = creature.secondary { TypePill(type: s) }
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
