import Foundation

extension Creature {
    /// Food & Beverage (#072–#081) — lunch-hour spawns.
    static let foodBeverage: [Creature] = [
        Creature(
            id: 72,
            name: "Beanlet",
            primary: .caffeine,
            secondary: .pixel,
            rarity: .common,
            hp: 55,
            fp: 65,
            sta: 60,
            spd: 60,
            signatureMove: "First Sip",
            blurb: "Plump roasted bean with sleepy eyes and a halo of steam. Hums the espresso frequency at the corner of your trackpad."
        ),
        Creature(
            id: 73,
            name: "Espressoul",
            primary: .caffeine,
            secondary: .spirit,
            rarity: .uncommon,
            hp: 70,
            fp: 95,
            sta: 80,
            spd: 95,
            signatureMove: "Crema Crash",
            blurb: "Demitasse spirit at 92 degrees, glowing magenta eyes. Patrols your dock and closes unauthorized video tabs on sight."
        ),
        Creature(
            id: 74,
            name: "Steampuff",
            primary: .caffeine,
            secondary: .zen,
            rarity: .common,
            hp: 60,
            fp: 70,
            sta: 60,
            spd: 50,
            signatureMove: "Quiet Steep",
            blurb: "Mint-tinted curl of tea vapor with crescent eyes. Settles on your least-read tab and hums until you finally close it."
        ),
        Creature(
            id: 75,
            name: "Cheeslice",
            primary: .caffeine,
            secondary: .pixel,
            rarity: .common,
            hp: 70,
            fp: 55,
            sta: 75,
            spd: 40,
            signatureMove: "Cheese Pull",
            blurb: "Jolly triangle slice with pepperoni freckles and an endless cheese drip. Offers a regenerating bite to the user every session."
        ),
        Creature(
            id: 76,
            name: "Noodragon",
            primary: .caffeine,
            secondary: .sound,
            rarity: .common,
            hp: 65,
            fp: 60,
            sta: 70,
            spd: 45,
            signatureMove: "Broth Wave",
            blurb: "Braided ramen serpent with a glowing yolk heart and scallion fin. Coils around the hinge to keep the chassis warm."
        ),
        Creature(
            id: 77,
            name: "Rolltrio",
            primary: .caffeine,
            secondary: .pixel,
            rarity: .common,
            hp: 60,
            fp: 65,
            sta: 75,
            spd: 40,
            signatureMove: "Triple Roll",
            blurb: "Three sushi rolls in a tight committee, one each of salmon, avocado, and tuna. They rotate shifts watching the clock."
        ),
        Creature(
            id: 78,
            name: "Bagelmunch",
            primary: .caffeine,
            secondary: .pixel,
            rarity: .common,
            hp: 75,
            fp: 50,
            sta: 80,
            spd: 35,
            signatureMove: "Sprinkle Shower",
            blurb: "Doughy ring with eyes peering through the hole, scattered in seeds and sprinkles. Rolls over distracting tabs to block them."
        ),
        Creature(
            id: 79,
            name: "Greenbowlmi",
            primary: .zen,
            secondary: .caffeine,
            rarity: .rare,
            hp: 95,
            fp: 90,
            sta: 110,
            spd: 85,
            signatureMove: "Wholesome Aura",
            blurb: "Glowing poke bowl spirit with sun-eyes and a leafy crown. Only appears if you genuinely ate something green that day."
        ),
        Creature(
            id: 80,
            name: "Bobawisp",
            primary: .caffeine,
            secondary: .spirit,
            rarity: .common,
            hp: 55,
            fp: 75,
            sta: 50,
            spd: 60,
            signatureMove: "Pearl Volley",
            blurb: "Translucent milk-tea jellyfish with seven pearls drifting inside. Drops a tapioca plop on the menu bar as a pomodoro signal."
        ),
        Creature(
            id: 81,
            name: "Tiredova",
            primary: .caffeine,
            secondary: .glitch,
            rarity: .common,
            hp: 80,
            fp: 45,
            sta: 70,
            spd: 45,
            signatureMove: "Reheat",
            blurb: "Slumped blob of forgotten leftovers with one weak puff of steam. Sighs on the dock and quietly heals nearby creatures."
        ),
    ]
}
