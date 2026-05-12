import SwiftUI

struct CreatureDetailView: View {
    let creature: Creature
    let onDismiss: () -> Void

    @State private var bob: CGFloat = 0
    @State private var statProgress: CGFloat = 0
    @State private var cardScale: CGFloat = 0.92
    @State private var cardOpacity: Double = 0

    var body: some View {
        ZStack {
            // Backdrop — tap to dismiss
            Color.black.opacity(0.65)
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture { onDismiss() }

            // Card
            card
                .scaleEffect(cardScale)
                .opacity(cardOpacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.42, dampingFraction: 0.78)) {
                cardScale = 1
                cardOpacity = 1
            }
            withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true)) {
                bob = -6
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.18)) {
                statProgress = 1
            }
        }
    }

    // MARK: - Card

    private var card: some View {
        ScrollView {
            VStack(spacing: 16) {
                header
                spriteArea
                typePillsRow
                rarityBadge
                statsGrid
                signatureMoveSection
                loreCard
                backButton
            }
            .padding(16)
        }
        .background(Theme.popoverBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .strokeBorder(typeColor.opacity(0.35), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .shadow(color: typeColor.opacity(0.45), radius: 24, x: 0, y: 12)
        .padding(14)
    }

    // MARK: - Header

    private var header: some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            Text(creature.dexNumber)
                .font(.system(.callout, design: .monospaced).weight(.bold))
                .foregroundStyle(.secondary)
            Text(creature.name)
                .font(.system(.title, design: .rounded).weight(.black))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Spacer()
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .heavy))
                    .foregroundStyle(.white)
                    .frame(width: 26, height: 26)
                    .background(Color.white.opacity(0.10), in: Circle())
                    .overlay(Circle().strokeBorder(Color.white.opacity(0.18), lineWidth: 0.5))
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Sprite

    private var spriteArea: some View {
        ZStack {
            RadialGradient(
                colors: [typeColor.opacity(0.55), typeColor.opacity(0.15), .clear],
                center: .center,
                startRadius: 0,
                endRadius: 160
            )
            PixelArt(
                grid: Sprites.forCreature(id: creature.id),
                scale: 6,
                glowColor: typeColor.opacity(0.7),
                glowRadius: 18
            )
            .offset(y: bob)
            .shadow(color: .black.opacity(0.45), radius: 12, x: 0, y: 8)
        }
        .frame(height: 180)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.03))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(typeColor.opacity(0.3), lineWidth: 0.5))
    }

    // MARK: - Type pills

    private var typePillsRow: some View {
        HStack(spacing: 8) {
            TypePill(type: creature.primary)
            if let secondary = creature.secondary {
                TypePill(type: secondary)
            }
            Spacer()
        }
    }

    // MARK: - Rarity badge

    private var rarityBadge: some View {
        HStack {
            HStack(spacing: 6) {
                Image(systemName: rarityIcon)
                    .font(.system(size: 10, weight: .black))
                Text(creature.rarity.rawValue.uppercased())
                    .font(.system(size: 10, weight: .black, design: .rounded))
                    .kerning(0.8)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Capsule().fill(rarityColor))
            .overlay(
                Capsule().strokeBorder(
                    creature.rarity == .mythic ? Theme.yellow : .white.opacity(0.18),
                    lineWidth: creature.rarity == .mythic ? 1.5 : 0.5
                )
            )
            .shadow(color: rarityColor.opacity(0.5), radius: 6)
            Spacer()
        }
    }

    private var rarityColor: Color {
        switch creature.rarity {
        case .common:    return Color(white: 0.45)
        case .uncommon:  return Theme.mint
        case .rare:      return Theme.blue
        case .legendary: return Theme.magenta
        case .mythic:    return Theme.pink
        }
    }

    private var rarityIcon: String {
        switch creature.rarity {
        case .common:    return "circle.fill"
        case .uncommon:  return "leaf.fill"
        case .rare:      return "diamond.fill"
        case .legendary: return "crown.fill"
        case .mythic:    return "sparkles"
        }
    }

    // MARK: - Stats grid

    private var statsGrid: some View {
        VStack(spacing: 8) {
            StatBar(label: "HP",  value: creature.hp,  color: typeColor, progress: statProgress)
            StatBar(label: "FP",  value: creature.fp,  color: typeColor, progress: statProgress)
            StatBar(label: "STA", value: creature.sta, color: typeColor, progress: statProgress)
            StatBar(label: "SPD", value: creature.spd, color: typeColor, progress: statProgress)

            HStack {
                Text("TOTAL")
                    .font(.system(size: 11, weight: .black, design: .rounded))
                    .kerning(0.8)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(creature.statTotal)")
                    .font(.system(.title3, design: .monospaced).weight(.heavy))
                    .foregroundStyle(.white)
            }
            .padding(.top, 4)
        }
        .padding(12)
        .background(Color.white.opacity(0.04), in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(Color.white.opacity(0.08), lineWidth: 0.5))
    }

    // MARK: - Signature move

    private var signatureMoveSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: "bolt.fill")
                    .font(.system(size: 10, weight: .heavy))
                    .foregroundStyle(Theme.yellow)
                Text("SIGNATURE MOVE")
                    .font(.system(size: 9, weight: .black, design: .rounded))
                    .kerning(0.8)
                    .foregroundStyle(.secondary)
            }
            Text(creature.signatureMove)
                .font(.system(.headline, design: .rounded).weight(.heavy))
                .foregroundStyle(.white)
            Text("A devastating attack unique to \(creature.name).")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.white.opacity(0.04), in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(Color.white.opacity(0.08), lineWidth: 0.5))
    }

    // MARK: - Lore

    private var loreCard: some View {
        HStack(alignment: .top, spacing: 10) {
            RoundedRectangle(cornerRadius: 2)
                .fill(typeColor)
                .frame(width: 3)
                .shadow(color: typeColor.opacity(0.6), radius: 4)
            VStack(alignment: .leading, spacing: 4) {
                Text("LORE")
                    .font(.system(size: 9, weight: .black, design: .rounded))
                    .kerning(0.8)
                    .foregroundStyle(.secondary)
                Text(creature.blurb)
                    .font(.system(.callout, design: .rounded).italic())
                    .foregroundStyle(.white.opacity(0.9))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(Color.white.opacity(0.04), in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(Color.white.opacity(0.08), lineWidth: 0.5))
    }

    // MARK: - Back button

    private var backButton: some View {
        Button(action: onDismiss) {
            HStack(spacing: 6) {
                Image(systemName: "chevron.left")
                Text("Back to Dex")
            }
        }
        .buttonStyle(PrimaryGradientButtonStyle())
        .padding(.top, 4)
    }

    // MARK: - Type color

    private var typeColor: Color {
        switch creature.primary {
        case .code:     return Theme.mint
        case .art:      return Theme.pink
        case .doc:      return Theme.blue
        case .pixel:    return Theme.yellow
        case .sound:    return Theme.magenta
        case .sun:      return Theme.yellow
        case .moon:     return Theme.magenta
        case .dream:    return Theme.magenta
        case .spark:    return Theme.yellow
        case .zen:      return Theme.mint
        case .caffeine: return Theme.yellow
        case .storm:    return Theme.blue
        case .glitch:   return Theme.magenta
        case .spirit:   return Theme.magenta
        case .time:     return Theme.yellow
        }
    }
}

// MARK: - Stat bar

private struct StatBar: View {
    let label: String
    let value: Int
    let color: Color
    let progress: CGFloat

    private let maxStat: CGFloat = 120

    var body: some View {
        HStack(spacing: 8) {
            Text(label)
                .font(.system(size: 10, weight: .black, design: .rounded))
                .kerning(0.6)
                .foregroundStyle(.secondary)
                .frame(width: 34, alignment: .leading)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.08))
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [color.opacity(0.7), color],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * targetRatio * progress)
                        .shadow(color: color.opacity(0.55), radius: 5)
                }
            }
            .frame(height: 8)

            Text("\(value)")
                .font(.system(size: 12, weight: .heavy, design: .monospaced))
                .foregroundStyle(.white)
                .frame(width: 32, alignment: .trailing)
        }
    }

    private var targetRatio: CGFloat {
        min(1, CGFloat(value) / maxStat)
    }
}
