import SwiftUI

// MARK: - Type badge (hexagonal, with symbol)

struct TypeBadge: View {
    let type: CreatureType
    var size: CGFloat = 28

    private var colors: (Color, Color) {
        switch type {
        case .code:     return (Theme.mint, Color(hex: "159a6a"))
        case .art:      return (Theme.magenta, Theme.pink)
        case .doc:      return (Color(hex: "FFE890"), Theme.yellow)
        case .sound:    return (Theme.blue, Theme.magenta)
        case .sun:      return (Theme.yellow, Theme.pink)
        case .moon:     return (Color(hex: "06010f"), Theme.magenta)
        case .dream:    return (Color(hex: "e4a6ff"), Color(hex: "9af2ce"))
        case .spark:    return (Theme.yellow, Theme.mint)
        case .zen:      return (Theme.mint, Theme.blue)
        case .caffeine: return (Color(hex: "fff7df"), Color(hex: "7a4a2a"))
        case .storm:    return (Theme.blue, Theme.magenta)
        case .glitch:   return (Theme.magenta, Theme.blue)
        case .spirit:   return (Theme.magenta, Theme.mint)
        case .pixel:    return (Theme.blue, Theme.mint)
        case .time:     return (Theme.yellow, Theme.magenta)
        }
    }

    var body: some View {
        ZStack {
            HexagonShape()
                .fill(LinearGradient(colors: [colors.0, colors.1], startPoint: .top, endPoint: .bottom))
                .overlay(HexagonShape().stroke(Color(hex: "06010f"), lineWidth: 1.5))
            TypeSymbolView(type: type, size: size * 0.5)
        }
        .frame(width: size, height: size)
    }
}

private struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        // points: (0.5, 0) (1.0, 0.25) (1.0, 0.75) (0.5, 1.0) (0, 0.75) (0, 0.25)
        p.move(to:    CGPoint(x: 0.5 * w, y: 0.0625 * h))
        p.addLine(to: CGPoint(x: 0.875 * w, y: 0.25 * h))
        p.addLine(to: CGPoint(x: 0.875 * w, y: 0.75 * h))
        p.addLine(to: CGPoint(x: 0.5 * w, y: 0.9375 * h))
        p.addLine(to: CGPoint(x: 0.125 * w, y: 0.75 * h))
        p.addLine(to: CGPoint(x: 0.125 * w, y: 0.25 * h))
        p.closeSubpath()
        return p
    }
}

private struct TypeSymbolView: View {
    let type: CreatureType
    let size: CGFloat

    var body: some View {
        Group {
            switch type {
            case .code:     Text("{}").font(.system(size: size * 1.1, weight: .black, design: .monospaced))
            case .art:      Image(systemName: "paintpalette.fill")
            case .doc:      Image(systemName: "doc.text.fill")
            case .sound:    Image(systemName: "waveform")
            case .sun:      Image(systemName: "sun.max.fill")
            case .moon:     Image(systemName: "moon.fill")
            case .dream:    Image(systemName: "cloud.fill")
            case .spark:    Image(systemName: "bolt.fill")
            case .zen:      Image(systemName: "circle.dashed")
            case .caffeine: Image(systemName: "cup.and.saucer.fill")
            case .storm:    Image(systemName: "cloud.bolt.fill")
            case .glitch:   Image(systemName: "questionmark.square.fill")
            case .spirit:   Image(systemName: "sparkles")
            case .pixel:    Image(systemName: "square.grid.3x3.fill")
            case .time:     Image(systemName: "clock.fill")
            }
        }
        .font(.system(size: size, weight: .heavy))
        .foregroundStyle(.white)
        .shadow(color: .black.opacity(0.3), radius: 1, y: 1)
    }
}

// MARK: - Type pill (badge + uppercased label)

struct TypePill: View {
    let type: CreatureType

    var body: some View {
        HStack(spacing: 4) {
            TypeBadge(type: type, size: 16)
            Text(type.rawValue.uppercased())
                .font(.system(size: 9, weight: .black))
                .kerning(0.6)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(
            Capsule().fill(
                LinearGradient(
                    colors: [typeColor.opacity(0.8), typeColor.opacity(0.4)],
                    startPoint: .leading, endPoint: .trailing
                )
            )
        )
        .overlay(Capsule().strokeBorder(Color(hex: "06010f"), lineWidth: 0.5))
        .foregroundStyle(Color(hex: "06010f"))
    }

    private var typeColor: Color {
        switch type {
        case .code: return Theme.mint
        case .art: return Theme.pink
        case .doc: return Theme.yellow
        case .sound: return Theme.blue
        case .sun: return Theme.yellow
        case .moon: return Theme.magenta
        case .dream: return Color(hex: "e4a6ff")
        case .spark: return Theme.yellow
        case .zen: return Theme.mint
        case .caffeine: return Color(hex: "c9a37a")
        case .storm: return Theme.blue
        case .glitch: return Theme.magenta
        case .spirit: return Theme.magenta
        case .pixel: return Theme.mint
        case .time: return Theme.yellow
        }
    }
}

// MARK: - Sigil (magical seal, 4 tiers)

struct Sigil: View {
    var tier: Int = 4
    var size: CGFloat = 64

