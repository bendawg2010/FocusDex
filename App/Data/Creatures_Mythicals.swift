import Foundation

extension Creature {
    /// Mythicals (#122–#129) — story-unlock + ARG endgame.
    static let mythicals: [Creature] = [
        Creature(
            id: 122,
            name: "Zenwalker",
            primary: .spirit,
            secondary: .zen,
            rarity: .mythic,
            hp: 130,
            fp: 145,
            sta: 160,
            spd: 80,
            signatureMove: "Hundredth Hour",
            blurb: "A tall meditative spirit that walks across the desktop only after 100 cumulative hours of true deep work, visible for a single 45-second pass."
        ),
        Creature(
            id: 123,
            name: "Notchari",
            primary: .spirit,
            secondary: .moon,
            rarity: .mythic,
            hp: 120,
            fp: 155,
            sta: 130,
            spd: 145,
            signatureMove: "Three-Sixty-Five",
            blurb: "Notchy's shadow twin, appearing only on the 366th consecutive day to those who never missed a session — the silent archive of the Professor."
        ),
        Creature(
            id: 124,
            name: "Paradox-mon",
            primary: .spirit,
            secondary: .glitch,
            rarity: .mythic,
            hp: 125,
            fp: 135,
            sta: 125,
            spd: 130,
            signatureMove: "Both/And",
            blurb: "Born from the union of a trainer's most productive and least productive days, two half-bodies stitched along a glitching seam, sprinter and napper."
        ),
        Creature(
            id: 125,
            name: "Procrasti-King-Reignited",
            primary: .spirit,
            secondary: .glitch,
            rarity: .mythic,
            hp: 200,
            fp: 175,
            sta: 155,
            spd: 90,
            signatureMove: "Reignite the Scroll",
            blurb: "The fallen Syndicate king, returned 30 days after Championship — stylishly menacing, secretly lonely, secretly proud you came back to fight again."
        ),
        Creature(
            id: 126,
            name: "Urlith",
            primary: .spirit,
            secondary: .pixel,
            rarity: .mythic,
            hp: 110,
            fp: 165,
            sta: 175,
            spd: 70,
            signatureMove: "Cursor Zero",
            blurb: "An ancient CRT-pixel spirit that materializes only when inbox, tabs, notifications, and messages all simultaneously hit zero across every device."
        ),
        Creature(
            id: 127,
            name: "Whim",
            primary: .spirit,
            secondary: .spark,
            rarity: .mythic,
            hp: 100,
            fp: 150,
            sta: 100,
            spd: 250,
            signatureMove: "One-Second-Year",
            blurb: "A shimmering thumbnail of dumb luck that appears for one random second somewhere on screen, once in a year — the fastest creature in the dex."
        ),
        Creature(
            id: 128,
            name: "Cipher",
            primary: .spirit,
            secondary: .code,
            rarity: .mythic,
            hp: 130,
            fp: 160,
            sta: 150,
            spd: 110,
            signatureMove: "Consensus",
            blurb: "The soul of cooperation, a ribbon-spirit of cascading glyphs that spawns globally the instant 10,000 trainers solve the yearly community ARG together."
        ),
        Creature(
            id: 129,
            name: "Notch-Prime",
            primary: .spirit,
            secondary: .time,
            rarity: .mythic,
            hp: 150,
            fp: 180,
            sta: 180,
            spd: 100,
            signatureMove: "Version 0.1",
            blurb: "The original Notchy — a 1987-era pixel spirit hidden behind a multi-app ARG, tipping his bowtie once a year to trainers who paid attention."
        ),
    ]
}
