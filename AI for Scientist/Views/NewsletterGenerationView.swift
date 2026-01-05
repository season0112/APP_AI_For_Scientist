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
            ScrollView {
                VStack(spacing: 20) {
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
            .navigationTitle("Generate Newsletter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
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
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "1.circle.fill")
                    .foregroundColor(.blue)
                Text("Select Research Field")
                    .font(.headline)
            }

            if let field = viewModel.selectedField {
                FieldBadgeView(field: field) {
                    viewModel.selectField(nil)
                }
            } else {
                // Show preferred fields if available
                if !mainViewModel.userProfile.preferredFields.isEmpty {
                    VStack(spacing: 10) {
                        ForEach(mainViewModel.userProfile.preferredFields) { field in
                            Button(action: {
                                viewModel.selectField(field)
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(field.name)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.primary)

                                        Text(field.description)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.blue)
                                }
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }

                        Button(action: { showFieldSelection = true }) {
                            HStack {
                                Image(systemName: "plus.circle")
                                Text("Manage Fields")
                                    .font(.caption)
                            }
                            .foregroundColor(.blue)
                        }
                    }
                } else {
                    Button(action: { showFieldSelection = true }) {
                        HStack {
                            Text("Choose Field")
                                .foregroundColor(.blue)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
            }
        }
    }

    private var paperSelectionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "2.circle.fill")
                    .foregroundColor(.blue)
                Text("Select Your Paper (Optional)")
                    .font(.headline)
            }

            if let paper = viewModel.selectedPaper {
                PaperDetailView(paper: paper)

                Button("Remove Selection") {
                    viewModel.selectPaper(nil)
                }
                .font(.caption)
                .foregroundColor(.red)
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
                            .foregroundColor(.blue)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
            } else {
                Text("No papers uploaded yet")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
    }

    private var searchSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "3.circle.fill")
                    .foregroundColor(.blue)
                Text("Search Literature")
                    .font(.headline)
            }

            VStack(spacing: 10) {
                // Quick Search
                Button(action: {
                    Task {
                        await viewModel.searchRelatedPapers()
                    }
                }) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("Auto Search")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                .disabled(viewModel.isSearching)

                // AI Search with custom query
                HStack {
                    TextField("Enter search query for AI search...", text: $searchQuery)
                        .textFieldStyle(.roundedBorder)

                    Button(action: {
                        Task {
                            await viewModel.searchWithAI(query: searchQuery)
                        }
                    }) {
                        Image(systemName: "sparkles")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.purple)
                            .cornerRadius(8)
                    }
                    .disabled(searchQuery.isEmpty || viewModel.isSearching)
                }
            }

            if viewModel.isSearching {
                HStack {
                    ProgressView()
                    Text(viewModel.searchProgress)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            // Show error inline
            if let errorMessage = viewModel.errorMessage {
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Error")
                            .font(.headline)
                            .foregroundColor(.red)
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(10)
            }
        }
    }

    private var searchPromptSection: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "arrow.up")
                    .foregroundColor(.orange)
                    .font(.title2)
                Text("Please search for papers first")
                    .font(.subheadline)
                    .foregroundColor(.orange)
                Spacer()
            }

            Text("Click 'Auto Search' above to automatically find papers related to your selected field" + (viewModel.selectedPaper != nil ? " and paper" : "") + ", or use AI search with a custom query.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(10)
    }

    private var searchResultsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Found \(viewModel.searchResults.count) Papers")
                    .font(.headline)

                Spacer()

                Button("Clear") {
                    viewModel.searchResults = []
                }
                .font(.caption)
                .foregroundColor(.red)
            }

            ForEach(viewModel.searchResults.prefix(10)) { paper in
                SearchResultPaperView(paper: paper)
            }
        }
    }

    private var generateSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "4.circle.fill")
                    .foregroundColor(.blue)
                Text("Generate Newsletter")
                    .font(.headline)
            }

            Button(action: {
                Task {
                    await viewModel.generateNewsletter()
                }
            }) {
                HStack {
                    if viewModel.isGenerating {
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                    Text(viewModel.isGenerating ? "Generating..." : "Generate Newsletter")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.isGenerating ? Color.gray : Color.green)
                .cornerRadius(10)
            }
            .disabled(viewModel.isGenerating)
        }
    }

    private func generatedNewsletterSection(_ newsletter: Newsletter) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.title2)

                Text("Newsletter Generated!")
                    .font(.headline)
            }

            VStack(alignment: .leading, spacing: 10) {
                Text(newsletter.title)
                    .font(.title3)
                    .fontWeight(.bold)

                Text(newsletter.previewText)
                    .font(.caption)
                    .foregroundColor(.secondary)

                HStack {
                    Text("\(newsletter.totalPapers) papers")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(4)

                    Text(newsletter.researchField.name)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(4)
                }
            }
            .padding()
            .background(Color.green.opacity(0.1))
            .cornerRadius(10)

            Button("View Newsletter") {
                mainViewModel.selectedTab = .newsletters
                dismiss()
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
        }
    }
}

// MARK: - Supporting Views

struct FieldBadgeView: View {
    let field: ResearchField
    let onRemove: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(field.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text(field.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(8)
    }
}

struct SearchResultPaperView: View {
    let paper: Paper

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(paper.title)
                .font(.subheadline)
                .fontWeight(.semibold)

            Text(paper.formattedAuthors)
                .font(.caption)
                .foregroundColor(.secondary)

            if let abstract = paper.abstract {
                Text(abstract)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }

            HStack {
                if let score = paper.relevanceScore {
                    Text("Relevance: \(Int(score * 100))%")
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(4)
                }

                if paper.publicationDate != nil {
                    Text(paper.formattedDate)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(8)
    }
}

#Preview {
    NewsletterGenerationView()
        .environmentObject(MainViewModel())
}
