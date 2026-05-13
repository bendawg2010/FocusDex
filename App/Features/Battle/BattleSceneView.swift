import SwiftUI

// MARK: - BattleSceneView
//
// 1v1 turn-based battle MOCKUP — Pokemon Gen-1 vibes, modernized.
// No real battle AI; just animated sprites, HP bars, screen flashes,
// and an action ticker. Opponent is a random "wild" creature from
// `Creature.starters` excluding the player's chosen creature.

struct BattleSceneView: View {
    let playerCreature: Creature
    let onDismiss: () -> Void

    @State private var opponent: Creature = Creature.starters[0]
    @State private var opponentHP: Int = 100
    @State private var playerHP: Int = 100
    @State private var recentMove: String? = nil
    @State private var flashOpacity: Double = 0
    @State private var opponentShake: CGFloat = 0
    @State private var playerBob: CGFloat = 0
    @State private var opponentBob: CGFloat = 0
    @State private var hoveredMove: Int? = nil
    @State private var isLocked: Bool = false
    @State private var showIntro: Bool = true
    @State private var introPulse: Double = 0.6

    private let maxHP: Int = 100
    private let playerLevel: Int = 12
    private let opponentLevel: Int = 11

    // MARK: - Moves

    private enum MoveCategory {
        case physical, special, status
        var color: Color {
            switch self {
            case .physical: return Theme.pink
            case .special:  return Theme.blue
            case .status:   return Theme.mint
            }
        }
        var label: String {
            switch self {
            case .physical: return "PHYSICAL"
            case .special:  return "SPECIAL"
            case .status:   return "STATUS"
            }
        }
    }

    private struct MoveSlot { let name: String; let category: MoveCategory }

