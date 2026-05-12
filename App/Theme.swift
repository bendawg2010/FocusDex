import SwiftUI

/// Centralized FocusDex brand palette and visual primitives.
enum Theme {
    static let pink     = Color(red: 1.00, green: 0.42, blue: 0.42)   // #FF6B6B
    static let magenta  = Color(red: 0.76, green: 0.28, blue: 1.00)   // #C147FF
    static let blue     = Color(red: 0.28, green: 0.63, blue: 1.00)   // #47A0FF
    static let mint     = Color(red: 0.18, green: 0.90, blue: 0.63)   // #2EE6A0
    static let yellow   = Color(red: 1.00, green: 0.85, blue: 0.38)   // #FFD960
    static let bgDeep   = Color(red: 0.024, green: 0.004, blue: 0.06) // #06010f
    static let bgCard   = Color(red: 0.047, green: 0.016, blue: 0.13) // #0c0420

    /// The signature animated gradient used across hero/title elements.
    static let titleGradient = LinearGradient(
        colors: [pink, magenta, blue, mint, yellow],
        startPoint: .leading,
        endPoint: .trailing
    )

    /// The primary button gradient.
    static let primaryGradient = LinearGradient(
        colors: [pink, magenta],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// The session-active gradient (calming + alert).
    static let focusGradient = LinearGradient(
        colors: [mint, blue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// The full-popover background.
    static let popoverBackground = LinearGradient(
        colors: [bgDeep, bgCard],
        startPoint: .top,
        endPoint: .bottom
    )
}

// MARK: - Reusable view modifiers

extension View {
    /// A glow effect mirroring the website's drop-shadows.
    func brandGlow(_ color: Color = Theme.magenta, radius: CGFloat = 12) -> some View {
        shadow(color: color.opacity(0.5), radius: radius, x: 0, y: 0)
    }
}

// MARK: - Primary button

struct PrimaryGradientButtonStyle: ButtonStyle {
    var gradient: LinearGradient = Theme.primaryGradient

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.headline, design: .rounded).weight(.heavy))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(gradient, in: RoundedRectangle(cornerRadius: 14))
            .shadow(color: Theme.magenta.opacity(0.4), radius: 12, x: 0, y: 6)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Floating orb background

struct OrbBackground: View {
    @State private var phase: Double = 0

    var body: some View {
        ZStack {
            Theme.popoverBackground.ignoresSafeArea()

            Circle()
                .fill(RadialGradient(colors: [Theme.magenta.opacity(0.45), .clear], center: .center, startRadius: 0, endRadius: 180))
                .frame(width: 360, height: 360)
                .offset(x: 80 + cos(phase) * 30, y: -120 + sin(phase) * 40)
                .blur(radius: 30)

            Circle()
                .fill(RadialGradient(colors: [Theme.blue.opacity(0.45), .clear], center: .center, startRadius: 0, endRadius: 180))
                .frame(width: 360, height: 360)
                .offset(x: -100 + sin(phase * 0.7) * 50, y: 160 + cos(phase * 0.7) * 30)
                .blur(radius: 30)
        }
        .onAppear {
            withAnimation(.linear(duration: 22).repeatForever(autoreverses: false)) {
                phase = .pi * 2
            }
        }
    }
}

// MARK: - Animated gradient text

struct AnimatedGradientText: View {
    let text: String
    var font: Font = .system(size: 24, weight: .black, design: .rounded)
    @State private var phase: CGFloat = 0

    var body: some View {
        Text(text)
            .font(font)
            .foregroundStyle(
                LinearGradient(
                    colors: [Theme.pink, Theme.magenta, Theme.blue, Theme.mint, Theme.yellow, Theme.pink],
                    startPoint: UnitPoint(x: phase, y: 0.5),
                    endPoint: UnitPoint(x: phase + 1, y: 0.5)
                )
            )
            .onAppear {
                withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                    phase = -1
                }
            }
    }
}
