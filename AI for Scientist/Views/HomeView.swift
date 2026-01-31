//
//  HomeView.swift
//  AI for Scientist
//
//  Home screen with quick actions and onboarding
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @State private var animateGradient = false

    var body: some View {
        NavigationView {
            ZStack {
                // Dark background with animated gradient overlay
                ThemeConfig.Background.primary
                    .ignoresSafeArea()

                // Animated background gradient
                Rectangle()
                    .fill(
                        RadialGradient(
                            colors: [
                                ThemeConfig.Neon.cyan.opacity(0.1),
                                ThemeConfig.Neon.magenta.opacity(0.05),
                                Color.clear
                            ],
                            center: animateGradient ? .topLeading : .bottomTrailing,
                            startRadius: 0,
                            endRadius: 500
                        )
                    )
                    .ignoresSafeArea()
                    .animation(
                        Animation.easeInOut(duration: 8).repeatForever(autoreverses: true),
                        value: animateGradient
                    )
                    .onAppear {
                        animateGradient = true
                    }

                ScrollView(showsIndicators: false) {
                    VStack(spacing: ThemeConfig.Spacing.lg) {
                        // Welcome Section
                        welcomeSection

                        // Quick Actions
                        if mainViewModel.userProfile.isProfileComplete {
                            quickActionsSection
                        } else {
                            onboardingSection
                        }

                        // Recent Papers
                        if !mainViewModel.userProfile.uploadedPapers.isEmpty {
                            recentPapersSection
                        }

                        // Recent Newsletters
                        if !mainViewModel.userProfile.savedNewsletters.isEmpty {
                            recentNewslettersSection
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("AI for Scientist")
            .toolbarBackground(ThemeConfig.Background.secondary, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    // MARK: - View Components

    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: ThemeConfig.Spacing.md) {
            HStack(spacing: ThemeConfig.Spacing.md) {
                // Hexagon icon with neon glow
                ZStack {
                    HexagonShape()
                        .fill(ThemeConfig.Gradients.neonCyanMagenta)
                        .frame(width: 50, height: 50)
                        .neonGlow(color: ThemeConfig.Neon.cyan, radius: 12)

                    Image(systemName: "sparkles")
                        .font(.title2)
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("AI for Scientist")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(ThemeConfig.Gradients.neonCyanMagenta)

                    Text("Next-Gen Research")
                        .font(.caption)
                        .foregroundColor(ThemeConfig.Neon.cyan)
                        .fontWeight(.semibold)
                }
            }

            Text("Your AI-powered research assistant for discovering and curating scientific literature")
                .font(.subheadline)
                .foregroundColor(ThemeConfig.Text.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(ThemeConfig.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.lg)
                .fill(ThemeConfig.Background.elevated)
                .overlay(
                    RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.lg)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    ThemeConfig.Neon.cyan.opacity(0.6),
                                    ThemeConfig.Neon.magenta.opacity(0.6)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
        )
        .shadow(color: ThemeConfig.Shadows.neonGlow, radius: 20, x: 0, y: 10)
    }

    private var onboardingSection: some View {
        VStack(alignment: .leading, spacing: ThemeConfig.Spacing.lg) {
            HStack {
                Text("Get Started")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(ThemeConfig.Text.primary)

                Spacer()

                Image(systemName: "arrow.forward.circle.fill")
                    .font(.title2)
                    .foregroundStyle(ThemeConfig.Gradients.neonGreenCyan)
            }

            VStack(spacing: ThemeConfig.Spacing.md) {
                OnboardingStepView(
                    number: 1,
                    title: "Select Research Fields",
                    description: "Choose your areas of interest",
                    systemImage: "list.bullet.clipboard",
                    color: ThemeConfig.Neon.cyan
                )

                OnboardingStepView(
                    number: 2,
                    title: "Upload Your Paper",
                    description: "Add your research paper (optional)",
                    systemImage: "arrow.up.doc",
                    color: ThemeConfig.Neon.purple
                )

                OnboardingStepView(
                    number: 3,
                    title: "Generate Newsletter",
                    description: "Get personalized research updates",
                    systemImage: "envelope.badge",
                    color: ThemeConfig.Neon.neonGreen
                )
            }

            NavigationLink(destination: FieldSelectionView()) {
                HStack {
                    Text("Select Research Fields")
                        .font(.headline)
                        .fontWeight(.semibold)

                    Spacer()

                    Image(systemName: "arrow.right")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .padding(ThemeConfig.Spacing.md)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                        .fill(ThemeConfig.Gradients.neonCyanMagenta)
                )
                .neonGlow(color: ThemeConfig.Neon.cyan, radius: 10)
            }
        }
        .padding(ThemeConfig.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.lg)
                .fill(ThemeConfig.Background.elevated)
                .overlay(
                    RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.lg)
                        .stroke(ThemeConfig.Neon.cyan.opacity(0.3), lineWidth: 1)
                )
        )
    }

    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: ThemeConfig.Spacing.md) {
            Text("Quick Actions")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(ThemeConfig.Text.primary)

            HStack(spacing: ThemeConfig.Spacing.md) {
                QuickActionButton(
                    title: "Upload Paper",
                    systemImage: "arrow.up.doc.fill",
                    gradient: ThemeConfig.Gradients.neonPurpleBlue,
                    glowColor: ThemeConfig.Neon.purple
                ) {
                    mainViewModel.selectedTab = .upload
                }

                QuickActionButton(
                    title: "Generate Newsletter",
                    systemImage: "envelope.fill",
                    gradient: ThemeConfig.Gradients.neonGreenCyan,
                    glowColor: ThemeConfig.Neon.neonGreen
                ) {
                    mainViewModel.selectedTab = .newsletters
                }
            }
        }
    }

    private var recentPapersSection: some View {
        VStack(alignment: .leading, spacing: ThemeConfig.Spacing.md) {
            HStack {
                Text("Recent Papers")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(ThemeConfig.Text.primary)

                Spacer()

                Button("View All") {
                    mainViewModel.selectedTab = .upload
                }
                .font(.subheadline)
                .foregroundColor(ThemeConfig.Neon.cyan)
            }

            ForEach(Array(mainViewModel.userProfile.uploadedPapers.prefix(3))) { paper in
                PaperRowView(paper: paper)
            }
        }
    }

    private var recentNewslettersSection: some View {
        VStack(alignment: .leading, spacing: ThemeConfig.Spacing.md) {
            HStack {
                Text("Recent Newsletters")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(ThemeConfig.Text.primary)

                Spacer()

                Button("View All") {
                    mainViewModel.selectedTab = .newsletters
                }
                .font(.subheadline)
                .foregroundColor(ThemeConfig.Neon.cyan)
            }

            ForEach(Array(mainViewModel.userProfile.savedNewsletters.prefix(3))) { newsletter in
                NewsletterRowView(newsletter: newsletter)
            }
        }
    }
}

// MARK: - Supporting Views

struct OnboardingStepView: View {
    let number: Int
    let title: String
    let description: String
    let systemImage: String
    let color: Color

    var body: some View {
        HStack(spacing: ThemeConfig.Spacing.md) {
            // Geometric number badge
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Circle()
                            .stroke(color, lineWidth: 2)
                    )

                Image(systemName: systemImage)
                    .font(.title3)
                    .foregroundColor(color)
            }
            .shadow(color: color.opacity(0.5), radius: 8, x: 0, y: 0)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(ThemeConfig.Text.primary)

                Text(description)
                    .font(.caption)
                    .foregroundColor(ThemeConfig.Text.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(color.opacity(0.6))
        }
        .padding(ThemeConfig.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                .fill(ThemeConfig.Background.tertiary)
        )
    }
}