    var body: some View {
        ZStack {
            // outer flame petals (tier 4)
            if tier >= 4 {
                ForEach(0..<12, id: \.self) { i in
                    let a = Double(i) / 12 * .pi * 2
                    Circle().fill(Theme.yellow)
                        .frame(width: size * 0.05, height: size * 0.05)
                        .offset(x: cos(a) * size * 0.47, y: sin(a) * size * 0.47)
                }
            }
            // blue dot ring (tier 3+)
            if tier >= 3 {
                ForEach(0..<8, id: \.self) { i in
                    let a = Double(i) / 8 * .pi * 2
                    Circle().fill(Theme.blue)
                        .frame(width: size * 0.05, height: size * 0.05)
                        .offset(x: cos(a) * size * 0.4, y: sin(a) * size * 0.4)
                }
            }
            // yellow corner petals (tier 2+)
            if tier >= 2 {
                ForEach(0..<4, id: \.self) { i in
                    let a = Double(i) / 4 * .pi * 2 + .pi / 4
                    Circle().fill(Theme.yellow)
                        .frame(width: size * 0.06, height: size * 0.06)
                        .offset(x: cos(a) * size * 0.34, y: sin(a) * size * 0.34)
                }
            }
            // magenta hex (tier 2+)
            if tier >= 2 {
                HexOutline().stroke(Theme.magenta, lineWidth: 2)
                    .frame(width: size * 0.625, height: size * 0.625)
            }
            // pink ring
            Circle().stroke(Theme.pink, lineWidth: 2)
                .frame(width: size * 0.5, height: size * 0.5)
            // mint star
            StarShape().fill(Theme.mint)
                .frame(width: size * 0.45, height: size * 0.45)
                .overlay(StarShape().stroke(Color(hex: "06010f"), lineWidth: 1)
                    .frame(width: size * 0.45, height: size * 0.45))
            // center dot
            Circle().fill(Theme.yellow)
                .frame(width: size * 0.06, height: size * 0.06)
        }
        .frame(width: size, height: size)
        .shadow(color: Theme.mint.opacity(0.7), radius: tier >= 3 ? size * 0.25 : 0)
    }
}

private struct HexOutline: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let cx = rect.midX, cy = rect.midY, r = min(rect.width, rect.height) / 2
        for i in 0..<6 {
            let a: Double = Double(i) / 6 * .pi * 2 - .pi / 2
            let pt = CGPoint(x: cx + CGFloat(Foundation.cos(a)) * r,
                             y: cy + CGFloat(Foundation.sin(a)) * r)
            if i == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
        }
        p.closeSubpath()
        return p
    }
}

private struct StarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let cx = rect.midX, cy = rect.midY
        let outerR = min(rect.width, rect.height) / 2
        let innerR = outerR * 0.4
        for i in 0..<10 {
            let a: Double = Double(i) / 10 * .pi * 2 - .pi / 2
            let r: CGFloat = i % 2 == 0 ? outerR : innerR
            let pt = CGPoint(x: cx + CGFloat(Foundation.cos(a)) * r,
                             y: cy + CGFloat(Foundation.sin(a)) * r)
            if i == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
        }
        p.closeSubpath()
        return p
    }
}

// MARK: - FocusDex wordmark

struct FocusDexWordmark: View {
    var fontSize: CGFloat = 32

    var body: some View {
        Text("FocusDex")
            .font(.system(size: fontSize, weight: .black, design: .rounded))
            .foregroundStyle(
                LinearGradient(
                    colors: [Theme.mint, Theme.blue, Theme.magenta, Theme.pink],
                    startPoint: .leading, endPoint: .trailing
                )
            )
            .shadow(color: Color(hex: "06010f"), radius: 0, x: 1, y: 1)
            .shadow(color: Color(hex: "06010f"), radius: 0, x: -1, y: -1)
            .shadow(color: Color(hex: "06010f"), radius: 0, x: 1, y: -1)
            .shadow(color: Color(hex: "06010f"), radius: 0, x: -1, y: 1)
    }
}

// MARK: - Ball view (pixel art with optional count badge)

struct BallView: View {
    enum Tier { case focus, great, ultra, master }
    let tier: Tier
    var scale: CGFloat = 2

    private var sprite: [String] {
        switch tier {
        case .focus:  return Sprites.focusBall
        case .great:  return Sprites.greatBall
        case .ultra:  return Sprites.ultraBall
        case .master: return Sprites.masterBall
        }
    }

    var body: some View {
        PixelArt(grid: sprite, scale: scale)
    }
}

// MARK: - Pokédex cell using sprites

struct DexCellSprite: View {
    let creature: Creature
    @State private var bob: CGFloat = 0

    var body: some View {
        VStack(spacing: 2) {
            PixelArt(
                grid: Sprites.forCreature(id: creature.id),
                scale: 3,
                palette: Sprites.paletteFor(creature: creature),
                glowColor: typeColor.opacity(0.6),
                glowRadius: 8
            )
            .offset(y: bob)
            .onAppear {
                withAnimation(.easeInOut(duration: Double.random(in: 1.8...2.6)).repeatForever(autoreverses: true)) {
                    bob = -4
                }
            }
            Text(creature.dexNumber)
                .font(.system(size: 9, weight: .bold, design: .monospaced))
                .foregroundStyle(.secondary)
            Text(creature.name)
                .font(.system(size: 10, weight: .heavy, design: .rounded))
                .lineLimit(1)
        }
        .frame(width: 92, height: 100)
        .background(
            RadialGradient(colors: [typeColor.opacity(0.18), .clear], center: .center, startRadius: 0, endRadius: 50)
                .background(Color.white.opacity(0.04))
        )
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(typeColor.opacity(0.3), lineWidth: 0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var typeColor: Color {
        switch creature.primary {
        case .code: return Theme.mint
        case .art: return Theme.pink
        case .doc: return Theme.blue
        case .pixel: return Theme.yellow
        case .sound: return Theme.magenta
        default: return Theme.magenta
        }
    }
}