    private var moves: [MoveSlot] {
        [
            MoveSlot(name: playerCreature.signatureMove, category: .special),
            MoveSlot(name: "Quick Strike", category: .physical),
            MoveSlot(name: "Defend", category: .status),
            MoveSlot(name: "Switch", category: .status),
        ]
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            arenaBackground

            VStack(spacing: 0) {
                HStack(alignment: .top) {
                    runButton
                    Spacer()
                    opponentPlatform
                }
                .padding(.horizontal, 16)
                .padding(.top, 14)

                Spacer(minLength: 8)

                HStack(alignment: .bottom) {
                    playerPlatform
                    Spacer()
                    actionTicker
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 6)

                moveGrid
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
            }

            Color.white
                .opacity(flashOpacity)
                .allowsHitTesting(false)
                .ignoresSafeArea()

            if showIntro {
                VStack {
                    Text("WILD \(opponent.name.uppercased()) APPEARED!")
                        .font(.system(size: 12, weight: .black, design: .monospaced))
                        .kerning(1.2)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12).padding(.vertical, 6)
                        .background(Capsule().fill(Color.black.opacity(0.65)))
                        .overlay(Capsule().strokeBorder(Theme.yellow.opacity(0.7), lineWidth: 1))
                        .shadow(color: Theme.yellow.opacity(0.5), radius: 6)
                        .opacity(introPulse)
                        .padding(.top, 6)
                    Spacer()
                }
                .allowsHitTesting(false)
                .transition(.opacity)
            }
        }
        .frame(width: 440, height: 560)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .strokeBorder(Theme.magenta.opacity(0.35), lineWidth: 1)
        )
        .onAppear {
            let pool = Creature.starters.filter { $0.id != playerCreature.id }
            opponent = pool.randomElement() ?? Creature.starters[0]
            withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) { playerBob = -4 }
            withAnimation(.easeInOut(duration: 2.1).repeatForever(autoreverses: true)) { opponentBob = -3 }
        }
    }

    // MARK: - Arena background

    private var arenaBackground: some View {
        ZStack {
            RadialGradient(
                colors: [Color(hex: "3a1a4a"), Color(hex: "1a0826"), Theme.bgDeep],
                center: .center, startRadius: 40, endRadius: 360
            )
            .ignoresSafeArea()

            RadialGradient(
                colors: [Theme.pink.opacity(0.18), .clear],
                center: .center, startRadius: 20, endRadius: 220
            )
            .blendMode(.plusLighter)
            .ignoresSafeArea()

            StarField()
        }
    }

    // MARK: - Run button (top-left)

    private var runButton: some View {
        Button(action: onDismiss) {
            HStack(spacing: 6) {
                Image(systemName: "figure.run")
                Text("Run")
                    .font(.system(size: 12, weight: .black, design: .rounded))
                    .kerning(0.5)
            }
            .padding(.horizontal, 12).padding(.vertical, 7)
            .background(Capsule().fill(Color.black.opacity(0.55)))
            .overlay(Capsule().strokeBorder(Theme.pink.opacity(0.6), lineWidth: 1))
            .foregroundStyle(.white)
        }
        .buttonStyle(.plain)
        .brandGlow(Theme.pink, radius: 8)
    }

    // MARK: - Opponent (top-right)

    private var opponentPlatform: some View {
        VStack(alignment: .trailing, spacing: 8) {
            combatantCard(name: opponent.name, level: opponentLevel,
                          type: opponent.primary, hp: opponentHP, showNumeric: false)
                .frame(width: 188)

            ZStack {
                Ellipse()
                    .fill(RadialGradient(colors: [Theme.magenta.opacity(0.5), .clear],
                                         center: .center, startRadius: 0, endRadius: 60))
                    .frame(width: 130, height: 32).offset(y: 38)
                PixelArt(grid: Sprites.forCreature(id: opponent.id),
                         scale: 4,
                         palette: Sprites.paletteFor(creature: opponent),
                         glowColor: Theme.magenta.opacity(0.6), glowRadius: 10)
                    .offset(x: opponentShake, y: opponentBob)
            }
        }
    }

    // MARK: - Player (bottom-left)

    private var playerPlatform: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack {
                Ellipse()
                    .fill(RadialGradient(colors: [Theme.mint.opacity(0.4), .clear],
                                         center: .center, startRadius: 0, endRadius: 70))
                    .frame(width: 160, height: 36).offset(y: 56)
                PixelArt(grid: Sprites.forCreature(id: playerCreature.id),
                         scale: 6,
                         palette: Sprites.paletteFor(creature: playerCreature),
                         glowColor: Theme.mint.opacity(0.65), glowRadius: 12)
                    .scaleEffect(x: -1, y: 1) // back-view feel via mirror
                    .offset(y: playerBob)
            }
            combatantCard(name: playerCreature.name, level: playerLevel,
                          type: playerCreature.primary, hp: playerHP, showNumeric: true)
                .frame(width: 200)
        }
    }

    // MARK: - Combatant info card

    private func combatantCard(
        name: String, level: Int, type: CreatureType, hp: Int, showNumeric: Bool
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(name)
                    .font(.system(size: 13, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                Spacer(minLength: 4)
                Text("Lv. \(level)")
                    .font(.system(size: 10, weight: .black, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.85))
            }
            HPBar(hp: hp, maxHP: maxHP, showNumeric: showNumeric)
            HStack(spacing: 4) { TypePill(type: type); Spacer() }
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.black.opacity(0.55)))
        .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.white.opacity(0.08), lineWidth: 0.5))
    }

    // MARK: - Action ticker

    private var actionTicker: some View {
        Group {
            if let move = recentMove {
                Text(move)
                    .font(.system(size: 11, weight: .black, design: .rounded))
                    .kerning(0.4)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10).padding(.vertical, 6)
                    .background(
                        Capsule().fill(LinearGradient(
                            colors: [Theme.yellow.opacity(0.85), Theme.pink.opacity(0.85)],
                            startPoint: .leading, endPoint: .trailing
                        ))
                    )
                    .overlay(Capsule().strokeBorder(Color.black.opacity(0.5), lineWidth: 1))
                    .shadow(color: Theme.yellow.opacity(0.6), radius: 8)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .frame(maxWidth: 180, alignment: .trailing)
    }

    // MARK: - Move grid (2x2)

    private var moveGrid: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) { moveButton(0); moveButton(1) }
            HStack(spacing: 8) { moveButton(2); moveButton(3) }
        }
    }

    private func moveButton(_ index: Int) -> some View {
        let move = moves[index]
        let isHovered = hoveredMove == index
        let c = move.category.color

        return Button { tap(move: move) } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(move.name)
                        .font(.system(size: 13, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white).lineLimit(1)
                    Text(move.category.label)
                        .font(.system(size: 8, weight: .black, design: .monospaced))
                        .kerning(0.8).foregroundStyle(.white.opacity(0.7))
                }
                Spacer()
                Circle().fill(c).frame(width: 8, height: 8).brandGlow(c, radius: 6)
            }
            .padding(.horizontal, 12).padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12).fill(LinearGradient(
                    colors: [c.opacity(isHovered ? 0.55 : 0.32), c.opacity(isHovered ? 0.30 : 0.16)],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                ))
            )
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(c.opacity(isHovered ? 0.9 : 0.5), lineWidth: 1))
            .shadow(color: c.opacity(isHovered ? 0.55 : 0.2), radius: isHovered ? 12 : 6)
            .scaleEffect(isHovered ? 1.02 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isHovered)
        }
        .buttonStyle(.plain)
        .onHover { hovering in hoveredMove = hovering ? index : (hoveredMove == index ? nil : hoveredMove) }
        .disabled(isLocked)
        .opacity(isLocked ? 0.7 : 1.0)
    }

    // MARK: - Tap handler

    private func tap(move: MoveSlot) {
        guard !isLocked else { return }
        isLocked = true

        withAnimation(.easeOut(duration: 0.08)) { flashOpacity = 0.85 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
            withAnimation(.easeIn(duration: 0.22)) { flashOpacity = 0 }
        }

        withAnimation(.easeInOut(duration: 0.05).repeatCount(6, autoreverses: true)) {
            opponentShake = 6
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.36) {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) { opponentShake = 0 }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.85)) {
                opponentHP = max(0, opponentHP - 12)
            }
        }

        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
            recentMove = "\(playerCreature.name) used \(move.name)!"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.85) {
            withAnimation(.easeInOut(duration: 0.25)) { recentMove = "It's super effective!" }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.9) {
            withAnimation(.easeOut(duration: 0.3)) { recentMove = nil }
            isLocked = false
        }
    }
}

