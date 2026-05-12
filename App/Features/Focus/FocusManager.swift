import Foundation
import Combine

@MainActor
final class FocusManager: ObservableObject {
    // ── Session state ──
    @Published private(set) var phase: Phase = .idle
    @Published private(set) var elapsed: TimeInterval = 0
    @Published private(set) var timeRemaining: TimeInterval = 0

    // ── Stockpile ──
    @Published private(set) var pokeballs: Int = 0
    @Published private(set) var greatBalls: Int = 0
    @Published private(set) var ultraBalls: Int = 0
    @Published private(set) var masterBalls: Int = 0

    // ── Pending spawns from the just-completed session ──
    @Published private(set) var pendingSpawns: [Creature] = []

    // ── Setup ──
    @Published var plannedDuration: TimeInterval = 25 * 60

    enum Phase: String { case idle, focusing, safari }

    static let durationPresets: [TimeInterval] = [25 * 60, 45 * 60, 90 * 60]

    private var timer: Timer?
    private var lastBallTick: TimeInterval = 0

    // MARK: - Lifecycle

    func start() {
        guard phase == .idle else { return }
        phase = .focusing
        elapsed = 0
        timeRemaining = plannedDuration
        lastBallTick = 0
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

    /// Called after a session finishes — opens Safari Mode for catching.
    func enterSafari() {
        guard phase == .focusing || phase == .idle else { return }
        // Roll a few spawns based on session length.
        let n = max(2, min(5, Int(elapsed / 60 / 10) + 2))
        pendingSpawns = (0..<n).compactMap { _ in Creature.starters.randomElement() }
        phase = .safari
    }

    /// Called when the user closes Safari Mode.
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
        }

        if timeRemaining <= 0 {
            awardSessionBonuses(forDuration: elapsed)
            timer?.invalidate(); timer = nil
            enterSafari()
        }
    }

    private func awardSessionBonuses(forDuration duration: TimeInterval) {
        if duration >= 25 * 60 { greatBalls += 1 }
        if duration >= 90 * 60 { ultraBalls += 1 }
        if duration >= 8 * 3600 { masterBalls += 1 }
    }

    // MARK: - Catch attempt

    /// Spend one Pokeball-tier ball. Returns true if caught.
    func attemptCatch(_ creature: Creature, with tier: BallTier) -> Bool {
        switch tier {
        case .pokeball:   guard pokeballs > 0 else { return false }; pokeballs -= 1
        case .great:      guard greatBalls > 0 else { return false }; greatBalls -= 1
        case .ultra:      guard ultraBalls > 0 else { return false }; ultraBalls -= 1
        case .master:     guard masterBalls > 0 else { return false }; masterBalls -= 1
        }

        if tier == .master { return true } // master always catches
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
        return Double.random(in: 0...1) < min(0.98, base + bonus)
    }

    enum BallTier { case pokeball, great, ultra, master }

    // MARK: - Helpers

    var formattedRemaining: String {
        let t = Int(timeRemaining.rounded())
        return String(format: "%02d:%02d", t / 60, t % 60)
    }

    var totalBalls: Int { pokeballs + greatBalls + ultraBalls + masterBalls }
}
