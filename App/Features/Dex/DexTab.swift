import SwiftUI

struct DexTab: View {
    @EnvironmentObject var dex: DexStore
    @State private var filter: CreatureType? = nil
    @State private var searchText: String = ""

    private let columns = [GridItem(.adaptive(minimum: 84), spacing: 10)]

    var filtered: [Creature] {
        var base = dex.caught
        if let f = filter {
            base = base.filter { $0.primary == f || $0.secondary == f }
        }
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !q.isEmpty {
            base = base.filter { $0.name.range(of: q, options: .caseInsensitive) != nil }
        }
        return base
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Pokédex")
                    .font(.system(.title3, design: .rounded).weight(.black))
                Spacer()
                Text("\(dex.caught.count) / 147")
                    .font(.caption.monospacedDigit().weight(.bold))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.white.opacity(0.06))
                    .frame(height: 6)
                GeometryReader { geo in
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Theme.primaryGradient)
                        .frame(width: max(6, geo.size.width * dex.completionRatio), height: 6)
                        .shadow(color: Theme.magenta.opacity(0.5), radius: 6)
                }
                .frame(height: 6)
            }
            .padding(.horizontal, 16)

            if dex.caught.isEmpty {
                Spacer()
                VStack(spacing: 8) {
                    Text("🥚").font(.system(size: 56))
                    Text("Your dex is empty.")
                        .font(.system(.headline, design: .rounded).weight(.bold))
                    Text("Focus to earn balls,\nthen catch on your break.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                Spacer()
            } else {
                SearchField(text: $searchText)
                    .padding(.horizontal, 16)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        FilterChip(label: "All", selected: filter == nil) { filter = nil }
                        ForEach(activeTypes, id: \.self) { t in
                            FilterChip(label: t.rawValue.capitalized, selected: filter == t) {
                                filter = (filter == t) ? nil : t
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(filtered) { c in
                            DexCellSprite(creature: c)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                }
            }
        }
    }

    private var activeTypes: [CreatureType] {
        let s = Set(dex.caught.flatMap { [$0.primary, $0.secondary].compactMap { $0 } })
        return CreatureType.allCases.filter { s.contains($0) }
    }
}

private struct SearchField: View {
    @Binding var text: String
    @FocusState private var focused: Bool

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(focused ? Theme.mint : Color.secondary)
            TextField("", text: $text, prompt: Text("Search by name…").foregroundColor(.secondary))
                .textFieldStyle(.plain)
                .foregroundStyle(.white)
                .tint(Theme.mint)
                .focused($focused)
                .autocorrectionDisabled(true)
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(8)
        .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(focused ? Theme.mint.opacity(0.6) : Color.white.opacity(0.08), lineWidth: 0.5)
        )
        .animation(.easeInOut(duration: 0.15), value: focused)
    }
}

private struct FilterChip: View {
    let label: String
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.caption2.weight(.heavy))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background {
                    Capsule().fill(selected ? AnyShapeStyle(Theme.primaryGradient) : AnyShapeStyle(Color.white.opacity(0.06)))
                }
                .overlay(Capsule().strokeBorder(Color.white.opacity(0.1), lineWidth: 0.5))
                .foregroundStyle(selected ? .white : Color.secondary)
        }
        .buttonStyle(.plain)
    }
}

private struct CreatureTile: View {
    let creature: Creature
    @State private var bob: CGFloat = 0

    var body: some View {
        VStack(spacing: 2) {
            Text(emoji)
                .font(.system(size: 30))
                .foregroundStyle(color)
                .shadow(color: color.opacity(0.5), radius: 8)
                .offset(y: bob)
                .onAppear {
                    withAnimation(.easeInOut(duration: Double.random(in: 1.8...3)).repeatForever(autoreverses: true)) {
                        bob = -3
                    }
                }
            Text(creature.dexNumber)
                .font(.system(size: 9, weight: .bold, design: .monospaced))
                .foregroundStyle(.secondary)
            Text(creature.name)
                .font(.system(size: 10, weight: .heavy, design: .rounded))
                .lineLimit(1)
        }
        .frame(width: 76, height: 92)
        .background(color.opacity(0.10), in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(color.opacity(0.25), lineWidth: 0.5))
    }

    private var color: Color {
        switch creature.primary {
        case .code: return Theme.mint
        case .art: return Theme.pink
        case .pixel: return Theme.yellow
        case .doc: return Theme.blue
        case .sound: return Theme.magenta
        default: return Theme.magenta
        }
    }
    private var emoji: String {
        switch creature.id {
        case 1: return "⌬"
        case 4: return "✒︎"
        case 7: return "✦"
        default: return "✶"
        }
    }
}
