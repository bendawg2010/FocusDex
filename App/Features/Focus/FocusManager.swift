import Foundation
import Combine

@MainActor
final class FocusManager: ObservableObject {
    @Published private(set) var isFocusing: Bool = false
    @Published private(set) var elapsed: TimeInterval = 0
    @Published private(set) var pokeballs: Int = 0
    @Published private(set) var greatBalls: Int = 0
    @Published private(set) var ultraBalls: Int = 0
    @Published private(set) var masterBalls: Int = 0

    private var timer: Timer?
    private var sessionStart: Date?
    private var lastBallTick: TimeInterval = 0

    func start() {
        guard !isFocusing else { return }
        isFocusing = true
        sessionStart = Date()
        elapsed = 0
        lastBallTick = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.tick() }
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        let finishedSession = elapsed
        isFocusing = false
        elapsed = 0
        sessionStart = nil
        awardSessionBonuses(forDuration: finishedSession)
    }

    private func tick() {
        elapsed += 1
        // every 5 minutes of focus → 1 Pokeball
        if elapsed - lastBallTick >= 300 {
            pokeballs += 1
            lastBallTick = elapsed
        }
    }

    private func awardSessionBonuses(forDuration duration: TimeInterval) {
        if duration >= 1500 { greatBalls += 1 }   // 25 min
        if duration >= 5400 { ultraBalls += 1 }   // 90 min
        if duration >= 28800 { masterBalls += 1 } // 8 h
    }

    var formattedElapsed: String {
        let m = Int(elapsed) / 60
        let s = Int(elapsed) % 60
        return String(format: "%02d:%02d", m, s)
    }
}
