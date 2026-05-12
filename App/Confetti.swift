import SwiftUI

/// Bursts of brand-color particles. Bump `burstID` to trigger.
struct ConfettiBurst: View {
    let burstID: UUID
    var origin: CGPoint = .zero
    var count: Int = 56

    @State private var dots: [Dot] = []
    @State private var animate = false

    struct Dot: Identifiable {
        let id = UUID()
        let dx: CGFloat
        let dy: CGFloat
        let drop: CGFloat
        let color: Color
        let size: CGFloat
        let rotation: Double
        let delay: Double
    }

    var body: some View {
        ZStack {
            ForEach(dots) { d in
                RoundedRectangle(cornerRadius: 1.5)
                    .fill(d.color)
                    .frame(width: d.size, height: d.size * 1.6)
                    .rotationEffect(.degrees(animate ? d.rotation + 360 : d.rotation))
                    .offset(
                        x: animate ? d.dx : 0,
                        y: animate ? d.dy + d.drop : 0
                    )
                    .opacity(animate ? 0 : 1)
                    .animation(.easeOut(duration: 1.6).delay(d.delay), value: animate)
                    .shadow(color: d.color.opacity(0.6), radius: 4)
            }
        }
        .offset(x: origin.x, y: origin.y)
        .allowsHitTesting(false)
        .onAppear { fire() }
        .onChange(of: burstID) { _ in fire() }
    }

    private func fire() {
        let palette: [Color] = [Theme.pink, Theme.magenta, Theme.blue, Theme.mint, Theme.yellow]
        animate = false
        dots = (0..<count).map { _ in
            let angle = Double.random(in: -.pi ... 0)
            let radius = CGFloat.random(in: 50...150)
            return Dot(
                dx: CGFloat(cos(angle)) * radius,
                dy: CGFloat(sin(angle)) * radius,
                drop: CGFloat.random(in: 140...260),
                color: palette.randomElement()!,
                size: CGFloat.random(in: 4...8),
                rotation: Double.random(in: -180...180),
                delay: Double.random(in: 0...0.18)
            )
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) {
            withAnimation { animate = true }
        }
    }
}

/// Persistent sparkle aura around legendary/mythic creatures.
struct SparkleAura: View {
    @State private var phase: Double = 0
    var color: Color = Theme.yellow

    var body: some View {
        ZStack {
            ForEach(0..<8, id: \.self) { i in
                Image(systemName: "sparkle")
                    .font(.system(size: 8))
                    .foregroundStyle(color)
                    .offset(
                        x: cos(phase + Double(i) * .pi / 4) * 40,
                        y: sin(phase + Double(i) * .pi / 4) * 40
                    )
                    .opacity(0.7 + 0.3 * sin(phase * 2 + Double(i)))
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 6).repeatForever(autoreverses: false)) {
                phase = .pi * 2
            }
        }
        .allowsHitTesting(false)
    }
}
