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

private enum SafariSubPhase { case overworld, battle }

private struct SafariView: View {
    @EnvironmentObject var focus: FocusManager
    @EnvironmentObject var dex: DexStore
    @State private var subPhase: SafariSubPhase = .overworld
    @State private var current: Creature? = nil
    @State private var spawnQueue: [Creature] = []
    @State private var throwing: Bool = false
    @State private var revealCard: Creature? = nil
    @State private var confettiID = UUID()
    @State private var showConfetti = false
    @State private var statusText: String = ""
    @State private var ranAway: Bool = false

    var body: some View {
        ZStack {
            VStack(spacing: 6) {
                HStack {
                    AnimatedGradientText(
                        text: subPhase == .overworld ? "ROUTE 1" : "WILD ENCOUNTER",
                        font: .system(size: 13, weight: .black, design: .monospaced)
                    ).kerning(2)
                    Spacer()
                    if subPhase == .overworld {
                        Label("\(spawnQueue.count)", systemImage: "leaf.fill")
                            .font(.system(size: 10, weight: .black, design: .monospaced))
                            .foregroundStyle(Theme.mint)
                    }
                    Button(action: { focus.dismissSafari() }) {
                        Image(systemName: "xmark.circle.fill").foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                    .keyboardShortcut(.cancelAction)
                }
                .padding(.horizontal, 16).padding(.top, 8)

                if subPhase == .overworld {
                    OverworldView(onEncounter: triggerEncounter, onLeave: { focus.dismissSafari() })
                        .padding(.horizontal, 6)
                        .padding(.bottom, 6)
                } else {
                    // Battle view
                    ZStack {
                        MeadowBG()
                        if let c = current {
                            WildEncounter(creature: c, throwing: throwing, ranAway: ranAway)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay(
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

                    Gen1DialogBox(
                        statusText: statusText.isEmpty ? defaultStatus() : statusText,
                        creature: current,
                        canThrow: current != nil && focus.totalBalls > 0 && !throwing,
                        ballCount: focus.totalBalls,
                        onThrow: { throwBall() },
                        onRun: { backToOverworld() }
                    )
                    .padding(.horizontal, 8)
                    .padding(.bottom, 8)
                }
            }

            if showConfetti {
                ConfettiBurst(burstID: confettiID, count: 70)
                    .allowsHitTesting(false)
            }

            if let rev = revealCard {
                CatchRevealCard(creature: rev) {
                    withAnimation(.spring()) { revealCard = nil }
                    backToOverworld()
                }
                .transition(.scale.combined(with: .opacity))
                .zIndex(20)
            }
        }
        .onAppear {
            // Seed the spawn queue once from the pending spawns FocusManager generated
            if spawnQueue.isEmpty {
                spawnQueue = focus.pendingSpawns
            }
        }
    }

    private func defaultStatus() -> String {
        if let c = current { return "A wild \(c.name.uppercased()) appeared!" }
        return "..."
    }

    private func triggerEncounter() {
        guard !spawnQueue.isEmpty else { return }
        let next = spawnQueue.removeFirst()
        current = next
        statusText = ""
        ranAway = false
        throwing = false
        SoundFX.play(.start)
        withAnimation(.easeInOut(duration: 0.3)) {
            subPhase = .battle
        }
    }

    private func backToOverworld() {
        current = nil
        statusText = ""
        ranAway = false
        throwing = false
        if spawnQueue.isEmpty {
            // No more encounters — auto-leave safari after a beat
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                focus.dismissSafari()
            }
        } else {
            withAnimation(.easeInOut(duration: 0.3)) {
                subPhase = .overworld
            }
        }
    }

    private func throwBall() {
        guard let c = current, !throwing else { return }
        let tier: FocusManager.BallTier = {
            if focus.masterBalls > 0 { return .master }
            if focus.ultraBalls > 0 { return .ultra }
            if focus.greatBalls > 0 { return .great }
            return .pokeball
        }()
        guard focus.totalBalls > 0 else { return }
        throwing = true
        statusText = "You threw a ball..."
        let success = focus.attemptCatch(c, with: tier)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            throwing = false
            if success {
                dex.catchCreature(c)
                confettiID = UUID()
                showConfetti = true
                statusText = "\(c.name.uppercased()) was caught!"
                withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                    revealCard = c
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    showConfetti = false
                }
            } else {
                ranAway = true
                statusText = "\(c.name.uppercased()) broke free!"
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                    backToOverworld()
                }
            }
        }
    }

}

