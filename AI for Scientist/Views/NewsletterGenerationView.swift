//
//  NewsletterGenerationView.swift
//  AI for Scientist
//
//  View for generating newsletters with AI search
//

import SwiftUI

struct NewsletterGenerationView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showFieldSelection = false
    @State private var searchQuery = ""

    var body: some View {
        NewsletterGenerationContentView(
            mainViewModel: mainViewModel,
            dismiss: dismiss,
            showFieldSelection: $showFieldSelection,
            searchQuery: $searchQuery
        )
    }
}

struct NewsletterGenerationContentView: View {
    @ObservedObject var mainViewModel: MainViewModel
    @StateObject private var viewModel: NewsletterGenerationViewModel
    let dismiss: DismissAction
    @Binding var showFieldSelection: Bool
    @Binding var searchQuery: String

    init(mainViewModel: MainViewModel, dismiss: DismissAction, showFieldSelection: Binding<Bool>, searchQuery: Binding<String>) {
        self.mainViewModel = mainViewModel
        self.dismiss = dismiss
        self._showFieldSelection = showFieldSelection
        self._searchQuery = searchQuery
        self._viewModel = StateObject(wrappedValue: NewsletterGenerationViewModel(mainViewModel: mainViewModel))
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Dark background
                ThemeConfig.Background.primary
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: ThemeConfig.Spacing.xl) {
                        // Step 1: Select Field
                        fieldSelectionSection

                        // Step 2: Select Paper (Optional)
                        paperSelectionSection

                        // Step 3: AI Search
                        if viewModel.selectedField != nil {
                            searchSection
                        }

                        // Step 4: Search Results
                        if !viewModel.searchResults.isEmpty {
                            searchResultsSection
                        }

                        // Show message if field is selected but no search performed yet
                        if viewModel.selectedField != nil && viewModel.searchResults.isEmpty && !viewModel.isSearching {
                            searchPromptSection
                        }

                        // Step 5: Generate Newsletter
                        if !viewModel.searchResults.isEmpty {
                            generateSection
                        }

                        // Generated Newsletter
                        if let newsletter = viewModel.generatedNewsletter {
                            generatedNewsletterSection(newsletter)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Generate Newsletter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(ThemeConfig.Background.secondary, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(ThemeConfig.Neon.cyan)
                }
            }
            .sheet(isPresented: $showFieldSelection) {
                FieldSelectionView()
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "An error occurred")
            }
        }
    }

    // MARK: - View Components

    private var fieldSelectionSection: some View {
        VStack(alignment: .leading, spacing: ThemeConfig.Spacing.md) {
            HStack(spacing: ThemeConfig.Spacing.sm) {
                ZStack {
                    Circle()
                        .fill(ThemeConfig.Gradients.neonCyanMagenta)
                        .frame(width: 32, height: 32)
                        .neonGlow(color: ThemeConfig.Neon.cyan, radius: 8)

                    Text("1")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }

                Text("Select Research Field")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(ThemeConfig.Text.primary)
            }

            if let field = viewModel.selectedField {
                FieldBadgeView(field: field) {
                    viewModel.selectField(nil)
                }
            } else {
                // Show preferred fields if available
                if !mainViewModel.userProfile.preferredFields.isEmpty {
                    VStack(spacing: ThemeConfig.Spacing.sm) {
                        ForEach(mainViewModel.userProfile.preferredFields) { field in
                            Button(action: {
                                viewModel.selectField(field)
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(field.name)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(ThemeConfig.Text.primary)

                                        Text(field.description)
                                            .font(.caption)
                                            .foregroundColor(ThemeConfig.Text.secondary)
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .foregroundColor(ThemeConfig.Neon.cyan)
                                }
                                .padding(ThemeConfig.Spacing.md)
                                .background(
                                    RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                                        .fill(ThemeConfig.Background.tertiary)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                                                .stroke(ThemeConfig.Neon.cyan.opacity(0.3), lineWidth: 1)
                                        )
                                )
                            }
                        }

                        Button(action: { showFieldSelection = true }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Manage Fields")
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(ThemeConfig.Neon.cyan)
                        }
                    }
                } else {
                    Button(action: { showFieldSelection = true }) {
                        HStack {
                            Text("Choose Field")
                                .foregroundColor(ThemeConfig.Neon.cyan)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(ThemeConfig.Text.tertiary)
                        }
                        .padding(ThemeConfig.Spacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                                .fill(ThemeConfig.Background.tertiary)
                                .overlay(
                                    RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                                        .stroke(ThemeConfig.Neon.cyan.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                }
            }
        }
        .padding(ThemeConfig.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.lg)
                .fill(ThemeConfig.Background.elevated)
                .overlay(
                    RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.lg)
                        .stroke(ThemeConfig.Neon.cyan.opacity(0.2), lineWidth: 1)
                )
        )
    }

    private var paperSelectionSection: some View {
        VStack(alignment: .leading, spacing: ThemeConfig.Spacing.md) {
            HStack(spacing: ThemeConfig.Spacing.sm) {
                ZStack {
                    Circle()
                        .fill(ThemeConfig.Gradients.neonPurpleBlue)
                        .frame(width: 32, height: 32)
                        .neonGlow(color: ThemeConfig.Neon.purple, radius: 8)

                    Text("2")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }

                Text("Select Your Paper (Optional)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(ThemeConfig.Text.primary)
            }

            if let paper = viewModel.selectedPaper {
                PaperDetailView(paper: paper)

                Button("Remove Selection") {
                    viewModel.selectPaper(nil)
                }
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(ThemeConfig.Neon.magenta)
            } else if !mainViewModel.userProfile.uploadedPapers.isEmpty {
                Menu {
                    Button("No Paper") {
                        viewModel.selectPaper(nil)
                    }

                    ForEach(mainViewModel.userProfile.uploadedPapers) { paper in
                        Button(paper.title) {
                            viewModel.selectPaper(paper)
                        }
                    }
                } label: {
                    HStack {
                        Text("Select a Paper")
                            .foregroundColor(ThemeConfig.Neon.purple)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(ThemeConfig.Text.tertiary)
                    }
                    .padding(ThemeConfig.Spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                            .fill(ThemeConfig.Background.tertiary)
                            .overlay(
                                RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                                    .stroke(ThemeConfig.Neon.purple.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
            } else {
                Text("No papers uploaded yet")
                    .font(.caption)
                    .foregroundColor(ThemeConfig.Text.tertiary)
                    .padding(ThemeConfig.Spacing.md)
            }
        }
        .padding(ThemeConfig.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.lg)
                .fill(ThemeConfig.Background.elevated)
                .overlay(
                    RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.lg)
                        .stroke(ThemeConfig.Neon.purple.opacity(0.2), lineWidth: 1)
                )
        )
    }

    private var searchSection: some View {
        VStack(alignment: .leading, spacing: ThemeConfig.Spacing.md) {
            HStack(spacing: ThemeConfig.Spacing.sm) {
                ZStack {
                    Circle()
                        .fill(ThemeConfig.Gradients.neonPurpleBlue)
                        .frame(width: 32, height: 32)
                        .neonGlow(color: ThemeConfig.Neon.purple, radius: 8)

                    Text("3")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }

                Text("Search Literature")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(ThemeConfig.Text.primary)
            }

            VStack(spacing: ThemeConfig.Spacing.md) {
                // Quick Search
                Button(action: {
                    Task {
                        await viewModel.searchRelatedPapers()
                    }
                }) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .font(.title3)
                        Text("Auto Search")
                            .fontWeight(.semibold)
                        Spacer()
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.title3)
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
                .disabled(viewModel.isSearching)

                // AI Search with custom query
                HStack(spacing: ThemeConfig.Spacing.sm) {
                    TextField("Enter search query for AI search...", text: $searchQuery)
                        .textFieldStyle(.plain)
                        .foregroundColor(ThemeConfig.Text.primary)
                        .padding(ThemeConfig.Spacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                                .fill(ThemeConfig.Background.tertiary)
                                .overlay(
                                    RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                                        .stroke(ThemeConfig.Neon.purple.opacity(0.3), lineWidth: 1)
                                )
                        )

                    Button(action: {
                        Task {
                            await viewModel.searchWithAI(query: searchQuery)
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(ThemeConfig.Gradients.neonPurpleBlue)
                                .frame(width: 50, height: 50)
                                .neonGlow(color: ThemeConfig.Neon.purple, radius: 8)

                            Image(systemName: "sparkles")
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                    }
                    .disabled(searchQuery.isEmpty || viewModel.isSearching)
                }
            }

            if viewModel.isSearching {
                HStack(spacing: ThemeConfig.Spacing.sm) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: ThemeConfig.Neon.cyan))
                    Text(viewModel.searchProgress)
                        .font(.subheadline)
                        .foregroundColor(ThemeConfig.Text.secondary)
                }
                .padding(ThemeConfig.Spacing.md)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                        .fill(ThemeConfig.Background.tertiary)
                        .overlay(
                            RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                                .stroke(ThemeConfig.Neon.cyan.opacity(0.3), lineWidth: 1)
                        )
                )
            }

            // Show error inline
            if let errorMessage = viewModel.errorMessage {
                HStack(alignment: .top, spacing: ThemeConfig.Spacing.md) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.title2)
                        .foregroundColor(ThemeConfig.Neon.magenta)
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Error")
                            .font(.headline)
                            .foregroundColor(ThemeConfig.Neon.magenta)
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundColor(ThemeConfig.Text.secondary)
                    }
                }
                .padding(ThemeConfig.Spacing.md)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                        .fill(ThemeConfig.Background.elevated)
                        .overlay(
                            RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                                .stroke(ThemeConfig.Neon.magenta.opacity(0.3), lineWidth: 2)
                        )
                )
            }
        }
        .padding(ThemeConfig.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.lg)
                .fill(ThemeConfig.Background.elevated)
                .overlay(
                    RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.lg)
                        .stroke(ThemeConfig.Neon.purple.opacity(0.2), lineWidth: 1)
                )
        )
    }

    private var searchPromptSection: some View {
        HStack(spacing: ThemeConfig.Spacing.md) {
            Image(systemName: "arrow.up.circle.fill")
                .foregroundColor(ThemeConfig.Neon.neonOrange)
                .font(.title)
                .neonGlow(color: ThemeConfig.Neon.neonOrange, radius: 8)

            VStack(alignment: .leading, spacing: 6) {
                Text("Please search for papers first")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(ThemeConfig.Text.primary)

                Text("Click 'Auto Search' above to automatically find papers related to your selected field" + (viewModel.selectedPaper != nil ? " and paper" : "") + ", or use AI search with a custom query.")
                    .font(.caption)
                    .foregroundColor(ThemeConfig.Text.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(ThemeConfig.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                .fill(ThemeConfig.Background.elevated)
                .overlay(
                    RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                        .stroke(ThemeConfig.Neon.neonOrange.opacity(0.3), lineWidth: 2)
                )
        )
    }

    private var searchResultsSection: some View {
        VStack(alignment: .leading, spacing: ThemeConfig.Spacing.md) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .foregroundColor(ThemeConfig.Neon.cyan)
                    Text("Found \(viewModel.searchResults.count) Papers")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(ThemeConfig.Text.primary)
                }

                Spacer()

                Button(action: {
                    viewModel.searchResults = []
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "xmark.circle.fill")
                        Text("Clear")
                    }
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(ThemeConfig.Neon.magenta)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(ThemeConfig.Neon.magenta.opacity(0.1))
                            .overlay(
                                Capsule()
                                    .stroke(ThemeConfig.Neon.magenta.opacity(0.5), lineWidth: 1)
                            )
                    )
                }
            }

            ForEach(viewModel.searchResults.prefix(10)) { paper in
                SearchResultPaperView(paper: paper)
            }
        }
        .padding(ThemeConfig.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.lg)
                .fill(ThemeConfig.Background.elevated)
                .overlay(
                    RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.lg)
                        .stroke(ThemeConfig.Neon.cyan.opacity(0.2), lineWidth: 1)
                )
        )
    }

    private var generateSection: some View {
        VStack(alignment: .leading, spacing: ThemeConfig.Spacing.md) {
            HStack(spacing: ThemeConfig.Spacing.sm) {
                ZStack {
                    Circle()
                        .fill(ThemeConfig.Gradients.neonGreenCyan)
                        .frame(width: 32, height: 32)
                        .neonGlow(color: ThemeConfig.Neon.neonGreen, radius: 8)

                    Text("4")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }

                Text("Generate Newsletter")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(ThemeConfig.Text.primary)
            }

            Button(action: {
                Task {
                    await viewModel.generateNewsletter()
                }
            }) {
                HStack {
                    if viewModel.isGenerating {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    }
                    Text(viewModel.isGenerating ? "Generating..." : "Generate Newsletter")
                        .fontWeight(.semibold)
                    Spacer()
                    if !viewModel.isGenerating {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.title3)
                    }
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(ThemeConfig.Spacing.md)
                .frame(maxWidth: .infinity)
                .background(
                    Group {
                        if viewModel.isGenerating {
                            RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                                .fill(ThemeConfig.Background.tertiary)
                        } else {
                            RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                                .fill(ThemeConfig.Gradients.neonGreenCyan)
                        }
                    }
                )
                .neonGlow(color: viewModel.isGenerating ? Color.clear : ThemeConfig.Neon.neonGreen, radius: 12)
            }
            .disabled(viewModel.isGenerating)
        }
        .padding(ThemeConfig.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.lg)
                .fill(ThemeConfig.Background.elevated)
                .overlay(
                    RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.lg)
                        .stroke(ThemeConfig.Neon.neonGreen.opacity(0.2), lineWidth: 1)
                )
        )
    }

    private func generatedNewsletterSection(_ newsletter: Newsletter) -> some View {
        VStack(alignment: .leading, spacing: ThemeConfig.Spacing.lg) {
            HStack(spacing: ThemeConfig.Spacing.md) {
                ZStack {
                    Circle()
                        .fill(ThemeConfig.Gradients.neonGreenCyan)
                        .frame(width: 50, height: 50)
                        .neonGlow(color: ThemeConfig.Neon.neonGreen, radius: 15)

                    Image(systemName: "checkmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                }

                Text("Newsletter Generated!")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(ThemeConfig.Text.primary)
            }

            VStack(alignment: .leading, spacing: ThemeConfig.Spacing.md) {
                Text(newsletter.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(ThemeConfig.Text.primary)

                Text(newsletter.previewText)
                    .font(.subheadline)
                    .foregroundColor(ThemeConfig.Text.secondary)
                    .lineLimit(3)

                HStack(spacing: ThemeConfig.Spacing.sm) {
                    HStack(spacing: 4) {
                        Image(systemName: "doc.text.fill")
                            .font(.caption)
                        Text("\(newsletter.totalPapers) papers")
                    }
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(ThemeConfig.Neon.cyan)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(ThemeConfig.Neon.cyan.opacity(0.2))
                            .overlay(
                                Capsule()
                                    .stroke(ThemeConfig.Neon.cyan, lineWidth: 1)
                            )
                    )

                    Text(newsletter.researchField.name)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(ThemeConfig.Neon.neonGreen)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(ThemeConfig.Neon.neonGreen.opacity(0.2))
                                .overlay(
                                    Capsule()
                                        .stroke(ThemeConfig.Neon.neonGreen, lineWidth: 1)
                                )
                        )
                }
            }
            .padding(ThemeConfig.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                    .fill(ThemeConfig.Background.tertiary)
                    .overlay(
                        RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                            .stroke(ThemeConfig.Neon.neonGreen.opacity(0.3), lineWidth: 1)
                    )
            )

            Button(action: {
                mainViewModel.selectedTab = .newsletters
                dismiss()
            }) {
                HStack {
                    Text("View Newsletter")
                        .fontWeight(.semibold)
                    Spacer()
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.title3)
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(ThemeConfig.Spacing.md)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                        .fill(ThemeConfig.Gradients.neonCyanMagenta)
                )
                .neonGlow(color: ThemeConfig.Neon.cyan, radius: 12)
            }
        }
        .padding(ThemeConfig.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.xl)
                .fill(ThemeConfig.Background.elevated)
                .overlay(
                    RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.xl)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    ThemeConfig.Neon.neonGreen.opacity(0.6),
                                    ThemeConfig.Neon.cyan.opacity(0.6)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
        )
        .shadow(color: ThemeConfig.Shadows.greenGlow, radius: 25, x: 0, y: 12)
    }
}

