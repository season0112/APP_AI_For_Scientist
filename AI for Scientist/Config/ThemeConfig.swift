//
//  ThemeConfig.swift
//  AI for Scientist
//
//  Neon Dark Theme Configuration
//

import SwiftUI

/// Neon Dark Theme Configuration
enum ThemeConfig {
    // MARK: - Colors

    /// Background colors
    enum Background {
        static let primary = Color(red: 0.05, green: 0.05, blue: 0.08)
        static let secondary = Color(red: 0.08, green: 0.08, blue: 0.12)
        static let tertiary = Color(red: 0.12, green: 0.12, blue: 0.16)
        static let elevated = Color(red: 0.15, green: 0.15, blue: 0.20)
    }

    /// Neon accent colors
    enum Neon {
        static let cyan = Color(red: 0.0, green: 0.9, blue: 1.0)
        static let magenta = Color(red: 1.0, green: 0.0, blue: 0.8)
        static let purple = Color(red: 0.6, green: 0.2, blue: 1.0)
        static let electricBlue = Color(red: 0.0, green: 0.5, blue: 1.0)
        static let neonGreen = Color(red: 0.0, green: 1.0, blue: 0.5)
        static let neonOrange = Color(red: 1.0, green: 0.4, blue: 0.0)
        static let neonPink = Color(red: 1.0, green: 0.2, blue: 0.6)
    }

    /// Text colors
    enum Text {
        static let primary = Color.white
        static let secondary = Color.white.opacity(0.7)
        static let tertiary = Color.white.opacity(0.5)
        static let disabled = Color.white.opacity(0.3)
    }

    /// Semantic colors
    enum Semantic {
        static let success = Neon.neonGreen
        static let warning = Neon.neonOrange
        static let error = Neon.magenta
        static let info = Neon.cyan
    }

    // MARK: - Gradients

    enum Gradients {
        static let neonCyanMagenta = LinearGradient(
            colors: [Neon.cyan, Neon.magenta],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        static let neonPurpleBlue = LinearGradient(
            colors: [Neon.purple, Neon.electricBlue],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        static let neonGreenCyan = LinearGradient(
            colors: [Neon.neonGreen, Neon.cyan],
            startPoint: .leading,
            endPoint: .trailing
        )

        static let neonPinkOrange = LinearGradient(
            colors: [Neon.neonPink, Neon.neonOrange],
            startPoint: .leading,
            endPoint: .trailing
        )

        static let darkOverlay = LinearGradient(
            colors: [Background.primary.opacity(0), Background.primary],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    // MARK: - Shadows

    enum Shadows {
        static let neonGlow = Color(red: 0.0, green: 0.8, blue: 1.0).opacity(0.5)
        static let magentaGlow = Color(red: 1.0, green: 0.0, blue: 0.8).opacity(0.5)
        static let purpleGlow = Color(red: 0.6, green: 0.2, blue: 1.0).opacity(0.5)
        static let greenGlow = Color(red: 0.0, green: 1.0, blue: 0.5).opacity(0.5)
    }

    // MARK: - Spacing

    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }

    // MARK: - Corner Radius

    enum CornerRadius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
        static let pill: CGFloat = 100
    }

    // MARK: - Border Width

    enum BorderWidth {
        static let thin: CGFloat = 1
        static let medium: CGFloat = 2
        static let thick: CGFloat = 3
    }

    // MARK: - Animation

    enum Animation {
        static let fast = SwiftUI.Animation.easeInOut(duration: 0.2)
        static let medium = SwiftUI.Animation.easeInOut(duration: 0.3)
        static let slow = SwiftUI.Animation.easeInOut(duration: 0.5)
        static let spring = SwiftUI.Animation.spring(response: 0.4, dampingFraction: 0.7)
    }

    // MARK: - Blur

    enum Blur {
        static let light: CGFloat = 10
        static let medium: CGFloat = 20
        static let heavy: CGFloat = 30
    }
}

// MARK: - View Modifiers

/// Neon glow effect modifier
struct NeonGlowModifier: ViewModifier {
    let color: Color
    let radius: CGFloat

    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(0.6), radius: radius, x: 0, y: 0)
            .shadow(color: color.opacity(0.4), radius: radius * 2, x: 0, y: 0)
    }
}

