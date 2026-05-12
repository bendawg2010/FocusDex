import Foundation

enum Persistence {
    private static let store = UserDefaults.standard

    static func saveCodable<T: Encodable>(_ value: T, key: String) {
        if let data = try? JSONEncoder().encode(value) {
            store.set(data, forKey: key)
        }
    }

    static func loadCodable<T: Decodable>(_ type: T.Type, key: String) -> T? {
        guard let data = store.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }

    static func int(_ key: String, default fallback: Int = 0) -> Int {
        if store.object(forKey: key) == nil { return fallback }
        return store.integer(forKey: key)
    }

    static func double(_ key: String, default fallback: Double = 0) -> Double {
        if store.object(forKey: key) == nil { return fallback }
        return store.double(forKey: key)
    }

    static func bool(_ key: String, default fallback: Bool = false) -> Bool {
        if store.object(forKey: key) == nil { return fallback }
        return store.bool(forKey: key)
    }

    static func set(_ value: Any?, forKey key: String) {
        store.set(value, forKey: key)
    }

    static func wipe() {
        for key in Keys.all {
            store.removeObject(forKey: key)
        }
    }

    enum Keys {
        static let pokeballs        = "fd.pokeballs"
        static let greatBalls       = "fd.greatBalls"
        static let ultraBalls       = "fd.ultraBalls"
        static let masterBalls      = "fd.masterBalls"
        static let caughtCreatures  = "fd.caughtCreatures"
        static let plannedDuration  = "fd.plannedDuration"
        static let hasChosenStarter = "fd.hasChosenStarter"
        static let starterId        = "fd.starterId"
        static let totalSessions    = "fd.totalSessions"
        static let totalFocusMin    = "fd.totalFocusMin"
        static let lastSessionDate  = "fd.lastSessionDate"
        static let currentStreak    = "fd.currentStreak"
        static let bestStreak       = "fd.bestStreak"
        static let soundEnabled     = "fd.soundEnabled"

        static let all = [
            pokeballs, greatBalls, ultraBalls, masterBalls,
            caughtCreatures, plannedDuration, hasChosenStarter, starterId,
            totalSessions, totalFocusMin, lastSessionDate,
            currentStreak, bestStreak, soundEnabled
        ]
    }
}