// MARK: - Overworld (walk-around tile map, Gen-1 style)

/// Tile types in the overworld map.
/// 0 = grass · 1 = tall grass (encounter) · 2 = tree · 3 = rock · 4 = path
/// 5 = water (impassable) · 6 = flowers (decorative, walkable) · 7 = sign (walkable)
private let OVERWORLD_MAP: [[Int]] = [
    [2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],
    [2,0,6,0,1,1,1,1,0,0,5,5,5,0,2],
    [2,0,0,0,1,1,1,0,0,0,5,5,5,5,2],
    [2,7,4,4,4,4,0,0,3,0,0,5,5,0,2],
    [2,0,0,0,0,4,4,4,4,4,4,4,0,0,2],
    [2,1,1,0,0,0,0,1,1,0,0,4,0,6,2],
    [2,1,1,6,0,3,0,1,1,1,0,4,4,4,2],
    [2,0,0,0,0,0,0,1,1,1,0,0,0,7,2],
    [2,0,4,4,4,4,4,4,0,0,3,0,1,1,2],
    [2,6,4,0,0,0,0,4,4,4,4,4,1,1,2],
    [2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],
]
private let TILE_SIZE: CGFloat = 30

/// Trainer/player sprite (16×16, designed to read as a small explorer).
private let TRAINER_SPRITE: [String] = [
    "................",
    "....kkkkkk......",
    "...kpppppppk....",
    "..kpyyyyyyypk...",
    "..kpyyyyyyypk...",
    "..kkkkkkkkkk....",
    "..kKwwKKwwKk....",
    "..kKKKKKKKKk....",
    "..kKKqqqqKKk....",
    "..kKqKKKKqKk....",
    "..kKKbbbbKKk....",
    "..kKbbbbbbKk....",
    "..kKbbbbbbKk....",
    "..kKkkKKkkKk....",
    "..kKK..KKKKk....",
    "................",
]

private struct OverworldView: View {
    let onEncounter: () -> Void
    let onLeave: () -> Void

    @State private var px: Int = 5
    @State private var py: Int = 4
    @State private var facing: Direction = .down
    @State private var monitor: Any? = nil
    @State private var stepCount: Int = 0
    @State private var grassRustle: (Int, Int)? = nil

    private enum Direction { case up, down, left, right }

    private var cols: Int { OVERWORLD_MAP[0].count }
    private var rows: Int { OVERWORLD_MAP.count }

    var body: some View {
        ZStack {
            // Tile map
            TileMapCanvas(tiles: OVERWORLD_MAP, tileSize: TILE_SIZE)

            // Grass rustle overlay (when player steps into tall grass)
            if let (rx, ry) = grassRustle {
                GrassRustle()
                    .frame(width: TILE_SIZE, height: TILE_SIZE)
                    .position(
                        x: (CGFloat(rx) + 0.5) * TILE_SIZE,
                        y: (CGFloat(ry) + 0.5) * TILE_SIZE
                    )
                    .allowsHitTesting(false)
            }

            // Player sprite
            PixelArt(grid: TRAINER_SPRITE, scale: 1.5)
                .position(
                    x: (CGFloat(px) + 0.5) * TILE_SIZE,
                    y: (CGFloat(py) + 0.5) * TILE_SIZE
                )
                .animation(.easeOut(duration: 0.14), value: px)
                .animation(.easeOut(duration: 0.14), value: py)

            // Bottom hint overlay
            VStack {
                Spacer()
                HStack {
                    Text("← → ↑ ↓  WALK    Q  LEAVE")
                        .font(.system(size: 9, weight: .black, design: .monospaced))
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(Color(hex: "fff7df"))
                        .overlay(Rectangle().strokeBorder(Color(hex: "06010f"), lineWidth: 2))
                        .foregroundStyle(Color(hex: "06010f"))
                    Spacer()
                }
            }
            .padding(8)
        }
        .frame(width: CGFloat(cols) * TILE_SIZE, height: CGFloat(rows) * TILE_SIZE)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(Color(hex: "06010f"), lineWidth: 3)
        )
        .onAppear(perform: installKeyMonitor)
        .onDisappear(perform: removeKeyMonitor)
    }

    private func installKeyMonitor() {
        monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            switch event.keyCode {
            case 123: tryMove(dx: -1, dy: 0, facing: .left);  return nil
            case 124: tryMove(dx:  1, dy: 0, facing: .right); return nil
            case 125: tryMove(dx: 0, dy:  1, facing: .down);  return nil
            case 126: tryMove(dx: 0, dy: -1, facing: .up);    return nil
            case 12:  onLeave(); return nil // Q
            default:  return event
            }
        }
    }
    private func removeKeyMonitor() {
        if let m = monitor { NSEvent.removeMonitor(m); monitor = nil }
    }

    private func tryMove(dx: Int, dy: Int, facing newFacing: Direction) {
        let nx = px + dx
        let ny = py + dy
        guard ny >= 0, ny < rows, nx >= 0, nx < cols else { return }
        let tile = OVERWORLD_MAP[ny][nx]
        // 2 = tree, 3 = rock — impassable
        guard tile != 2 && tile != 3 else { return }
        px = nx; py = ny
        facing = newFacing
        stepCount += 1
        // Tall grass: rustle and roll for encounter
        if tile == 1 {
            grassRustle = (nx, ny)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if grassRustle?.0 == nx && grassRustle?.1 == ny { grassRustle = nil }
            }
            // 22% chance per step into tall grass
            if Double.random(in: 0...1) < 0.22 {
                Haptics.tick()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    onEncounter()
                }
            }
        }
    }
}

