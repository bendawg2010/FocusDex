import Foundation

extension Creature {
    /// Notchyverse Crossover (#130–#137) — Boulder/SkyJournal/Campfire/etc. tie-ins.
    static let crossover: [Creature] = [
        Creature(
            id: 130,
            name: "Pebblekin",
            primary: .spirit,
            secondary: .zen,
            rarity: .uncommon,
            hp: 70,
            fp: 55,
            sta: 80,
            spd: 25,
            signatureMove: "Steady Weight",
            blurb: "Shy cousin of BOULDER pet rocks. Sits by your trackpad, syncs its inner heart-glow to your breath, and forgives faster than you do."
        ),
        Creature(
            id: 131,
            name: "Boulderkin",
            primary: .spirit,
            secondary: .zen,
            rarity: .rare,
            hp: 110,
            fp: 80,
            sta: 120,
            spd: 30,
            signatureMove: "Pet Rock Promise",
            blurb: "A Pebblekin promoted by months of small kindnesses. Parks itself in front of distracting tabs and refuses, very politely, to budge."
        ),
        Creature(
            id: 132,
            name: "Cloudlet",
            primary: .dream,
            secondary: .doc,
            rarity: .common,
            hp: 45,
            fp: 70,
            sta: 50,
            spd: 85,
            signatureMove: "Soft Filing",
            blurb: "A single SkyJournal thought that didn't make it to a paragraph. Hovers above your writing app, holding unfinished sentences for tomorrow."
        ),
        Creature(
            id: 133,
            name: "Cirrusari",
            primary: .dream,
            secondary: .spirit,
            rarity: .legendary,
            hp: 95,
            fp: 130,
            sta: 90,
            spd: 125,
            signatureMove: "Hundred-Day Drift",
            blurb: "Keeper of every cloud you have ever journaled. Curls around your monitor like a scarf and softens an hour into fifteen minutes."
        ),
        Creature(
            id: 134,
            name: "Emberlet",
            primary: .sun,
            secondary: .caffeine,
            rarity: .uncommon,
            hp: 55,
            fp: 75,
            sta: 60,
            spd: 90,
            signatureMove: "Share The Spark",
            blurb: "A spark broken off the communal CAMPFIRE when a friend sits beside you. Dims when alone, bounces along your dock with company."
        ),
        Creature(
            id: 135,
            name: "Partyflame",
            primary: .sun,
            secondary: .spark,
            rarity: .rare,
            hp: 95,
            fp: 115,
            sta: 105,
            spd: 110,
            signatureMove: "Circle Up",
            blurb: "Unofficial mascot of every group chat that actually shows up. Rolls a d20 and, on a 20, sprays harmless pixel-confetti across your screen."
        ),
        Creature(
            id: 136,
            name: "NotchPop-Echo",
            primary: .pixel,
            secondary: .spirit,
            rarity: .rare,
            hp: 60,
            fp: 95,
            sta: 70,
            spd: 135,
            signatureMove: "Pop The Notch",
            blurb: "Ghost of the old NotchPop menubar toy. Lives in Notchy's rafters, runs silly break-time animations, and never works during work."
        ),
        Creature(
            id: 137,
            name: "Wallsprite",
            primary: .art,
            secondary: .pixel,
            rarity: .uncommon,
            hp: 65,
            fp: 80,
            sta: 75,
            spd: 95,
            signatureMove: "Wallpaper Swap",
            blurb: "Descendant of the WALLPOP utility. Strolls the bottom of your wallpaper at break time, dabbing invisible touch-ups onto the gallery."
        ),
    ]
}
