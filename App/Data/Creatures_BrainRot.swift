import Foundation

extension Creature {
    /// Brain Rot family (#092–#099) — Italian-brain-rot animal+tech hybrids.
    static let brainRot: [Creature] = [
        Creature(
            id: 92,
            name: "Scrollyote Phoneraco",
            primary: .glitch,
            secondary: .pixel,
            rarity: .common,
            hp: 42,
            fp: 25,
            sta: 95,
            spd: 38,
            signatureMove: "Just One More",
            blurb: "A hunched raccoon fused to a phone. Tail is a scrolling feed. Runs on whatever it just watched. Will hand you the app you meant to quit."
        ),
        Creature(
            id: 93,
            name: "Tralalalgo Earbudino",
            primary: .glitch,
            secondary: .sound,
            rarity: .uncommon,
            hp: 50,
            fp: 82,
            sta: 60,
            spd: 73,
            signatureMove: "For You",
            blurb: "A floating octopus with earbud tentacles. The politest predator in the dex. Whispers a recommendation tuned exactly to your mood."
        ),
        Creature(
            id: 94,
            name: "Bombardiro Redbullini",
            primary: .glitch,
            secondary: .caffeine,
            rarity: .common,
            hp: 65,
            fp: 38,
            sta: 28,
            spd: 89,
            signatureMove: "Pre-Workout Mindset",
            blurb: "A gorilla wedged inside an energy drink can. Believes in you SO MUCH. Has never finished a task. Larval form of burnout."
        ),
        Creature(
            id: 95,
            name: "Newtabbino Ferretto",
            primary: .glitch,
            secondary: .spirit,
            rarity: .common,
            hp: 35,
            fp: 30,
            sta: 80,
            spd: 65,
            signatureMove: "Cmd+T",
            blurb: "A ferret draped in stacked about:blank window-costumes. Multiplies quietly. Closing one in your browser just relocates it to your dex."
        ),
        Creature(
            id: 96,
            name: "Wikibunno Tunnelini",
            primary: .glitch,
            secondary: .doc,
            rarity: .uncommon,
            hp: 52,
            fp: 58,
            sta: 62,
            spd: 78,
            signatureMove: "Citation Needed",
            blurb: "A rabbit whose lower half is a tunnel of trivia. Politely hops in. You follow. Four hours later you know everything about a Belgian opera."
        ),
        Creature(
            id: 97,
            name: "Tabaway Toastini",
            primary: .glitch,
            secondary: .moon,
            rarity: .common,
            hp: 45,
            fp: 48,
            sta: 55,
            spd: 62,
            signatureMove: "Just A Sec",
            blurb: "A guilty tiptoeing dog carrying a browser window in its mouth like stolen toast. Waits in the gap between focused windows. Never judges."
        ),
        Creature(
            id: 98,
            name: "Decideeoww Owlquintet",
            primary: .glitch,
            secondary: .dream,
            rarity: .rare,
            hp: 75,
            fp: 60,
            sta: 65,
            spd: 25,
            signatureMove: "Option Paralysis",
            blurb: "A drowsy owl wearing a five-phone shell, each screen a different option. Listens to all of them with equal sincerity. Beautifully indecisive."
        ),
        Creature(
            id: 99,
            name: "Streakwailio Candlefawn",
            primary: .glitch,
            secondary: .spirit,
            rarity: .rare,
            hp: 82,
            fp: 62,
            sta: 48,
            spd: 38,
            signatureMove: "Day One Again",
            blurb: "A translucent fawn carrying a broken candle still lit. Arrives only after a long streak breaks. Starts the new streak with you, no comment."
        )
    ]
}
