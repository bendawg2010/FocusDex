import Foundation
import Combine

@MainActor
final class DexStore: ObservableObject {
    @Published private(set) var caught: [Creature] = []

    func catchCreature(_ creature: Creature) {
        guard !caught.contains(where: { $0.id == creature.id }) else { return }
        caught.append(creature)
    }

    var completionRatio: Double {
        Double(caught.count) / 147.0
    }
}