struct QuickActionButton: View {
    let title: String
    let systemImage: String
    let gradient: LinearGradient
    let glowColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: ThemeConfig.Spacing.md) {
                ZStack {
                    Circle()
                        .fill(gradient)
                        .frame(width: 60, height: 60)
                        .neonGlow(color: glowColor, radius: 12)

                    Image(systemName: systemImage)
                        .font(.title)
                        .foregroundColor(.white)
                }

                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(ThemeConfig.Text.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(ThemeConfig.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.lg)
                    .fill(ThemeConfig.Background.tertiary)
                    .overlay(
                        RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.lg)
                            .stroke(gradient, lineWidth: 2)
                    )
            )
            .shadow(color: glowColor.opacity(0.3), radius: 15, x: 0, y: 8)
        }
    }
}

struct PaperRowView: View {
    let paper: Paper

    var body: some View {
        HStack(spacing: ThemeConfig.Spacing.md) {
            // Paper icon
            ZStack {
                RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.sm)
                    .fill(ThemeConfig.Gradients.neonPurpleBlue.opacity(0.3))
                    .frame(width: 40, height: 40)

                Image(systemName: "doc.text.fill")
                    .foregroundColor(ThemeConfig.Neon.purple)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(paper.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(ThemeConfig.Text.primary)
                    .lineLimit(2)

                Text(paper.formattedAuthors)
                    .font(.caption)
                    .foregroundColor(ThemeConfig.Text.secondary)
                    .lineLimit(1)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(ThemeConfig.Neon.purple.opacity(0.6))
        }
        .padding(ThemeConfig.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                .fill(ThemeConfig.Background.tertiary)
                .overlay(
                    RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                        .stroke(ThemeConfig.Neon.purple.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct NewsletterRowView: View {
    let newsletter: Newsletter

    var body: some View {
        HStack(spacing: ThemeConfig.Spacing.md) {
            // Newsletter icon with gradient
            ZStack {
                RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.sm)
                    .fill(ThemeConfig.Gradients.neonGreenCyan.opacity(0.3))
                    .frame(width: 40, height: 40)

                Image(systemName: "envelope.fill")
                    .foregroundColor(ThemeConfig.Neon.neonGreen)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(newsletter.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(ThemeConfig.Text.primary)
                    .lineLimit(2)

                HStack(spacing: 6) {
                    Text(newsletter.researchField.name)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(
                            Capsule()
                                .fill(ThemeConfig.Neon.cyan.opacity(0.2))
                                .overlay(
                                    Capsule()
                                        .stroke(ThemeConfig.Neon.cyan.opacity(0.5), lineWidth: 1)
                                )
                        )
                        .foregroundColor(ThemeConfig.Neon.cyan)

                    Text(newsletter.formattedDate)
                        .font(.caption2)
                        .foregroundColor(ThemeConfig.Text.tertiary)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(ThemeConfig.Neon.neonGreen.opacity(0.6))
        }
        .padding(ThemeConfig.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                .fill(ThemeConfig.Background.tertiary)
                .overlay(
                    RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                        .stroke(ThemeConfig.Neon.neonGreen.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#Preview {
    HomeView()
        .environmentObject(MainViewModel())
}
