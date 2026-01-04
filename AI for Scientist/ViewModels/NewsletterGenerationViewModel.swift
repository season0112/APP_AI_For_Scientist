//
//  NewsletterGenerationViewModel.swift
//  AI for Scientist
//
//  ViewModel for newsletter generation workflow
//

import Foundation
import Combine

/// ViewModel managing newsletter generation process
@MainActor
class NewsletterGenerationViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var selectedField: ResearchField?
    @Published var selectedPaper: Paper?
    @Published var searchResults: [Paper] = []
    @Published var isSearching: Bool = false
    @Published var isGenerating: Bool = false
    @Published var generatedNewsletter: Newsletter?
    @Published var searchProgress: String = ""
    @Published var errorMessage: String?
    @Published var showError: Bool = false

    // MARK: - Dependencies

    private let searchService = LiteratureSearchService.shared
    private let newsletterService = NewsletterService.shared
    private let mainViewModel: MainViewModel

    // MARK: - Initialization

    init(mainViewModel: MainViewModel) {
        self.mainViewModel = mainViewModel
    }

    // MARK: - Search Workflow

    /// Search for related papers based on user's paper and selected field
    func searchRelatedPapers() async {
        guard let field = selectedField else {
            handleError(NSError(domain: "NewsletterGeneration", code: 1, userInfo: [NSLocalizedDescriptionKey: "Please select a research field"]))
            return
        }

        isSearching = true
        searchProgress = "Searching literature..."
        clearError()

        do {
            if let paper = selectedPaper {
                // Search based on user's paper
                searchProgress = "Finding papers related to '\(paper.title)'..."
                searchResults = try await searchService.searchRelatedPapers(for: paper, maxResults: 15)
            } else {
                // Search based on field keywords
                searchProgress = "Searching \(field.name) literature..."
                searchResults = try await searchService.searchArXiv(
                    keywords: field.keywords,
                    field: field,
                    maxResults: 20
                )
            }

            searchProgress = "Found \(searchResults.count) papers"
            isSearching = false

        } catch {
            handleError(error)
        }
    }

    /// Search using AI agent with natural language query
    func searchWithAI(query: String) async {
        isSearching = true
        searchProgress = "AI is searching literature..."
        clearError()

        do {
            let context = selectedPaper?.abstract
            searchResults = try await searchService.searchWithAIAgent(query: query, context: context)

            searchProgress = "Found \(searchResults.count) papers"
            isSearching = false

        } catch {
            handleError(error)
        }
    }

    // MARK: - Newsletter Generation

    /// Generate newsletter from search results
    func generateNewsletter() async {
        guard let field = selectedField else {
            handleError(NSError(domain: "NewsletterGeneration", code: 2, userInfo: [NSLocalizedDescriptionKey: "Please select a research field"]))
            return
        }

        guard !searchResults.isEmpty else {
            handleError(NSError(domain: "NewsletterGeneration", code: 3, userInfo: [NSLocalizedDescriptionKey: "No papers found. Please search first."]))
            return
        }

        isGenerating = true
        clearError()

        do {
            let newsletter = try await newsletterService.generateNewsletter(
                userPaper: selectedPaper,
                relatedPapers: searchResults,
                field: field
            )

            generatedNewsletter = newsletter

            // Save to main view model
            await mainViewModel.saveNewsletter(newsletter)

            isGenerating = false

        } catch {
            handleError(error)
        }
    }

    // MARK: - State Management

    /// Reset generation state
    func reset() {
        selectedField = nil
        selectedPaper = nil
        searchResults = []
        generatedNewsletter = nil
        searchProgress = ""
        clearError()
    }

    /// Select a research field
    func selectField(_ field: ResearchField) {
        selectedField = field
    }

    /// Select a paper (from uploaded papers)
    func selectPaper(_ paper: Paper?) {
        selectedPaper = paper
    }

    // MARK: - Error Handling

    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        showError = true
        isSearching = false
        isGenerating = false
    }

    private func clearError() {
        errorMessage = nil
        showError = false
    }
}
