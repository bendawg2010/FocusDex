import Foundation

extension Creature {
    /// Every creature in the FocusDex universe — combines all family files.
    /// Use this for spawn pools, the global dex grid, search, etc.
    static let all: [Creature] = {
        startersAll
            + timeOfDay
            + appContext
            + weather
            + legendaries
            + foodBeverage
            + meetings
            + brainRot
            + sleepDream
            + seasonal
            + mythicals
            + crossover
            + regional
    }()

    /// Look up by dex number; nil if missing.
    static func byId(_ id: Int) -> Creature? {
        all.first { $0.id == id }
    }

    /// Filter by primary or secondary type.
    static func ofType(_ type: CreatureType) -> [Creature] {
        all.filter { $0.primary == type || $0.secondary == type }
    }

    /// Group by family file (matches the design's batch files).
    static let byFamily: [(name: String, dexRange: ClosedRange<Int>, creatures: [Creature])] = [
        ("Starters",         1...9,    startersAll),
        ("Time of Day",      10...24,  timeOfDay),
        ("App Context",      25...44,  appContext),
        ("Weather",          45...59,  weather),
        ("Legendaries",      60...71,  legendaries),
        ("Food & Beverage",  72...81,  foodBeverage),
        ("Meetings",         82...91,  meetings),
        ("Brain Rot",        92...99,  brainRot),
        ("Sleep & Dream",    100...109, sleepDream),
        ("Seasonal",         110...121, seasonal),
        ("Mythicals",        122...129, mythicals),
        ("Crossover",        130...137, crossover),
        ("Regional",         138...147, regional),
    ]
}
