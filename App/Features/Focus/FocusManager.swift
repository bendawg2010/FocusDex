import Foundation
import Combine

@MainActor
final class FocusManager: ObservableObject {
    // ── Session state ──
    @Published private(set) var phase: Phase = .idle
    @Published private(set) var elapsed: TimeInterval = 0
    @Published private(set) var timeRemaining: TimeInterval = 0

    // Most-recent finished session, used in celebration screen
    @Published private(set) var lastSessionDuration: TimeInterval = 0
    @Published private(set) var lastSessionGreatEarned = 0
    @Published private(set) var lastSessionUltraEarned = 0
    @Published private(set) var lastSessionMasterEarned = 0

    // ── Stockpile (persisted) ──
    @Published private(set) var pokeballs: Int { didSet { Persistence.set(pokeballs, forKey: Persistence.Keys.pokeballs) } }
    @Published private(set) var greatBalls: Int { didSet { Persistence.set(greatBalls, forKey: Persistence.Keys.greatBalls) } }
    @Published private(set) var ultraBalls: Int { didSet { Persistence.set(ultraBalls, forKey: Persistence.Keys.ultraBalls) } }
    @Published private(set) var masterBalls: Int { didSet { Persistence.set(masterBalls, forKey: Persistence.Keys.masterBalls) } }

    @Published private(set) var pendingSpawns: [Creature] = []

    // ── Setup (persisted) ──
    @Published var plannedDuration: TimeInterval { didSet { Persistence.set(plannedDuration, forKey: Persistence.Keys.plannedDuration) } }

    // ── Streak / stats (persisted) ──
    @Published private(set) var currentStreak: Int { didSet { Persistence.set(currentStreak, forKey: Persistence.Keys.currentStreak) } }
    @Published private(set) var bestStreak: Int { didSet { Persistence.set(bestStreak, forKey: Persistence.Keys.bestStreak) } }
    @Published private(set) var totalSessions: Int { didSet { Persistence.set(totalSessions, forKey: Persistence.Keys.totalSessions) } }
    @Published private(set) var totalFocusMin: Double { didSet { Persistence.set(totalFocusMin, forKey: Persistence.Keys.totalFocusMin) } }

    enum Phase: String { case idle, focusing, celebration, safari }

    static let durationPresets: [TimeInterval] = [25 * 60, 45 * 60, 90 * 60]

    private var timer: Timer?
    private var lastBallTick: TimeInterval = 0

    init() {
        self.pokeballs = Persistence.int(Persistence.Keys.pokeballs)
        self.greatBalls = Persistence.int(Persistence.Keys.greatBalls)
        self.ultraBalls = Persistence.int(Persistence.Keys.ultraBalls)
        self.masterBalls = Persistence.int(Persistence.Keys.masterBalls)
        self.plannedDuration = Persistence.double(Persistence.Keys.plannedDuration, default: 25 * 60)
        self.currentStreak = Persistence.int(Persistence.Keys.currentStreak)
        self.bestStreak = Persistence.int(Persistence.Keys.bestStreak)
        self.totalSessions = Persistence.int(Persistence.Keys.totalSessions)
        self.totalFocusMin = Persistence.double(Persistence.Keys.totalFocusMin)
    }

    // MARK: - Lifecycle

    func start() {
        guard phase == .idle else { return }
        phase = .focusing
        elapsed = 0
        timeRemaining = plannedDuration
        lastBallTick = 0
        SoundFX.play(.start)
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.tick() }
        }
    }

    func stopEarly() {
        timer?.invalidate(); timer = nil
        phase = .idle
        elapsed = 0
        timeRemaining = 0
    }

    func enterSafari() {
        guard phase == .focusing || phase == .idle || phase == .celebration else { return }
        let n = max(2, min(5, Int(elapsed / 60 / 10) + 2))
        pendingSpawns = (0..<n).compactMap { _ in Creature.starters.randomElement() }
        phase = .safari
    }

    func dismissSafari() {
        pendingSpawns.removeAll()
        elapsed = 0
        timeRemaining = 0
        phase = .idle
    }

    private func tick() {
        elapsed += 1
        timeRemaining = max(0, plannedDuration - elapsed)

        if elapsed - lastBallTick >= 300 {
            pokeballs += 1
            lastBallTick = elapsed
            SoundFX.play(.ball)
            Haptics.tick()
        }

        if timeRemaining <= 0 {
            finishSession()
        }
    }

    private func finishSession() {
        let duration = elapsed
        timer?.invalidate(); timer = nil

        var earnedGreat = 0, earnedUltra = 0, earnedMaster = 0
        if duration >= 25 * 60 { greatBalls += 1; earnedGreat = 1 }
        if duration >= 90 * 60 { ultraBalls += 1; earnedUltra = 1 }
        if duration >= 8 * 3600 { masterBalls += 1; earnedMaster = 1 }

        lastSessionDuration = duration
        lastSessionGreatEarned = earnedGreat
        lastSessionUltraEarned = earnedUltra
        lastSessionMasterEarned = earnedMaster

        totalSessions += 1
        totalFocusMin += duration / 60
        bumpStreak()
        SoundFX.play(.sessionEnd)
        Haptics.levelUp()

        phase = .celebration
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            if phase == .celebration { enterSafari() }
        }
    }

    private func bumpStreak() {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        let lastTS = Persistence.double(Persistence.Keys.lastSessionDate)
        let last = lastTS > 0 ? cal.startOfDay(for: Date(timeIntervalSince1970: lastTS)) : nil

        if let last {
            let days = cal.dateComponents([.day], from: last, to: today).day ?? 0
            if days == 0 {
                // already counted today
            } else if days == 1 {
                currentStreak += 1
            } else {
                currentStreak = 1
            }
        } else {
            currentStreak = 1
        }

        if currentStreak > bestStreak { bestStreak = currentStreak }
        Persistence.set(today.timeIntervalSince1970, forKey: Persistence.Keys.lastSessionDate)
    }

    // MARK: - Catch attempt

    func attemptCatch(_ creature: Creature, with tier: BallTier) -> Bool {
        switch tier {
        case .pokeball:   guard pokeballs > 0 else { return false }; pokeballs -= 1
        case .great:      guard greatBalls > 0 else { return false }; greatBalls -= 1
        case .ultra:      guard ultraBalls > 0 else { return false }; ultraBalls -= 1
        case .master:     guard masterBalls > 0 else { return false }; masterBalls -= 1
        }

        if tier == .master {
            SoundFX.play(.catchOK)
            return true
        }
        let base: Double = {
            switch creature.rarity {
            case .common:    return 0.85
            case .uncommon:  return 0.65
            case .rare:      return 0.45
            case .legendary: return 0.18
            case .mythic:    return 0.10
            }
        }()
        let bonus: Double = {
            switch tier {
            case .pokeball: return 0.0
            case .great:    return 0.10
            case .ultra:    return 0.22
            case .master:   return 1.0
            }
        }()
        let success = Double.random(in: 0...1) < min(0.98, base + bonus)
        SoundFX.play(success ? .catchOK : .catchNo)
        if success { Haptics.levelUp() } else { Haptics.tick() }
        return success
    }

    enum BallTier { case pokeball, great, ultra, master }

    // MARK: - Helpers

    var formattedRemaining: String {
        let t = Int(timeRemaining.rounded())
        return String(format: "%02d:%02d", t / 60, t % 60)
    }

    var totalBalls: Int { pokeballs + greatBalls + ultraBalls + masterBalls }
}
