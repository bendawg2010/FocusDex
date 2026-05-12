import SwiftUI

struct BallsTab: View {
    @EnvironmentObject var focus: FocusManager

    var body: some View {
        VStack(spacing: 14) {
            HStack {
                Text("Stockpile")
                    .font(.system(.title3, design: .rounded).weight(.black))
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)

            BallRow(label: "Focus Ball", subtitle: "1 per 5 min focus", count: focus.pokeballs, color: .green)
            BallRow(label: "Great Focus Ball", subtitle: "1 per 25 min uninterrupted", count: focus.greatBalls, color: .blue)
            BallRow(label: "Ultra Focus Ball", subtitle: "1 per 90 min deep work", count: focus.ultraBalls, color: .orange)
            BallRow(label: "Master Flow Ball", subtitle: "1 per 8h focus day", count: focus.masterBalls, color: .purple)

            Spacer()

            Text("Spend during breaks to catch creatures.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.bottom, 8)
        }
    }
}

private struct BallRow: View {
    let label: String
    let subtitle: String
    let count: Int
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(color.gradient)
                .frame(width: 28, height: 28)
                .overlay(Circle().strokeBorder(.white.opacity(0.4), lineWidth: 1))
            VStack(alignment: .leading, spacing: 2) {
                Text(label).font(.subheadline.weight(.bold))
                Text(subtitle).font(.caption2).foregroundStyle(.secondary)
            }
            Spacer()
            Text("\(count)")
                .font(.system(.title3, design: .rounded).weight(.heavy))
                .monospacedDigit()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(color.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 12)
    }
}
