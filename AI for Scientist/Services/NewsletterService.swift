//
//  NewsletterService.swift
//  AI for Scientist
//
//  Service for generating customized newsletters using AI
//

import Foundation

/// Service responsible for generating newsletters
class NewsletterService {
    static let shared = NewsletterService()

    private init() {}

    // MARK: - Newsletter Generation

    /// Generate a newsletter from user paper and related papers
    /// - Parameters:
    ///   - userPaper: User's uploaded paper
    ///   - relatedPapers: Related papers found through search
    ///   - field: Research field
    /// - Returns: Generated newsletter
    func generateNewsletter(
        userPaper: Paper?,
        relatedPapers: [Paper],
        field: ResearchField
    ) async throws -> Newsletter {

        // Generate title
        let title = generateTitle(field: field, userPaper: userPaper)

        // Generate summary using AI
        let summary = try await generateSummary(
            userPaper: userPaper,
            relatedPapers: relatedPapers,
            field: field
        )

        // Create newsletter object
        var newsletter = Newsletter(
            title: title,
            researchField: field,
            userPaper: userPaper,
            relatedPapers: relatedPapers,
            summary: summary,
            status: .generating
        )

        // Generate HTML content
        let htmlContent = newsletter.generateHTMLContent()

        // Generate PDF (optional)
        let pdfURL = try? await PDFService.shared.generatePDF(
            from: htmlContent,
            filename: "newsletter_\(newsletter.id.uuidString)"
        )

        // Update newsletter with generated content
        newsletter = Newsletter(
            id: newsletter.id,
            title: newsletter.title,
            generatedDate: newsletter.generatedDate,
            researchField: newsletter.researchField,
            userPaper: newsletter.userPaper,
            relatedPapers: newsletter.relatedPapers,
            summary: newsletter.summary,
            htmlContent: htmlContent,
            pdfURL: pdfURL,
            status: .completed
        )

        return newsletter
    }

    // MARK: - AI Summary Generation (Placeholder)

    /// Generate AI summary of papers
    /// This method demonstrates integration with Claude agents/skills
    /// - Parameters:
    ///   - userPaper: User's paper
    ///   - relatedPapers: Related papers
    ///   - field: Research field
    /// - Returns: Generated summary text
    private func generateSummary(
        userPaper: Paper?,
        relatedPapers: [Paper],
        field: ResearchField
    ) async throws -> String {

        // PLACEHOLDER: Integration with Claude agents/skills
        // In production, this would call your configured agent:
        //
        // Example integration pattern:
        // 1. Load agent/skill configuration from .claude/agents/newsletter-generator.json
        // 2. Prepare prompt with paper abstracts and metadata
        // 3. Call agent API with summarization request
        // 4. Parse and return summary
        //
        // Example prompt structure:
        // """
        // Generate a newsletter summary for research in \(field.name).
        //
        // User's paper: \(userPaper?.title ?? "N/A")
        // Abstract: \(userPaper?.abstract ?? "N/A")
        //
        // Related papers:
        // \(relatedPapers.map { "- \($0.title): \($0.abstractPreview)" }.joined(separator: "\n"))
        //
        // Please provide:
        // 1. Overview of the research area
        // 2. Key findings from the related papers
        // 3. How these papers relate to each other
        // 4. Suggested reading order
        // """

        // For now, generate a basic summary
        return generateBasicSummary(userPaper: userPaper, relatedPapers: relatedPapers, field: field)
    }

    private func generateBasicSummary(
        userPaper: Paper?,
        relatedPapers: [Paper],
        field: ResearchField
    ) -> String {
        var summary = "This newsletter curates recent research in \(field.name). "

        if let userPaper = userPaper {
            summary += "Based on your paper '\(userPaper.title)', we've identified \(relatedPapers.count) related publications. "
        } else {
            summary += "We've identified \(relatedPapers.count) recent publications in this field. "
        }

        if !relatedPapers.isEmpty {
            summary += "The papers cover topics including: "

            // Collect common keywords
            let allKeywords = relatedPapers.flatMap { $0.keywords }
            let keywordCounts = Dictionary(grouping: allKeywords) { $0 }
                .mapValues { $0.count }
                .sorted { $0.value > $1.value }

            let topKeywords = Array(keywordCounts.prefix(5).map { $0.key })
            summary += topKeywords.joined(separator: ", ") + ". "
        }

        summary += "These papers represent cutting-edge research and may provide valuable insights for your work."

        return summary
    }

