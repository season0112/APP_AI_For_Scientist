//
//  MainViewModel.swift
//  AI for Scientist
//
//  Main ViewModel coordinating app state and user profile
//

import Foundation
import Combine

/// Main ViewModel managing overall app state
@MainActor
class MainViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var userProfile: UserProfile
    @Published var selectedTab: AppTab = .home
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false

    // MARK: - Private Properties

    private var cancellables = Set<AnyCancellable>()
    private let userDefaultsKey = "userProfile"

    // MARK: - Initialization

    init() {
        // Load user profile from storage or create new
        if let savedProfile = Self.loadUserProfile() {
            self.userProfile = savedProfile
        } else {
            self.userProfile = UserProfile()
        }
    }

    // MARK: - User Profile Management

    /// Update user's preferred research fields
    func updatePreferredFields(_ fields: [ResearchField]) {
        userProfile.preferredFields = fields
        saveUserProfile()
    }

    /// Add uploaded paper to user profile
    func addUploadedPaper(_ paper: Paper) {
        userProfile.uploadedPapers.append(paper)
        saveUserProfile()
    }

    /// Remove uploaded paper
    func removeUploadedPaper(_ paper: Paper) {
        userProfile.uploadedPapers.removeAll { $0.id == paper.id }
        saveUserProfile()
    }

    /// Add newsletter to saved newsletters
    func saveNewsletter(_ newsletter: Newsletter) async {
        print("📰 [MainViewModel] Saving newsletter: \(newsletter.title)")
        userProfile.savedNewsletters.append(newsletter)
        saveUserProfile()
        print("📰 [MainViewModel] Saved to user profile, total newsletters: \(userProfile.savedNewsletters.count)")

        // Also persist to file system
        do {
            try await NewsletterService.shared.saveNewsletter(newsletter)
            print("✅ [MainViewModel] Successfully saved newsletter to file system")
        } catch {
            print("❌ [MainViewModel] Failed to save newsletter to file system: \(error)")
            handleError(error)
        }
    }

    /// Update notification settings
    func updateNotificationSettings(enabled: Bool, frequency: NotificationFrequency) {
        userProfile.notificationEnabled = enabled
        userProfile.notificationFrequency = frequency
        saveUserProfile()
    }

    // MARK: - Private Methods

    private func saveUserProfile() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(userProfile)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            print("Failed to save user profile: \(error)")
        }
    }

    private static func loadUserProfile() -> UserProfile? {
        guard let data = UserDefaults.standard.data(forKey: "userProfile") else {
            return nil
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(UserProfile.self, from: data)
        } catch {
            print("Failed to load user profile: \(error)")
            return nil
        }
    }

    // MARK: - Error Handling

    func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        showError = true
        isLoading = false
    }

    func clearError() {
        errorMessage = nil
        showError = false
    }
}

// MARK: - App Tabs
enum AppTab: String, CaseIterable {
    case home = "Home"
    case upload = "Upload"
    case newsletters = "Newsletters"
    case settings = "Settings"

    var systemImage: String {
        switch self {
        case .home:
            return "house.fill"
        case .upload:
            return "arrow.up.doc.fill"
        case .newsletters:
            return "envelope.fill"
        case .settings:
            return "gear"
        }
    }
}
