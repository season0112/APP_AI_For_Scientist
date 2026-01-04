//
//  Paper.swift
//  AI for Scientist
//
//  Model representing a scientific paper (uploaded or searched)
//

import Foundation

/// Represents a scientific paper with metadata
struct Paper: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let authors: [String]
    let abstract: String?
    let publicationDate: Date?
    let arxivId: String?
    let pdfURL: URL?
    let localPDFPath: URL?
    let keywords: [String]
    let researchField: String?

    /// Indicates if this paper was uploaded by the user
    let isUserUploaded: Bool

    /// Relevance score (0.0 - 1.0) when returned from search
    let relevanceScore: Double?

    init(
        id: UUID = UUID(),
        title: String,
        authors: [String],
        abstract: String? = nil,
        publicationDate: Date? = nil,
        arxivId: String? = nil,
        pdfURL: URL? = nil,
        localPDFPath: URL? = nil,
        keywords: [String] = [],
        researchField: String? = nil,
        isUserUploaded: Bool = false,
        relevanceScore: Double? = nil
    ) {
        self.id = id
        self.title = title
        self.authors = authors
        self.abstract = abstract
        self.publicationDate = publicationDate
        self.arxivId = arxivId
        self.pdfURL = pdfURL
        self.localPDFPath = localPDFPath
        self.keywords = keywords
        self.researchField = researchField
        self.isUserUploaded = isUserUploaded
        self.relevanceScore = relevanceScore
    }
}

// MARK: - Computed Properties
extension Paper {
    /// Formatted author list (e.g., "Smith et al." or "Smith and Jones")
    var formattedAuthors: String {
        guard !authors.isEmpty else { return "Unknown authors" }

        if authors.count == 1 {
            return authors[0]
        } else if authors.count == 2 {
            return "\(authors[0]) and \(authors[1])"
        } else {
            return "\(authors[0]) et al."
        }
    }

    /// Formatted publication date
    var formattedDate: String {
        guard let date = publicationDate else { return "Date unknown" }

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    /// Short abstract preview (first 150 characters)
    var abstractPreview: String {
        guard let abstract = abstract else { return "No abstract available" }

        if abstract.count <= 150 {
            return abstract
        } else {
            let index = abstract.index(abstract.startIndex, offsetBy: 150)
            return String(abstract[..<index]) + "..."
        }
    }
}
