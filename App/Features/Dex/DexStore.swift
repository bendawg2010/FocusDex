import Foundation
import Combine

@MainActor
final class DexStore: ObservableObject {
    @Published private(set) var caught: [Creature]

    init() {
        self.caught = Persistence.loadCodable([Creature].self, key: Persistence.Keys.caughtCreatures) ?? []
    }

    func catchCreature(_ creature: Creature) {
        guard !caught.contains(where: { $0.id == creature.id }) else { return }
        caught.append(creature)
        save()
    }

    func reset() {
        caught.removeAll()
        save()
    }

    private func save() {
        Persistence.saveCodable(caught, key: Persistence.Keys.caughtCreatures)
    }

    var completionRatio: Double { Double(caught.count) / 147.0 }
}
