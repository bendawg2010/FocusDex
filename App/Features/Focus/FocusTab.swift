import SwiftUI

struct FocusTab: View {
    @EnvironmentObject var focus: FocusManager

    var body: some View {
        VStack(spacing: 18) {
            Spacer(minLength: 12)

            Text(focus.formattedElapsed)
                .font(.system(size: 56, weight: .black, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(focus.isFocusing ? Color.accentColor : .primary)

            Text(focus.isFocusing ? "Focusing — Notchy is watching." : "Tap to start a session.")
                .font(.callout)
                .foregroundStyle(.secondary)

            Button(action: { focus.isFocusing ? focus.stop() : focus.start() }) {
                Text(focus.isFocusing ? "Stop Session" : "Start Focus")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal, 24)

            HStack(spacing: 14) {
                BallChip(label: "Focus", count: focus.pokeballs, color: .green)
                BallChip(label: "Great", count: focus.greatBalls, color: .blue)
                BallChip(label: "Ultra", count: focus.ultraBalls, color: .orange)
                BallChip(label: "Master", count: focus.masterBalls, color: .purple)
            }
            .padding(.horizontal, 16)

            Spacer()
        }
    }
}

private struct BallChip: View {
    let label: String
    let count: Int
    let color: Color

    var body: some View {
        VStack(spacing: 2) {
            Text("\(count)")
                .font(.system(.headline, design: .rounded))
                .monospacedDigit()
            Text(label)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(color.opacity(0.15), in: RoundedRectangle(cornerRadius: 10))
    }
}
