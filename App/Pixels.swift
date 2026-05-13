import SwiftUI

// MARK: - Color hex helper

extension Color {
    init(hex: String) {
        let hex = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Pixel palette (matches the design's PAL exactly)

enum PixelPalette {
    static let standard: [Character: Color] = [
        "k": Color(hex: "06010f"),
        "K": Color(hex: "1a0f2e"),
        "w": .white,
        "c": Color(hex: "fff7df"),
        "m": Color(hex: "2EE6A0"),
        "M": Color(hex: "1aa370"),
        "L": Color(hex: "9af2ce"),
        "p": Color(hex: "FF6B6B"),
        "P": Color(hex: "a83a3a"),
        "q": Color(hex: "ffb3b3"),
        "g": Color(hex: "C147FF"),
        "G": Color(hex: "7a2da8"),
        "h": Color(hex: "e4a6ff"),
        "b": Color(hex: "47A0FF"),
        "B": Color(hex: "2a64a8"),
        "l": Color(hex: "a8d4ff"),
        "y": Color(hex: "FFD960"),
        "Y": Color(hex: "a88f33"),
        "e": Color(hex: "fff0b3"),
        "n": Color(hex: "3a2050"),
        "o": Color(hex: "ff9a3a"),
    ]
}

// MARK: - PixelArt — Canvas-based grid renderer

struct PixelArt: View {
    let grid: [String]
    var scale: CGFloat = 4
    var palette: [Character: Color] = PixelPalette.standard
    var glowColor: Color? = nil
    var glowRadius: CGFloat = 12

    var body: some View {
        let cols = CGFloat(grid.first?.count ?? 0)
        let rows = CGFloat(grid.count)
        Canvas { ctx, _ in
            for (y, row) in grid.enumerated() {
                for (x, ch) in row.enumerated() {
                    guard let color = palette[ch] else { continue }
                    let rect = CGRect(
                        x: CGFloat(x) * scale,
                        y: CGFloat(y) * scale,
                        width: scale,
                        height: scale
                    )
                    ctx.fill(Path(rect), with: .color(color))
                }
            }
        }
        .frame(width: cols * scale, height: rows * scale)
        .shadow(color: glowColor ?? .clear, radius: glowColor != nil ? glowRadius : 0)
    }
}

// MARK: - Sprite library

enum Sprites {

    // ── Mascot (Notchy) ──
    static let notchy: [String] = [
        "............................",
        "....kkkkkkkkkkkkkkkkkkkk....",
        "...kKKKKKKKKKKKKKKKKKKKKk...",
        "..kKKKKKKKKKKKKKKKKKKKKKKk..",
        ".kKKKKKKKKKKKKKKKKKKKKKKKKk.",
        ".kKKKKwwKKKKKKKKKKKKwwKKKKk.",
        ".kKKKwwwwKKKKKKKKKKwwwwKKKk.",
        ".kKKKwwwwKKKKKKKKKKwwwwKKKk.",
        ".kKKKwwwwKKKKKKKKKKwwwwKKKk.",
        ".kKKKKwwKKKKKKKKKKKKwwKKKKk.",
        ".kKKKKKKKKKKKKKKKKKKKKKKKKk.",
        ".kKKKKKKKKKKKKKKKKKKKKKKKKk.",
        ".kKKqqKKKKKKKKKKKKKKKKqqKKk.",
        ".kKKqqKKKKKkkkkkkkKKKKqqKKk.",
        "..kKKKKKKKKKKKKKKKKKKKKKKk..",
        "...kKKKKKKKKKKKKKKKKKKKKk...",
        "....kkkkkkkkkkkkkkkkkkkk....",
        "............................",
    ]

    static let notchyWave: [String] = [
        "............................",
        "...........mm...............",
        "...........mm...............",
        "....kkkkkkkkkkkkkkkkkkkk....",
        "...kKKKKKKKKKmmKKKKKKKKKk...",
        "..kKKKKKKKKKKKKKKKKKKKKKKk..",
        ".kKKKKKKKKKKKKKKKKKKKKKKKKk.",
        ".kKKKKwwKKKKKKKKKKKKwwKKKKk.",
        ".kKKKwwwwKKKKKKKKKKwwwwKKKk.",
        ".kKKKwwwwKKKKKKKKKKwwwwKKKk.",
        ".kKKKKwwKKKKKKKKKKKKwwKKKKk.",
        ".kKKKKKKKKKKKKKKKKKKKKKKKKk.",
        ".kKKqqKKKKKKKKKKKKKKKKqqKKk.",
        ".kKKqqKKKKKkkkkkkKKKKKqqKKk.",
        "..kKKKKKKKKKKKKKKKKKKKKKKk..",
        "...kKKKKKKKKKKKKKKKKKKKKk...",
        "....kkkkkkkkkkkkkkkkkkkk....",
        "............................",
    ]

    static let notchyAlert: [String] = [
        "............................",
        ".............yy.............",
        ".............yy.............",
        ".............yy.............",
        "....kkkkkkkkkkkkkkkkkkkk....",
        "...kKKKKKKKKKKKKKKKKKKKKk...",
        "..kKKKKKKKKKKKKKKKKKKKKKKk..",
        ".kKKKKKKKKKKKKKKKKKKKKKKKKk.",
        ".kKKKwwwKKKKKKKKKKKKwwwKKKk.",
        ".kKKKwwwKKKKKKKKKKKKwwwKKKk.",
        ".kKKKwwwKKKKKKKKKKKKwwwKKKk.",
        ".kKKKKKKKKKKKKKKKKKKKKKKKKk.",
        ".kKKqqKKKKKKKkkkKKKKKKqqKKk.",
        ".kKKqqKKKKKKKKKKKKKKKKqqKKk.",
        "..kKKKKKKKKKKKKKKKKKKKKKKk..",
        "...kKKKKKKKKKKKKKKKKKKKKk...",
        "....kkkkkkkkkkkkkkkkkkkk....",
        "............................",
    ]

    // ── Starters: Codesprite line ──
    static let codesprite: [String] = [
        "................",
        "......kkkk......",
        ".....kmmmmk.....",
        "....kmLLmmmk....",
        "...kmLLmmmmmk...",
        "..kmmmmmmmmmmk..",
        "..kmmwwmmwwmmk..",
        "..kmmwwmmwwmmk..",
        "..kmmmmmmmmmmk..",
        "..kmmmmmmmmmmk..",
        "...kmmmmmmmmk...",
        "....kmmmmmmk....",
        ".....kkmmkk.....",
        ".......kk.......",
        "................",
        "................",
    ]

    static let codecrawler: [String] = [
        "................",
        "...kkkk.........",
        "..kmmmmk.kkkk...",
        ".kmLLmmmkmmmmk..",
        ".kmwwmmmmmmwmk..",
        ".kmmmmmmmmmmmk..",
        ".kmgggmmmgggmk..",
        ".kmmmmmmmmmmmk..",
        "..kmmmmmmmmmmk..",
        "..kkmkkmmkkmkk..",
        "...kmk.kk.kmk...",
        "...kmk....kmk...",
        "....k.....k.....",
        ".....mmmmmmmm...",
        "......mmmmm.....",
        "................",
    ]

    static let codetitan: [String] = [
        "................",
        ".....kkkk.......",
        "....kmmmmk......",
        "...kmLLmmmk.....",
        "...kmwwmwwk.....",
        "...kmmmmmmk.....",
        "..kmgmmmmgmk....",
        ".kmmgmmmmgmmk...",
        ".kmmmmymmmmmk...",
        ".kmmmmymmmmmk...",
        "kmmgmgmgmgmmmk..",
        "kmmgmgmgmgmmmk..",
        "kmmgmgmgmgmmmk..",
        ".kmmmgmgmmmmk...",
        "..kkkkkkkkkkk...",
        "................",
    ]

    // ── Starters: Inkling line ──
    static let inkling: [String] = [
        "................",
        ".......mm.......",
        "......mmmm......",
        ".....kggggk.....",
        "....kghhhhgk....",
        "...kghhwwhhgk...",
        "...kghwwhhwgk...",
        "...kghhhhhhgk...",
        "....kgggggGk....",
        "...kg.g.g.g.k...",
        "..kg.kg.kgk.gk..",
        ".kpkkpkkpkkpkk..",
        ".p..p..p..p..p..",
        "................",
        "................",
        "................",
    ]

    static let inkwarden: [String] = [
        "................",
        "......mmmm......",
        ".....mppppm.....",
        "....kggggggk....",
        "...kghhwwhhgk...",
        "...kghwwhhwgk...",
        "...kgggyyggk....",
        "...kgggggggk....",
        "..kgGGGGGGGgk...",
        "..kgGppppGgk....",
        "..kgGpyyppGgk...",
        "..kgGpyyppGgk...",
        "..kgGppppGgk....",
        "..kgGGGGGGGgk...",
        "...kkkkkkkkk....",
        "................",
    ]

    static let inkdragoon: [String] = [
        "................",
        "....kkkk........",
        "...kggggk.kkkk..",
        "..kghhwhgkgggk..",
        "..kghwwhhggwgk..",
        "..kggyymgggggk..",
        "..kggggmgggggk..",
        ".kggmmmmmmgggk..",
        ".kgmmmmmmmmgggk.",
        ".kgggggggggggk..",
        "..kkkkkkkkkkkk..",
        "....pp..pp..pp..",
        "...ppp..ppp.pp..",
        "................",
        "................",
        "................",
    ]

    // ── Starters: Pixibrush line ──
    static let pixibrush: [String] = [
        "................",
        "......mmmm......",
        ".....kmmmmk.....",
        "...kkkqqqqkkk...",
        "..kpkkqqqqkkpk..",
        "..kpgmkqqkmgpk..",
        "..kpbymqqmybpk..",
        "..kpgmykkymgpk..",
        "..kpkkqqqqkkpk..",
        "...kkkqqqqkkk...",
        "....kqwwwwqk....",
        "....kqqqqqqk....",
        "....kqqyyqqk....",
        ".....kkqqkk.....",
        ".......y........",
        "................",
    ]

    static let brushwing: [String] = [
        "................",
        "..mm........mm..",
        ".pmgm......mgmp.",
        ".pgmgb....bgmgp.",
        ".pmgmbk..kbmgmp.",
        ".pgmgbymybgmgp..",
        "..pmgmkqkmgmp...",
        "...kkqqwqqkk....",
        "...kqyqqqyqk....",
        "....kkqqqkk.....",
        ".....kqqqk......",
        "......kkk.......",
        "................",
        "................",
        "................",
        "................",
    ]

    static let maestrix: [String] = [
        "................",
        ".....kqqqk......",
        "....kqwwwqk.....",
        "....kqmmmqk.....",
        "..mm.kgpgk.mm...",
        ".mgm.kggk.mgm...",
        ".pbm..kk..mbp...",
        ".pyb.kggk.byp...",
        "..ppbgggggbpp...",
        "...ppgygypp.....",
        "....pgmmmgp.....",
        "....pggpggp.....",
        ".....pgpgp......",
        ".....kkkkk......",
        "................",
        "................",
    ]

    // ── Pokéballs ──
    static let focusBall: [String] = [
        "................",
        "....kkkkkkkk....",
        "...kmmmmmmmmk...",
        "..kmmLLmmmmmmk..",
        "..kmLLmmmmmmmk..",
        ".kmmmmmmmmmmmmk.",
        ".kmmmmmmmmmmmmk.",
        ".kkkkkkkkkkkkkk.",
        ".kkkkkkkkkkkkkk.",
        ".kwwwwwkkwwwwwk.",
        ".kwwwwkccwwwwwk.",
        "..kwwkccccwwwk..",
        "..kwwwkccwwwwk..",
        "...kwwwwwwwwk...",
        "....kkkkkkkk....",
        "................",
    ]

    static let greatBall: [String] = [
        "................",
        "....kkkkkkkk....",
        "...kbbbbbgggk...",
        "..kbblllbggggk..",
        "..kblllbbgggGk..",
        ".kbbbbbbggggggk.",
        ".kbbbbbbbgggggk.",
        ".kkkkkkkkkkkkkk.",
        ".kkkkkkkkkkkkkk.",
        ".kwwwwwkkwwwwwk.",
        ".kwwwwkmmwwwwwk.",
        "..kwwkmmmmwwwk..",
        "..kwwwkmmwwwwk..",
        "...kwwwwwwwwk...",
        "....kkkkkkkk....",
        "................",
    ]

    static let ultraBall: [String] = [
        "................",
        "....kkkkkkkk....",
        "...kKKKKKKKKk...",
        "..kKKKwwKKKKKk..",
        "..kKwwwwKKKKKk..",
        ".kKKKKKKKKKKKKk.",
        ".kKKKKKKKKKKKKk.",
        ".kkkkkkkkkkkkkk.",
        ".kyyyyykkyyyyyk.",
        ".kyyyykggyyyyyk.",
        "..kyykggggyyyk..",
        "..kyyykggyyyyk..",
        "..kyyyyyyyyyyk..",
        "...kyyyyyyyyk...",
        "....kkkkkkkk....",
        "................",
    ]

    static let masterBall: [String] = [
        "................",
        "....kkkkkkkk....",
        "...kggmmbbggk...",
        "..kgmmbbggmmpk..",
        "..kgmbbggmmppk..",
        ".kgmbbggmmppyyk.",
        ".kmbbggmmppyypk.",
        ".kkkkkkkkkkkkkk.",
        ".kbbggmmppyybbk.",
        ".kbggmmppyybmgk.",
        "..kggmmppyybmk..",
        "..kgmmppyybmgk..",
        "..kmmppyybmgmk..",
        "...kppyybmgmk...",
        "....kkkkkkkk....",
        "................",
    ]

    // ── Streak flames (4 tiers) ──
    static let flame1: [String] = [
        "........",
        "...y....",
        "..ymy...",
        "..yyy...",
        "...y....",
        "........",
    ]
    static let flame7: [String] = [
        "........",
        "...y....",
        "..yyy...",
        "..ypy...",
        "..yyy...",
        "...y....",
        "........",
    ]
    static let flame30: [String] = [
        "........",
        "...y....",
        "..yyy...",
        ".yyypy..",
        ".ypgpy..",
        ".yppy...",
        "..yyy...",
        "........",
    ]
    static let flame365: [String] = [
        "..y..y..",
        ".yyyyy..",
        ".ypppy..",
        ".ypgpy..",
        "yppgppy.",
        "ypgmgpy.",
        ".ypppy..",
        ".yyyyy..",
    ]

    /// Sprite for a given creature dex id. For ids > 9, cycles through the
    /// 9 hand-drawn body shapes so every creature gets a distinct silhouette.
    static func forCreature(id: Int) -> [String] {
        let shapes = [
            codesprite, codecrawler, codetitan,
            inkling, inkwarden, inkdragoon,
            pixibrush, brushwing, maestrix,
        ]
        if id >= 1 && id <= 9 { return shapes[id - 1] }
        return shapes[abs(id) % 9]
    }

    /// Color triplet (light/main/dark) for a creature type — used to recolor
    /// the standard palette when rendering non-starter creatures.
    private static func tripletFor(type: CreatureType) -> (light: Color, main: Color, dark: Color) {
        switch type {
        case .code:     return (Color(hex: "9af2ce"), Color(hex: "2EE6A0"), Color(hex: "1aa370"))
        case .art:      return (Color(hex: "ffb3b3"), Color(hex: "FF6B6B"), Color(hex: "a83a3a"))
        case .doc:      return (Color(hex: "a8d4ff"), Color(hex: "47A0FF"), Color(hex: "2a64a8"))
        case .sound:    return (Color(hex: "e4a6ff"), Color(hex: "C147FF"), Color(hex: "7a2da8"))
        case .sun:      return (Color(hex: "fff0b3"), Color(hex: "FFD960"), Color(hex: "a88f33"))
        case .moon:     return (Color(hex: "8a5fb0"), Color(hex: "5a1a8a"), Color(hex: "2a0a4a"))
        case .dream:    return (Color(hex: "d4eaff"), Color(hex: "8ec0f0"), Color(hex: "4a7aa0"))
        case .spark:    return (Color(hex: "fff0b3"), Color(hex: "FFD960"), Color(hex: "c68b00"))
        case .zen:      return (Color(hex: "b5f0d0"), Color(hex: "5fc090"), Color(hex: "1aa370"))
        case .caffeine: return (Color(hex: "d4a878"), Color(hex: "8b5a2b"), Color(hex: "4a2f15"))
        case .storm:    return (Color(hex: "a0c8e0"), Color(hex: "47A0FF"), Color(hex: "1a3a6a"))
        case .glitch:   return (Color(hex: "ff80ff"), Color(hex: "C147FF"), Color(hex: "5a1a8a"))
        case .spirit:   return (Color(hex: "f0d0ff"), Color(hex: "C147FF"), Color(hex: "5a2080"))
        case .pixel:    return (Color(hex: "fff0b3"), Color(hex: "FFD960"), Color(hex: "806a30"))
        case .time:     return (Color(hex: "ffb0a0"), Color(hex: "FF6B6B"), Color(hex: "a02020"))
        }
    }

    /// Returns a palette tuned to the creature's primary + secondary types.
    /// Starters (#1–#9) keep the standard hand-drawn palette unchanged.
    static func paletteFor(creature: Creature) -> [Character: Color] {
        if creature.id <= 9 { return PixelPalette.standard }
        var p = PixelPalette.standard
        let primary = tripletFor(type: creature.primary)
        let secondary = creature.secondary.map { tripletFor(type: $0) } ?? primary
        // Body fill — primary type colors
        p["m"] = primary.main
        p["M"] = primary.dark
        p["L"] = primary.light
        // Accent — secondary type colors
        p["g"] = secondary.main
        p["G"] = secondary.dark
        p["h"] = secondary.light
        return p
    }
}
