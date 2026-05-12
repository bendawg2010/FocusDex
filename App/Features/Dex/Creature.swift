import Foundation

enum CreatureType: String, Codable, CaseIterable {
    case code, art, doc, sound, sun, moon, dream, spark, zen, caffeine, storm, glitch, spirit, pixel, time
}

enum Rarity: String, Codable {
    case common, uncommon, rare, legendary, mythic
}

struct Creature: Identifiable, Codable, Hashable {
    let id: Int            // dex number
    let name: String
    let primary: CreatureType
    let secondary: CreatureType?
    let rarity: Rarity
    let hp: Int
    let fp: Int
    let sta: Int
    let spd: Int
    let signatureMove: String
    let blurb: String

    var dexNumber: String { String(format: "#%03d", id) }
    var statTotal: Int { hp + fp + sta + spd }
}

extension Creature {
    static let starters: [Creature] = [
        Creature(
            id: 1, name: "Codesprite",
            primary: .code, secondary: .spirit, rarity: .common,
            hp: 50, fp: 70, sta: 55, spd: 65,
            signatureMove: "Compile Strike",
            blurb: "A mint-glow code spirit whose eyes blink like a cursor."
        ),
        Creature(
            id: 4, name: "Inkling",
            primary: .art, secondary: .doc, rarity: .common,
            hp: 55, fp: 65, sta: 60, spd: 60,
            signatureMove: "Inkslash",
            blurb: "An octopus-quill with a single pearl eye, dripping ink in slow loops."
        ),
        Creature(
            id: 7, name: "Pixibrush",
            primary: .art, secondary: .pixel, rarity: .common,
            hp: 50, fp: 60, sta: 60, spd: 70,
            signatureMove: "Splash Palette",
            blurb: "A paintbrush-fairy with color-swatch wings, leaving fading pigment trails."
        )
    ]
}
