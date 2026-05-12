import SwiftUI

// MARK: - Models

/// A single completed focus session entry. Codable so we can persist a log
/// in UserDefaults until a real data store is wired up.
struct SessionEntry: Codable, Identifiable, Hashable {
    var id = UUID()
    var date: Date
    var minutes: Double
}

// MARK: - Session log store

/// Light-weight wrapper around UserDefaults that keeps a `[SessionEntry]`
/// under `fd.sessionLog`. If empty on first load we seed it with a
/// deterministic 7-day mock derived from the user's lifetime stats so the
/// dashboard never feels empty.
final class SessionLogStore: ObservableObject {
    static let key = "fd.sessionLog"

    @Published private(set) var entries: [SessionEntry] = []

    init(totalFocusMin: Double = 0) {
        load(seedWith: totalFocusMin)
    }

    func load(seedWith totalFocusMin: Double) {
        if let data = UserDefaults.standard.data(forKey: Self.key),
           let decoded = try? JSONDecoder().decode([SessionEntry].self, from: data),
           !decoded.isEmpty {
            entries = decoded
            return
        }
        entries = Self.makeMock(totalFocusMin: totalFocusMin)
        save()
    }

    func append(_ entry: SessionEntry) {
        entries.append(entry)
        save()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: Self.key)
        }
    }

    /// Deterministic mock — same seed per app launch so the bars don't dance.
    static func makeMock(totalFocusMin: Double) -> [SessionEntry] {
        var rng = SeededRNG(seed: UInt64(max(1, Int(totalFocusMin))))
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        return (0..<7).reversed().map { offset in
            let day = cal.date(byAdding: .day, value: -offset, to: today) ?? today
            // Last day skews toward the user's recent activity; others fluctuate.
            let baseline = offset == 0 ? max(25, totalFocusMin.truncatingRemainder(dividingBy: 90))
                                       : Double.random(in: 12...75, using: &rng)
            return SessionEntry(date: day, minutes: baseline.rounded())
        }
    }
}

/// Tiny LCG so previews stay stable.
private struct SeededRNG: RandomNumberGenerator {
    var state: UInt64
    init(seed: UInt64) { self.state = seed == 0 ? 0xDEAD_BEEF : seed }
    mutating func next() -> UInt64 {
        state = state &* 6364136223846793005 &+ 1442695040888963407
        return state
    }
}

// MARK: - HistoryView

