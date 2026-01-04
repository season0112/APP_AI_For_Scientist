//
//  HomeView.swift
//  AI for Scientist
//
//  Home screen with quick actions and onboarding
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var mainViewModel: MainViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
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
            .navigationTitle("AI for Scientist")
        }
    }

    // MARK: - View Components

    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "sparkles")
                    .font(.title)
                    .foregroundColor(.blue)

                Text("Welcome to AI for Scientist")
                    .font(.title2)
                    .fontWeight(.bold)
            }

            Text("Your AI-powered research assistant for discovering and curating scientific literature")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }

    private var onboardingSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Get Started")
                .font(.headline)

            VStack(spacing: 10) {
                OnboardingStepView(
                    number: 1,
                    title: "Select Research Fields",
                    description: "Choose your areas of interest",
                    systemImage: "list.bullet.clipboard"
                )

                OnboardingStepView(
                    number: 2,
                    title: "Upload Your Paper",
                    description: "Add your research paper (optional)",
                    systemImage: "arrow.up.doc"
                )

                OnboardingStepView(
                    number: 3,
                    title: "Generate Newsletter",
                    description: "Get personalized research updates",
                    systemImage: "envelope.badge"
                )
            }

            NavigationLink(destination: FieldSelectionView()) {
                Text("Select Research Fields")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }

    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Quick Actions")
                .font(.headline)

            HStack(spacing: 15) {
                QuickActionButton(
                    title: "Upload Paper",
                    systemImage: "arrow.up.doc.fill",
                    color: .blue
                ) {
                    mainViewModel.selectedTab = .upload
                }

                QuickActionButton(
                    title: "Generate Newsletter",
                    systemImage: "envelope.fill",
                    color: .green
                ) {
                    // Navigate to newsletter generation
                    mainViewModel.selectedTab = .newsletters
                }
            }
        }
    }

    private var recentPapersSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Recent Papers")
                    .font(.headline)

                Spacer()

                Button("View All") {
                    mainViewModel.selectedTab = .upload
                }
                .font(.subheadline)
            }

            ForEach(Array(mainViewModel.userProfile.uploadedPapers.prefix(3))) { paper in
                PaperRowView(paper: paper)
            }
        }
    }

    private var recentNewslettersSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Recent Newsletters")
                    .font(.headline)

                Spacer()

                Button("View All") {
                    mainViewModel.selectedTab = .newsletters
                }
                .font(.subheadline)
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

    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 40, height: 40)

                Image(systemName: systemImage)
                    .foregroundColor(.blue)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
    }
}

struct QuickActionButton: View {
    let title: String
    let systemImage: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: systemImage)
                    .font(.largeTitle)
                    .foregroundColor(color)

                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(color.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

struct PaperRowView: View {
    let paper: Paper

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(paper.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(2)

            Text(paper.formattedAuthors)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

struct NewsletterRowView: View {
    let newsletter: Newsletter

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(newsletter.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(2)

            HStack {
                Text(newsletter.researchField.name)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(4)

                Text(newsletter.formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    HomeView()
        .environmentObject(MainViewModel())
}