/// Neon border modifier
struct NeonBorderModifier: ViewModifier {
    let color: Color
    let width: CGFloat
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(color, lineWidth: width)
                    .shadow(color: color.opacity(0.6), radius: 8, x: 0, y: 0)
            )
    }
}

/// Glass morphism effect
struct GlassMorphismModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                    .fill(ThemeConfig.Background.tertiary.opacity(0.6))
                    .overlay(
                        RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
            .background(.ultraThinMaterial.opacity(0.3))
    }
}

/// Neon card style
struct NeonCardModifier: ViewModifier {
    let gradient: LinearGradient

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.lg)
                    .fill(ThemeConfig.Background.elevated)
                    .overlay(
                        RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.lg)
                            .stroke(gradient, lineWidth: 2)
                    )
            )
            .shadow(color: ThemeConfig.Shadows.neonGlow, radius: 10, x: 0, y: 4)
    }
}

// MARK: - View Extensions

extension View {
    /// Apply neon glow effect
    func neonGlow(color: Color = ThemeConfig.Neon.cyan, radius: CGFloat = 8) -> some View {
        self.modifier(NeonGlowModifier(color: color, radius: radius))
    }

    /// Apply neon border
    func neonBorder(color: Color = ThemeConfig.Neon.cyan, width: CGFloat = 2, cornerRadius: CGFloat = ThemeConfig.CornerRadius.md) -> some View {
        self.modifier(NeonBorderModifier(color: color, width: width, cornerRadius: cornerRadius))
    }

    /// Apply glass morphism effect
    func glassMorphism() -> some View {
        self.modifier(GlassMorphismModifier())
    }

    /// Apply neon card style
    func neonCard(gradient: LinearGradient = ThemeConfig.Gradients.neonCyanMagenta) -> some View {
        self.modifier(NeonCardModifier(gradient: gradient))
    }
}

// MARK: - Custom Button Styles

struct NeonButtonStyle: ButtonStyle {
    let gradient: LinearGradient
    let isCompact: Bool

    init(gradient: LinearGradient = ThemeConfig.Gradients.neonCyanMagenta, isCompact: Bool = false) {
        self.gradient = gradient
        self.isCompact = isCompact
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(isCompact ? .subheadline : .headline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, isCompact ? ThemeConfig.Spacing.md : ThemeConfig.Spacing.lg)
            .padding(.vertical, isCompact ? ThemeConfig.Spacing.sm : ThemeConfig.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                    .fill(gradient)
            )
            .overlay(
                RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
            .neonGlow(color: ThemeConfig.Neon.cyan, radius: configuration.isPressed ? 4 : 8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(ThemeConfig.Animation.fast, value: configuration.isPressed)
    }
}

struct NeonOutlineButtonStyle: ButtonStyle {
    let color: Color

    init(color: Color = ThemeConfig.Neon.cyan) {
        self.color = color
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(color)
            .padding(.horizontal, ThemeConfig.Spacing.md)
            .padding(.vertical, ThemeConfig.Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.sm)
                    .fill(ThemeConfig.Background.tertiary)
                    .overlay(
                        RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.sm)
                            .stroke(color, lineWidth: 2)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(ThemeConfig.Animation.fast, value: configuration.isPressed)
    }
}

// MARK: - Custom Shapes

struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height

        path.move(to: CGPoint(x: width * 0.5, y: 0))
        path.addLine(to: CGPoint(x: width, y: height * 0.25))
        path.addLine(to: CGPoint(x: width, y: height * 0.75))
        path.addLine(to: CGPoint(x: width * 0.5, y: height))
        path.addLine(to: CGPoint(x: 0, y: height * 0.75))
        path.addLine(to: CGPoint(x: 0, y: height * 0.25))
        path.closeSubpath()

        return path
    }
}
