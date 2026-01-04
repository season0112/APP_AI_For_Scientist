//
//  AppConfig.swift
//  AI for Scientist
//
//  Application configuration and constants
//

import Foundation

/// Application-wide configuration
enum AppConfig {
    // MARK: - API Configuration

    /// Base URL for arXiv API
    static let arxivAPIBaseURL = "https://export.arxiv.org/api/query"

    /// Maximum number of search results
    static let maxSearchResults = 50

    /// Search request timeout (seconds)
    static let searchTimeout: TimeInterval = 30

    // MARK: - Claude Agent Configuration

    /// Path to Claude agents directory
    static let agentsDirectory = ".claude/agents"

    /// Path to Claude commands directory
    static let commandsDirectory = ".claude/commands"

    /// Path to Claude skills directory
    static let skillsDirectory = ".claude/skills"

    /// Default agent for literature search
    /// Configure this agent in .claude/agents/literature-search.json
    static let literatureSearchAgent = "literature-search"

    /// Default agent for newsletter generation
    /// Configure this agent in .claude/agents/newsletter-generator.json
    static let newsletterGeneratorAgent = "newsletter-generator"

    // MARK: - File Storage

    /// Directory name for storing uploaded papers
    static let papersDirectory = "Papers"

    /// Directory name for storing generated newsletters
    static let newslettersDirectory = "Newsletters"

    /// Maximum PDF file size (10 MB)
    static let maxPDFSize: Int64 = 10 * 1024 * 1024

    // MARK: - PDF Processing

    /// Maximum number of characters to extract from abstract
    static let maxAbstractLength = 2000

    /// Maximum number of keywords to extract
    static let maxKeywords = 10

    // MARK: - UI Configuration

    /// Number of papers to show in recent list
    static let recentPapersCount = 3

    /// Number of newsletters to show in recent list
    static let recentNewslettersCount = 3

    /// Debounce delay for search input (seconds)
    static let searchDebounceDelay: TimeInterval = 0.5

    // MARK: - Newsletter Configuration

    /// Default number of related papers to include in newsletter
    static let defaultRelatedPapersCount = 15

    /// Minimum relevance score to include paper
    static let minRelevanceScore: Double = 0.3

    // MARK: - Feature Flags

    /// Enable AI agent integration
    static let enableAIAgents = true

    /// Enable offline mode
    static let enableOfflineMode = false

    /// Enable analytics
    static let enableAnalytics = false
}

// MARK: - Agent Configuration Helper
extension AppConfig {
    /// Get path to agent configuration file
    static func agentConfigPath(for agentName: String) -> String {
        return "\(agentsDirectory)/\(agentName).json"
    }

    /// Get path to command file
    static func commandPath(for commandName: String) -> String {
        return "\(commandsDirectory)/\(commandName).md"
    }

    /// Get path to skill file
    static func skillPath(for skillName: String) -> String {
        return "\(skillsDirectory)/\(skillName).json"
    }
}

// MARK: - Environment Helper
extension AppConfig {
    /// Check if running in debug mode
    static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    /// Check if running in simulator
    static var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
}