// MARK: - Supporting Views

struct FieldBadgeView: View {
    let field: ResearchField
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: ThemeConfig.Spacing.md) {
            VStack(alignment: .leading, spacing: 4) {
                Text(field.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(ThemeConfig.Text.primary)

                Text(field.description)
                    .font(.caption)
                    .foregroundColor(ThemeConfig.Text.secondary)
            }

            Spacer()

            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title3)
                    .foregroundColor(ThemeConfig.Neon.magenta)
            }
        }
        .padding(ThemeConfig.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                .fill(ThemeConfig.Background.tertiary)
                .overlay(
                    RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                        .stroke(ThemeConfig.Neon.cyan.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct SearchResultPaperView: View {
    let paper: Paper

    var body: some View {
        VStack(alignment: .leading, spacing: ThemeConfig.Spacing.sm) {
            Text(paper.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(ThemeConfig.Text.primary)

            HStack(spacing: 4) {
                Image(systemName: "person.2.fill")
                    .font(.caption2)
                Text(paper.formattedAuthors)
                    .font(.caption)
            }
            .foregroundColor(ThemeConfig.Text.secondary)

            if let abstract = paper.abstract {
                Text(abstract)
                    .font(.caption2)
                    .foregroundColor(ThemeConfig.Text.tertiary)
                    .lineLimit(3)
            }

            HStack(spacing: 6) {
                if let score = paper.relevanceScore {
                    HStack(spacing: 3) {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                        Text("\(Int(score * 100))%")
                    }
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(ThemeConfig.Neon.neonGreen)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(ThemeConfig.Neon.neonGreen.opacity(0.2))
                            .overlay(
                                Capsule()
                                    .stroke(ThemeConfig.Neon.neonGreen.opacity(0.5), lineWidth: 1)
                            )
                    )
                }

                if paper.publicationDate != nil {
                    HStack(spacing: 3) {
                        Image(systemName: "calendar")
                            .font(.caption2)
                        Text(paper.formattedDate)
                    }
                    .font(.caption2)
                    .foregroundColor(ThemeConfig.Text.tertiary)
                }
            }
        }
        .padding(ThemeConfig.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                .fill(ThemeConfig.Background.tertiary)
                .overlay(
                    RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    ThemeConfig.Neon.cyan.opacity(0.2),
                                    ThemeConfig.Neon.purple.opacity(0.2)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 1
                        )
                )
        )
    }
}

#Preview {
    NewsletterGenerationView()
        .environmentObject(MainViewModel())
}