private struct TileMapCanvas: View {
    let tiles: [[Int]]
    let tileSize: CGFloat

    var body: some View {
        Canvas { ctx, size in
            for (r, row) in tiles.enumerated() {
                for (c, tile) in row.enumerated() {
                    let rect = CGRect(
                        x: CGFloat(c) * tileSize,
                        y: CGFloat(r) * tileSize,
                        width: tileSize, height: tileSize
                    )
                    drawTile(&ctx, rect: rect, type: tile)
                }
            }
        }
    }

    private func drawTile(_ ctx: inout GraphicsContext, rect: CGRect, type: Int) {
        switch type {
        case 1:
            // Tall grass — darker green with X pattern
            ctx.fill(Path(rect), with: .color(Color(hex: "4a8f4a")))
            let dark = Color(hex: "1f5f1f")
            // 5 V/X grass blade marks
            let marks: [(CGFloat, CGFloat)] = [(8, 6), (16, 4), (22, 8), (10, 16), (20, 18), (14, 22)]
            for (x, y) in marks {
                let p = Path(CGRect(x: rect.minX + x, y: rect.minY + y, width: 2, height: 4))
                ctx.fill(p, with: .color(dark))
            }
        case 2:
            // Tree — dark green canopy with brown trunk
            ctx.fill(Path(rect), with: .color(Color(hex: "7fc97f")))
            // Canopy circle
            let canopy = Path(ellipseIn: CGRect(x: rect.minX + 2, y: rect.minY + 1, width: rect.width - 4, height: rect.height - 8))
            ctx.fill(canopy, with: .color(Color(hex: "1aa370")))
            ctx.stroke(canopy, with: .color(Color(hex: "06010f")), lineWidth: 1.5)
            // Trunk
            let trunk = Path(CGRect(x: rect.midX - 3, y: rect.maxY - 8, width: 6, height: 6))
            ctx.fill(trunk, with: .color(Color(hex: "5c3a1e")))
        case 3:
            // Rock — gray ellipse
            ctx.fill(Path(rect), with: .color(Color(hex: "7fc97f")))
            let rock = Path(ellipseIn: CGRect(x: rect.minX + 4, y: rect.minY + 8, width: rect.width - 8, height: rect.height - 12))
            ctx.fill(rock, with: .color(Color(hex: "9a9a9a")))
            ctx.stroke(rock, with: .color(Color(hex: "06010f")), lineWidth: 1.5)
            // Highlight
            let hi = Path(ellipseIn: CGRect(x: rect.minX + 7, y: rect.minY + 10, width: 6, height: 3))
            ctx.fill(hi, with: .color(Color(hex: "c0c0c0")))
        case 4:
            // Sand path
            ctx.fill(Path(rect), with: .color(Color(hex: "d4b878")))
            // Speckles
            let dark = Color(hex: "a89060")
            for (x, y) in [(6, 8), (18, 10), (12, 20), (22, 22), (4, 22)] {
                ctx.fill(Path(CGRect(x: rect.minX + CGFloat(x), y: rect.minY + CGFloat(y), width: 1, height: 1)),
                         with: .color(dark))
            }
        default:
            // Plain grass
            ctx.fill(Path(rect), with: .color(Color(hex: "7fc97f")))
            // 2 darker dots
            ctx.fill(Path(CGRect(x: rect.minX + 6, y: rect.minY + 10, width: 1, height: 1)),
                     with: .color(Color(hex: "5fa75f")))
            ctx.fill(Path(CGRect(x: rect.minX + 18, y: rect.minY + 20, width: 1, height: 1)),
                     with: .color(Color(hex: "5fa75f")))
        }
    }
}

