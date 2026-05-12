import AppKit
import Foundation

/// Tiny wrapper over macOS system sounds. Respects user toggle.
enum SoundFX {
    enum Cue {
        case start, ball, catchOK, catchNo, sessionEnd, tap

        var soundName: String {
            switch self {
            case .start:      return "Tink"
            case .ball:       return "Pop"
            case .catchOK:    return "Glass"
            case .catchNo:    return "Bottle"
            case .sessionEnd: return "Hero"
            case .tap:        return "Purr"
            }
        }
    }

    static func play(_ cue: Cue) {
        let enabled = UserDefaults.standard.object(forKey: Persistence.Keys.soundEnabled) as? Bool ?? true
        guard enabled else { return }
        NSSound(named: NSSound.Name(cue.soundName))?.play()
    }
}

/// NSHapticFeedbackManager wrapper for subtle physical feedback on trackpads.
enum Haptics {
    static func tick() {
        NSHapticFeedbackManager.defaultPerformer.perform(.alignment, performanceTime: .now)
    }
    static func levelUp() {
        NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .now)
    }
}
