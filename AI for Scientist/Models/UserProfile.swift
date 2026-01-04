//
//  UserProfile.swift
//  AI for Scientist
//
//  Model representing user preferences and subscriptions
//

import Foundation

/// Represents user profile with research preferences
struct UserProfile: Identifiable, Codable {
    let id: UUID
    var preferredFields: [ResearchField]
    var uploadedPapers: [Paper]
    var savedNewsletters: [Newsletter]
    var notificationEnabled: Bool
    var notificationFrequency: NotificationFrequency

    init(
        id: UUID = UUID(),
        preferredFields: [ResearchField] = [],
        uploadedPapers: [Paper] = [],
        savedNewsletters: [Newsletter] = [],
        notificationEnabled: Bool = true,
        notificationFrequency: NotificationFrequency = .weekly
    ) {
        self.id = id
        self.preferredFields = preferredFields
        self.uploadedPapers = uploadedPapers
        self.savedNewsletters = savedNewsletters
        self.notificationEnabled = notificationEnabled
        self.notificationFrequency = notificationFrequency
    }
}

/// Notification frequency options
enum NotificationFrequency: String, Codable, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case biweekly = "Bi-weekly"
    case monthly = "Monthly"
}

// MARK: - User Profile Helpers
extension UserProfile {
    /// Check if user has completed initial setup
    var isProfileComplete: Bool {
        return !preferredFields.isEmpty
    }

    /// Get all unique keywords from preferred fields
    var allKeywords: [String] {
        return Array(Set(preferredFields.flatMap { $0.keywords }))
    }
}