private struct GrassRustle: View {
    @State private var shake: CGFloat = 0
    var body: some View {
        Text("!")
            .font(.system(size: 18, weight: .black, design: .monospaced))
            .foregroundStyle(Color(hex: "FFD960"))
            .shadow(color: Color(hex: "06010f"), radius: 0, x: 1, y: 1)
            .offset(x: shake, y: -16)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.1).repeatCount(5, autoreverses: true)) {
                    shake = 4
                }
            }
    }
}

// MARK: - Wild encounter (single creature, Gen-1 style)

private struct WildEncounter: View {
    let creature: Creature
    let throwing: Bool
    let ranAway: Bool
    @State private var bob: CGFloat = 0
    @State private var ballY: CGFloat = 200
    @State private var ballX: CGFloat = -120

    private var typeColor: Color {
        switch creature.primary {
        case .code: return Theme.mint
        case .art: return Theme.pink
        case .pixel: return Theme.yellow
        case .doc: return Theme.blue
        case .sound: return Theme.magenta
        case .sun, .spark: return Theme.yellow
        case .moon, .glitch, .spirit: return Theme.magenta
        case .dream, .storm: return Theme.blue
        case .caffeine: return Theme.pink
        default: return Theme.mint
        }
    }

    var body: some View {
        ZStack {
            // Wild Pokemon nameplate (upper-left)
            VStack {
                HStack {
                    WildNameplate(creature: creature)
                        .padding(.leading, 10)
                        .padding(.top, 10)
                    Spacer()
                }
                Spacer()
            }

            // Wild creature on a dirt platform (upper-right)
            VStack {
                HStack {
                    Spacer()
                    ZStack(alignment: .bottom) {
                        // Dirt platform (curved oval with chunky border)
                        Ellipse()
                            .fill(Color(hex: "c2a878"))
                            .overlay(
                                Ellipse()
                                    .fill(Color(hex: "e3c89c"))
                                    .frame(width: 110 * 0.65, height: 22 * 0.55)
                                    .offset(y: -3)
                            )
                            .overlay(
                                Ellipse().strokeBorder(Color(hex: "06010f"), lineWidth: 2)
                            )
                            .frame(width: 110, height: 26)
                            .offset(y: 6)
                        // Creature sprite, bobbing
                        PixelArt(
                            grid: Sprites.forCreature(id: creature.id),
                            scale: 5,
                            palette: Sprites.paletteFor(creature: creature),
                            glowColor: typeColor.opacity(0.5),
                            glowRadius: 10
                        )
                        .offset(y: bob - 14)
                        .opacity(throwing ? 0.5 : (ranAway ? 0 : 1))
                        .scaleEffect(ranAway ? 0.5 : 1)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                                bob = -4
                            }
                        }
                    }
                    .padding(.trailing, 24)
                    .padding(.top, 22)
                }
                Spacer()
            }

