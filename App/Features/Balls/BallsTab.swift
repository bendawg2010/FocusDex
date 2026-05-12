import SwiftUI

struct BallsTab: View {
    @EnvironmentObject var focus: FocusManager

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Stockpile")
                    .font(.system(.title3, design: .rounded).weight(.black))
                Spacer()
                Text("\(focus.totalBalls) total")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)

            ScrollView {
                VStack(spacing: 8) {
                    BigBallRow(
                        title: "Focus Ball",
                        subtitle: "5 min of focus",
                        count: focus.pokeballs,
                        catchRate: "Common · 85%",
                        color: Theme.mint
                    )
                    BigBallRow(
                        title: "Great Focus Ball",
                        subtitle: "25 min uninterrupted",
                        count: focus.greatBalls,
                        catchRate: "Uncommon · +10%",
                        color: Theme.blue
                    )
                    BigBallRow(
                        title: "Ultra Focus Ball",
                        subtitle: "90 min deep work",
                        count: focus.ultraBalls,
                        catchRate: "Rare · +22%",
                        color: Theme.yellow
                    )
                    BigBallRow(
                        title: "Master Flow Ball",
                        subtitle: "8h focused day",
                        count: focus.masterBalls,
                        catchRate: "Catches anything",
                        color: Theme.magenta
                    )
                }
                .padding(.horizontal, 12)

                Divider().padding(.horizontal, 16).padding(.top, 6)

                LifetimeStatsCard()
                    .padding(.horizontal, 12)
                    .padding(.top, 10)
                    .padding(.bottom, 14)
            }
        }
    }
}

private struct BigBallRow: View {
    let title: String
    let subtitle: String
    let count: Int
    let catchRate: String
    let color: Color

    @State private var glow = false

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(color.gradient)
                    .frame(width: 44, height: 44)
                    .overlay(Circle().strokeBorder(.white.opacity(0.4), lineWidth: 1.2))
                    .shadow(color: color.opacity(glow ? 0.7 : 0.4), radius: glow ? 16 : 8)
                Image(systemName: "circle.hexagongrid.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(.white.opacity(0.5))
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true)) { glow.toggle() }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(.subheadline, design: .rounded).weight(.heavy))
                Text(subtitle).font(.caption2).foregroundStyle(.secondary)
                Text(catchRate)
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .foregroundStyle(color.opacity(0.9))
            }

            Spacer(minLength: 0)

            Text("\(count)")
                .font(.system(.title2, design: .rounded).weight(.black))
                .monospacedDigit()
                .contentTransition(.numericText())
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(color.opacity(0.10))
                .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(color.opacity(0.25), lineWidth: 0.5))
        )
    }
}

private struct LifetimeStatsCard: View {
    @EnvironmentObject var focus: FocusManager

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundStyle(Theme.magenta)
                Text("Lifetime stats")
                    .font(.system(.subheadline, design: .rounded).weight(.heavy))
                Spacer()
            }

            HStack(spacing: 10) {
                StatTile(label: "Sessions", value: "\(focus.totalSessions)", icon: "checkmark.seal.fill")
                StatTile(label: "Minutes", value: "\(Int(focus.totalFocusMin))", icon: "clock.fill")
                StatTile(label: "Streak", value: "\(focus.currentStreak)", icon: "flame.fill")
                StatTile(label: "Best", value: "\(focus.bestStreak)", icon: "trophy.fill")
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.04))
                .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(Color.white.opacity(0.08), lineWidth: 0.5))
        )
    }
}

private struct StatTile: View {
    let label: String
    let value: String
    let icon: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.system(.headline, design: .rounded).weight(.black))
                .monospacedDigit()
                .foregroundStyle(.white)
            Text(label)
                .font(.system(size: 8, weight: .heavy, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 10))
    }
}