    private func generateTitle(field: ResearchField, userPaper: Paper?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let dateString = dateFormatter.string(from: Date())

        if let paper = userPaper {
            return "\(field.name) Newsletter - \(dateString) - Related to '\(paper.title)'"
        } else {
            return "\(field.name) Newsletter - \(dateString)"
        }
    }

    // MARK: - Newsletter Storage

    /// Save newsletter to local storage
    /// - Parameter newsletter: Newsletter to save
    func saveNewsletter(_ newsletter: Newsletter) async throws {
        print("💾 [NewsletterService] Saving newsletter \(newsletter.id.uuidString)...")

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        let data = try encoder.encode(newsletter)

        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let newslettersDirectory = documentsPath.appendingPathComponent("Newsletters", isDirectory: true)

        try FileManager.default.createDirectory(at: newslettersDirectory, withIntermediateDirectories: true)

        let fileURL = newslettersDirectory.appendingPathComponent("\(newsletter.id.uuidString).json")
        print("💾 [NewsletterService] Saving to: \(fileURL.path)")

        try data.write(to: fileURL)
        print("✅ [NewsletterService] Successfully saved newsletter file")
    }

    /// Load all saved newsletters
    /// - Returns: Array of saved newsletters
    func loadNewsletters() async throws -> [Newsletter] {
        print("📂 [NewsletterService] Loading newsletters from file system...")

        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let newslettersDirectory = documentsPath.appendingPathComponent("Newsletters", isDirectory: true)

        print("📂 [NewsletterService] Newsletters directory: \(newslettersDirectory.path)")

        guard FileManager.default.fileExists(atPath: newslettersDirectory.path) else {
            print("⚠️ [NewsletterService] Newsletters directory does not exist")
            return []
        }

        let files = try FileManager.default.contentsOfDirectory(
            at: newslettersDirectory,
            includingPropertiesForKeys: nil
        ).filter { $0.pathExtension == "json" }

        print("📂 [NewsletterService] Found \(files.count) JSON files")

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        var newsletters: [Newsletter] = []

        for file in files {
            do {
                print("📄 [NewsletterService] Loading file: \(file.lastPathComponent)")
                let data = try Data(contentsOf: file)
                let newsletter = try decoder.decode(Newsletter.self, from: data)
                newsletters.append(newsletter)
                print("✅ [NewsletterService] Successfully loaded newsletter: \(newsletter.title)")
            } catch {
                print("❌ [NewsletterService] Failed to load newsletter from \(file.lastPathComponent): \(error)")
            }
        }

        print("📋 [NewsletterService] Total newsletters loaded: \(newsletters.count)")
        return newsletters.sorted { $0.generatedDate > $1.generatedDate }
    }

    /// Delete a newsletter
    /// - Parameter newsletter: Newsletter to delete
    func deleteNewsletter(_ newsletter: Newsletter) async throws {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let newslettersDirectory = documentsPath.appendingPathComponent("Newsletters", isDirectory: true)
        let fileURL = newslettersDirectory.appendingPathComponent("\(newsletter.id.uuidString).json")

        try FileManager.default.removeItem(at: fileURL)

        // Also delete PDF/HTML if exists
        if let pdfURL = newsletter.pdfURL {
            try? FileManager.default.removeItem(at: pdfURL)
        }
    }
}

// MARK: - Newsletter Errors
enum NewsletterError: LocalizedError {
    case generationFailed
    case saveFailed
    case loadFailed

    var errorDescription: String? {
        switch self {
        case .generationFailed:
            return "Failed to generate newsletter"
        case .saveFailed:
            return "Failed to save newsletter"
        case .loadFailed:
            return "Failed to load newsletters"
        }
    }
}