            // Pokeball arc (low-left → high-right toward creature)
            if throwing {
                Circle()
                    .fill(
                        LinearGradient(
                            stops: [.init(color: Color(hex: "FF6B6B"), location: 0),
                                    .init(color: Color(hex: "FF6B6B"), location: 0.45),
                                    .init(color: Color(hex: "06010f"), location: 0.46),
                                    .init(color: Color(hex: "06010f"), location: 0.54),
                                    .init(color: .white, location: 0.55),
                                    .init(color: .white, location: 1.0)],
                            startPoint: .top, endPoint: .bottom
                        )
                    )
                    .frame(width: 22, height: 22)
                    .overlay(Circle().strokeBorder(Color(hex: "06010f"), lineWidth: 1.5))
                    .overlay(Circle().fill(Color.white).frame(width: 5, height: 5))
                    .offset(x: ballX, y: ballY)
                    .onAppear {
                        ballX = -120; ballY = 200
                        withAnimation(.timingCurve(0.3, 0.0, 0.6, 1.0, duration: 0.55)) {
                            ballX = 80
                            ballY = -50
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            withAnimation(.spring(response: 0.16, dampingFraction: 0.4).repeatCount(3, autoreverses: true)) {
                                ballX += 8
                            }
                        }
                    }
            }
        }
    }
}

private struct WildNameplate: View {
    let creature: Creature
    private var level: Int {
        switch creature.rarity {
        case .common: return 8
        case .uncommon: return 18
        case .rare: return 32
        case .legendary: return 55
        case .mythic: return 70
        }
    }
    private var hpPct: CGFloat {
        switch creature.rarity {
        case .common: return 0.85
        case .uncommon: return 0.65
        case .rare: return 0.45
        case .legendary: return 0.25
        case .mythic: return 0.12
        }
    }
    private var hpColor: Color {
        hpPct > 0.5 ? Color(hex: "2EE6A0") : (hpPct > 0.25 ? Color(hex: "FFD960") : Color(hex: "FF6B6B"))
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .firstTextBaseline) {
                Text(creature.name.uppercased())
                    .font(.system(size: 11, weight: .black, design: .monospaced))
                Spacer(minLength: 6)
                Text("Lv\(level)")
                    .font(.system(size: 10, weight: .black, design: .monospaced))
            }
            HStack(spacing: 4) {
                Text("HP")
                    .font(.system(size: 8, weight: .black, design: .monospaced))
                    .foregroundStyle(Color(hex: "c87060"))
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 1)
                        .fill(Color(hex: "06010f").opacity(0.2))
                        .frame(width: 70, height: 6)
                    RoundedRectangle(cornerRadius: 1)
                        .fill(hpColor)
                        .frame(width: 70 * hpPct, height: 6)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 1)
                        .strokeBorder(Color(hex: "06010f"), lineWidth: 1)
                        .frame(width: 70, height: 6)
                )
            }
        }
        .foregroundStyle(Color(hex: "06010f"))
        .padding(.horizontal, 10).padding(.vertical, 6)
        .background(Color(hex: "fff7df"))
        .overlay(
            Rectangle().strokeBorder(Color(hex: "06010f"), lineWidth: 2.5)
        )
        .frame(width: 140)
    }
}

// MARK: - Gen-1 dialog box

private struct Gen1DialogBox: View {
    let statusText: String
    let creature: Creature?
    let canThrow: Bool
    let ballCount: Int
    let onThrow: () -> Void
    let onRun: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Status text line + (optional) type pill
            HStack(alignment: .center, spacing: 8) {
                Text(statusText)
                    .font(.system(size: 11, weight: .black, design: .monospaced))
                    .foregroundStyle(Color(hex: "06010f"))
                    .lineLimit(2)
                Spacer()
                if let c = creature {
                    Text("HP")
                        .font(.system(size: 8, weight: .black, design: .monospaced))
                        .foregroundStyle(Color(hex: "06010f"))
                    // HP indicator (rarity-based: more red = harder catch)
                    HPIndicator(rarity: c.rarity)
                }
            }