struct HistoryView: View {
    @EnvironmentObject var focus: FocusManager
    @StateObject private var log = SessionLogStore()
    @State private var hoveredDayIndex: Int? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                header
                statsGrid
                sparklineCard
                distributionCard
                personalRecordsCard
            }
            .padding(20)
        }
        .background(OrbBackground())
        .onAppear { log.load(seedWith: focus.totalFocusMin) }
    }

    // MARK: Header
    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            AnimatedGradientText(
                text: "Your year so far",
                font: .system(size: 30, weight: .black, design: .rounded)
            )
            Text("A look back at every minute you've put in.")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.white.opacity(0.65))
        }
    }

    // MARK: Big numbers
    private var statsGrid: some View {
        let hours = focus.totalFocusMin / 60.0
        let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
        return LazyVGrid(columns: columns, spacing: 12) {
            StatTile(label: "Total Sessions",
                     value: "\(focus.totalSessions)",
                     accent: Theme.blue)
            StatTile(label: "Hours Focused",
                     value: String(format: "%.1f", hours),
                     accent: Theme.mint)
            StatTile(label: "Current Streak",
                     value: "\(focus.currentStreak)",
                     suffix: "🔥",
                     accent: Theme.pink)
            StatTile(label: "Best Streak",
                     value: "\(focus.bestStreak)",
                     suffix: "🏆",
                     accent: Theme.yellow)
        }
    }

    // MARK: Sparkline
    private var sparklineCard: some View {
        DashboardCard(title: "Last 7 days") {
            VStack(alignment: .leading, spacing: 10) {
                if let i = hoveredDayIndex, log.entries.indices.contains(i) {
                    Text("\(Int(log.entries[i].minutes)) min · \(weekdayLong(log.entries[i].date))")
                        .font(.system(.caption, design: .rounded).weight(.semibold))
                        .foregroundStyle(Theme.mint)
                } else {
                    Text("Hover a bar for details")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.white.opacity(0.5))
                }

                let entries = log.entries
                let maxMin = max(1, entries.map(\.minutes).max() ?? 1)
                let peakIndex = entries.firstIndex(where: { $0.minutes == maxMin }) ?? 0

                GeometryReader { geo in
                    let count = max(1, entries.count)
                    let gap: CGFloat = 8
                    let barW = (geo.size.width - gap * CGFloat(count - 1)) / CGFloat(count)
                    HStack(alignment: .bottom, spacing: gap) {
                        ForEach(Array(entries.enumerated()), id: \.offset) { idx, entry in
                            let h = max(6, CGFloat(entry.minutes / maxMin) * (geo.size.height - 4))
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(idx == peakIndex
                                      ? AnyShapeStyle(LinearGradient(colors: [Theme.mint, Theme.magenta],
                                                                     startPoint: .bottom, endPoint: .top))
                                      : AnyShapeStyle(Theme.blue.opacity(0.55)))
                                .frame(width: barW, height: h)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(.white.opacity(hoveredDayIndex == idx ? 0.6 : 0), lineWidth: 1)
                                )
                                .onHover { inside in
                                    hoveredDayIndex = inside ? idx : (hoveredDayIndex == idx ? nil : hoveredDayIndex)
                                }
                        }
                    }
                }
                .frame(height: 110)

                HStack(spacing: 8) {
                    ForEach(Array(log.entries.enumerated()), id: \.offset) { _, entry in
                        Text(weekdayShort(entry.date))
                            .font(.system(.caption2, design: .rounded).weight(.medium))
                            .foregroundStyle(.white.opacity(0.55))
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }

    // MARK: Distribution
    private var distributionCard: some View {
        let parts: [(String, Int, Color)] = [
            ("Focus",  focus.pokeballs,    Theme.mint),
            ("Great",  focus.greatBalls,   Theme.blue),
            ("Ultra",  focus.ultraBalls,   Theme.yellow),
            ("Master", focus.masterBalls,  Theme.magenta)
        ]
        let total = max(1, parts.reduce(0) { $0 + $1.1 })
        return DashboardCard(title: "Distribution") {
            HStack(alignment: .center, spacing: 18) {
                Donut(values: parts.map { Double($0.1) / Double(total) },
                      colors: parts.map(\.2))
                    .frame(width: 130, height: 130)

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(parts, id: \.0) { name, count, color in
                        HStack(spacing: 8) {
                            Circle().fill(color).frame(width: 10, height: 10)
                            Text(name)
                                .font(.system(.subheadline, design: .rounded).weight(.medium))
                                .foregroundStyle(.white.opacity(0.85))
                            Spacer()
                            Text("\(count)")
                                .font(.system(.subheadline, design: .rounded).weight(.bold))
                                .foregroundStyle(.white)
                            Text("\(Int((Double(count) / Double(total)) * 100))%")
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(.white.opacity(0.55))
                                .frame(width: 38, alignment: .trailing)
                        }
                    }
                }
            }
        }
    }

    // MARK: Records
    private var personalRecordsCard: some View {
        let top = log.entries.sorted { $0.minutes > $1.minutes }.prefix(3)
        return DashboardCard(title: "Personal records") {
            VStack(spacing: 10) {
                ForEach(Array(top.enumerated()), id: \.offset) { idx, entry in
                    HStack(spacing: 12) {
                        Text("#\(idx + 1)")
                            .font(.system(.title3, design: .rounded).weight(.black))
                            .foregroundStyle(idx == 0 ? Theme.yellow : .white.opacity(0.55))
                            .frame(width: 32)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(Int(entry.minutes)) min")
                                .font(.system(.headline, design: .rounded).weight(.bold))
                                .foregroundStyle(.white)
                            Text(weekdayLong(entry.date))
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(.white.opacity(0.55))
                        }
                        Spacer()
                        Text(idx == 0 ? "🏅" : (idx == 1 ? "🥈" : "🥉"))
                            .font(.title3)
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white.opacity(0.04))
                    )
                }
            }
        }
    }

    // MARK: Formatting
    private func weekdayShort(_ date: Date) -> String {
        let f = DateFormatter(); f.dateFormat = "EEEEE"; return f.string(from: date)
    }
    private func weekdayLong(_ date: Date) -> String {
        let f = DateFormatter(); f.dateFormat = "EEE, MMM d"; return f.string(from: date)
    }
}

// MARK: - Reusable pieces

private struct StatTile: View {
    let label: String
    let value: String
    var suffix: String = ""
    let accent: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label.uppercased())
                .font(.system(.caption2, design: .rounded).weight(.heavy))
                .tracking(1.1)
                .foregroundStyle(.white.opacity(0.55))
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(value)
                    .font(.system(size: 30, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                if !suffix.isEmpty {
                    Text(suffix).font(.title3)
                }
            }
            Capsule().fill(accent.opacity(0.7)).frame(height: 3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(accent.opacity(0.25), lineWidth: 1)
                )
        )
    }
}

private struct DashboardCard<Content: View>: View {
    let title: String
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(.headline, design: .rounded).weight(.bold))
                .foregroundStyle(.white.opacity(0.9))
            content()
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(.white.opacity(0.08), lineWidth: 1)
                )
        )
    }
}

/// Hand-rolled donut chart — no Charts framework.
private struct Donut: View {
    let values: [Double]   // normalized 0..1, summing to ~1
    let colors: [Color]

    var body: some View {
        Canvas { ctx, size in
            let rect = CGRect(origin: .zero, size: size).insetBy(dx: 4, dy: 4)
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let radius = min(rect.width, rect.height) / 2
            let lineW = radius * 0.32
            var start = Angle.degrees(-90)
            let safeTotal = max(0.0001, values.reduce(0, +))
            for (i, raw) in values.enumerated() {
                let frac = raw / safeTotal
                let end = start + .degrees(frac * 360)
                var path = Path()
                path.addArc(center: center, radius: radius - lineW / 2,
                            startAngle: start, endAngle: end, clockwise: false)
                ctx.stroke(path,
                           with: .color(colors[i % colors.count]),
                           style: StrokeStyle(lineWidth: lineW, lineCap: .butt))
                start = end + .degrees(1.5) // small gap between slices
            }
        }
        .overlay(
            VStack(spacing: 0) {
                Text("\(Int(values.reduce(0, +) * 100))%")
                    .font(.system(.headline, design: .rounded).weight(.black))
                    .foregroundStyle(.white)
                Text("balls")
                    .font(.system(.caption2, design: .rounded))
                    .foregroundStyle(.white.opacity(0.55))
            }
        )
    }
}