// MARK: - HP bar

private struct HPBar: View {
    let hp: Int
    let maxHP: Int
    let showNumeric: Bool

    private var pct: Double { Double(max(0, hp)) / Double(max(1, maxHP)) }
    private var barColor: Color {
        if pct > 0.5 { return Theme.mint }
        if pct > 0.2 { return Theme.yellow }
        return Theme.pink
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 4) {
                Text("HP").font(.system(size: 9, weight: .black, design: .monospaced)).foregroundStyle(Theme.yellow)
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Color.black.opacity(0.6)).frame(height: 7)
                        Capsule()
                            .fill(LinearGradient(colors: [barColor, barColor.opacity(0.7)], startPoint: .leading, endPoint: .trailing))
                            .frame(width: geo.size.width * pct, height: 7)
                            .shadow(color: barColor.opacity(0.6), radius: 4)
                    }
                    .overlay(Capsule().strokeBorder(Color.white.opacity(0.15), lineWidth: 0.5))
                }
                .frame(height: 7)
            }
            if showNumeric {
                Text("\(max(0, hp))/\(maxHP)")
                    .font(.system(size: 9, weight: .black, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.85))
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}

// MARK: - Star field (scattered pixel stars, twinkling)

private struct StarField: View {
    private let stars: [(x: CGFloat, y: CGFloat, size: CGFloat, color: Color)] = [
        (0.08, 0.12, 2, Theme.yellow), (0.18, 0.05, 1.5, .white), (0.32, 0.18, 2, Theme.mint),
        (0.45, 0.08, 1.5, Theme.pink), (0.62, 0.14, 2, .white), (0.78, 0.06, 1.5, Theme.yellow),
        (0.92, 0.16, 2, Theme.magenta), (0.05, 0.32, 1.5, .white), (0.22, 0.40, 2, Theme.mint),
        (0.55, 0.36, 1.5, Theme.yellow), (0.71, 0.42, 2, .white), (0.88, 0.34, 1.5, Theme.pink),
        (0.12, 0.58, 1.5, Theme.magenta), (0.38, 0.62, 2, Theme.yellow), (0.94, 0.60, 1.5, .white),
        (0.10, 0.78, 1.5, Theme.mint), (0.50, 0.82, 2, Theme.pink), (0.85, 0.80, 1.5, Theme.yellow),
    ]
    @State private var twinkle: Double = 0

    var body: some View {
        GeometryReader { geo in
            ForEach(0..<stars.count, id: \.self) { i in
                let s = stars[i]
                Rectangle().fill(s.color)
                    .frame(width: s.size, height: s.size)
                    .position(x: geo.size.width * s.x, y: geo.size.height * s.y)
                    .opacity(0.4 + 0.6 * abs(sin(twinkle + Double(i) * 0.7)))
                    .shadow(color: s.color.opacity(0.7), radius: 2)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.linear(duration: 6).repeatForever(autoreverses: false)) { twinkle = .pi * 2 }
        }
    }
}
