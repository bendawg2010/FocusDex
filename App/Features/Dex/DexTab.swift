import SwiftUI

struct DexTab: View {
    @EnvironmentObject var dex: DexStore

    private let columns = [GridItem(.adaptive(minimum: 88), spacing: 12)]

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Pokédex")
                    .font(.system(.title3, design: .rounded).weight(.black))
                Spacer()
                Text("\(dex.caught.count) / 147")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)

            ProgressView(value: dex.completionRatio)
                .padding(.horizontal, 16)

            if dex.caught.isEmpty {
                Spacer()
                VStack(spacing: 8) {
                    Text("🥚").font(.system(size: 48))
                    Text("Nothing caught yet.")
                        .font(.headline)
                    Text("Focus to earn balls, then catch on your break.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                Spacer()
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(dex.caught) { creature in
                            CreatureTile(creature: creature)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }
}

private struct CreatureTile: View {
    let creature: Creature

    var body: some View {
        VStack(spacing: 4) {
            Text("⌬").font(.system(size: 30))
            Text(creature.dexNumber)
                .font(.caption2.monospacedDigit())
                .foregroundStyle(.secondary)
            Text(creature.name)
                .font(.caption.weight(.semibold))
                .lineLimit(1)
        }
        .frame(width: 80, height: 88)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10))
    }
}
