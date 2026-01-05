//
//  NewsletterListViewModel.swift
//  AI for Scientist
//
//  ViewModel for displaying and managing saved newsletters
//

import Foundation
import Combine

/// ViewModel managing newsletter list and viewing
@MainActor
class NewsletterListViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var newsletters: [Newsletter] = []
    @Published var selectedNewsletter: Newsletter?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false

    // MARK: - Dependencies

    private let newsletterService = NewsletterService.shared
    private let mainViewModel: MainViewModel

    // MARK: - Initialization

    init(mainViewModel: MainViewModel) {
        self.mainViewModel = mainViewModel
    }

    // MARK: - Newsletter Management

    /// Load all saved newsletters
    func loadNewsletters() async {
        print("📋 [NewsletterList] Loading newsletters...")
        isLoading = true
        clearError()

        do {
            newsletters = try await newsletterService.loadNewsletters()
            print("✅ [NewsletterList] Loaded \(newsletters.count) newsletters")
            isLoading = false
        } catch {
            print("❌ [NewsletterList] Failed to load newsletters: \(error)")
            handleError(error)
        }
    }

    /// Delete a newsletter
    func deleteNewsletter(_ newsletter: Newsletter) async {
        do {
            try await newsletterService.deleteNewsletter(newsletter)
            newsletters.removeAll { $0.id == newsletter.id }

            // Also remove from main view model
            mainViewModel.userProfile.savedNewsletters.removeAll { $0.id == newsletter.id }

        } catch {
            handleError(error)
        }
    }

    /// Share newsletter (export HTML/PDF)
    func shareNewsletter(_ newsletter: Newsletter) -> URL? {
        return newsletter.pdfURL
    }

    /// Select newsletter for viewing
    func selectNewsletter(_ newsletter: Newsletter) {
        selectedNewsletter = newsletter
    }

    // MARK: - Error Handling

    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        showError = true
        isLoading = false
    }

    private func clearError() {
        errorMessage = nil
        showError = false
    }
}