            // 2x2 action button grid
            HStack(spacing: 6) {
                actionButton(label: "THROW BALL", subtitle: "×\(ballCount)", icon: "◉",
                             enabled: canThrow, action: onThrow)
                actionButton(label: "RUN", subtitle: "skip", icon: "→",
                             enabled: creature != nil, action: onRun)
            }
        }
        .padding(10)
        .background(
            Color(hex: "fff7df")
                .overlay(
                    // Subtle paper texture via gradient
                    LinearGradient(colors: [Color.white.opacity(0.4), .clear],
                                   startPoint: .top, endPoint: .bottom)
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            // Double border: thick black, thin inner
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(Color(hex: "06010f"), lineWidth: 3)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .strokeBorder(Color(hex: "06010f").opacity(0.15), lineWidth: 1)
                        .padding(2)
                )
        )
    }

    private func actionButton(label: String, subtitle: String, icon: String,
                              enabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(icon)
                    .font(.system(size: 14, weight: .black))
                VStack(alignment: .leading, spacing: 0) {
                    Text(label)
                        .font(.system(size: 11, weight: .black, design: .monospaced))
                    Text(subtitle)
                        .font(.system(size: 8, weight: .bold, design: .monospaced))
                        .foregroundStyle(Color(hex: "06010f").opacity(0.5))
                }
                Spacer()
            }
            .padding(.horizontal, 10).padding(.vertical, 7)
            .background(Color.white, in: RoundedRectangle(cornerRadius: 4))
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .strokeBorder(Color(hex: "06010f"), lineWidth: 2)
            )
            .foregroundStyle(enabled ? Color(hex: "06010f") : Color(hex: "06010f").opacity(0.4))
        }
        .disabled(!enabled)
        .buttonStyle(.plain)
    }
}

private struct HPIndicator: View {
    let rarity: Rarity
    private var pct: CGFloat {
        switch rarity {
        case .common: return 0.85
        case .uncommon: return 0.65
        case .rare: return 0.45
        case .legendary: return 0.22
        case .mythic: return 0.10
        }
    }
    private var color: Color {
        pct > 0.5 ? Theme.mint : (pct > 0.25 ? Theme.yellow : Theme.pink)
    }
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color(hex: "06010f").opacity(0.18))
                .frame(width: 50, height: 8)
            RoundedRectangle(cornerRadius: 2)
                .fill(color)
                .frame(width: 50 * pct, height: 8)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 2)
                .strokeBorder(Color(hex: "06010f"), lineWidth: 1)
                .frame(width: 50, height: 8)
        )
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
        VStack(spacing: 0) {
            // Solid pokemon-blue sky
            Color(hex: "8cd0f0")
                .frame(height: 100)
                .overlay(
                    // One simple cloud silhouette in the sky
                    HStack {
                        Spacer()
                        CloudBlob()
                            .padding(.trailing, 40)
                            .padding(.top, 14)
                    }
                )
            // Sharp horizon line
            Color(hex: "06010f").frame(height: 2)
            // Green grass ground with pixel-dot texture
            ZStack {
                Color(hex: "7fc97f")
                DottedGrassTexture()
            }
            .frame(maxHeight: .infinity)
        }
    }
}

private struct CloudBlob: View {
    var body: some View {
        ZStack {
            // Build a chunky cloud from three filled rects (pixel-clouds vibe)
            HStack(spacing: -8) {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white)
                    .frame(width: 26, height: 16)
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white)
                    .frame(width: 40, height: 22)
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white)
                    .frame(width: 26, height: 16)
            }
            .overlay(
                HStack(spacing: -8) {
                    RoundedRectangle(cornerRadius: 14).strokeBorder(Color(hex: "06010f"), lineWidth: 1.5)
                        .frame(width: 26, height: 16)
                    RoundedRectangle(cornerRadius: 18).strokeBorder(Color(hex: "06010f"), lineWidth: 1.5)
                        .frame(width: 40, height: 22)
                    RoundedRectangle(cornerRadius: 14).strokeBorder(Color(hex: "06010f"), lineWidth: 1.5)
                        .frame(width: 26, height: 16)
                }
            )
        }
    }
}

private struct DottedGrassTexture: View {
    var body: some View {
        Canvas { ctx, size in
            let darker = Color(hex: "5fa75f")
            let dotSize: CGFloat = 1.5
            var y: CGFloat = 4
            var even = false
            while y < size.height {
                let stride = 14.0
                var x: CGFloat = even ? 4 : 11
                while x < size.width {
                    ctx.fill(Path(CGRect(x: x, y: y, width: dotSize, height: dotSize)),
                             with: .color(darker))
                    ctx.fill(Path(CGRect(x: x + 4, y: y + 3, width: dotSize, height: dotSize)),
                             with: .color(darker))
                    x += stride
                }
                y += 9
                even.toggle()
            }
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
                    palette: Sprites.paletteFor(creature: creature),
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
