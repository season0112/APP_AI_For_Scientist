//
//  LiteratureSearchService.swift
//  AI for Scientist
//
//  Service for searching scientific literature using AI agents
//  Integrates with Claude agents/skills for intelligent search
//

import Foundation

/// Service responsible for searching and retrieving scientific literature
class LiteratureSearchService {
    static let shared = LiteratureSearchService()

    private let arxivBaseURL = "https://export.arxiv.org/api/query"
    private let session: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        self.session = URLSession(configuration: config)
    }

    // MARK: - Literature Search

    /// Search for papers on arXiv based on keywords and field
    /// - Parameters:
    ///   - keywords: Search keywords
    ///   - field: Research field
    ///   - maxResults: Maximum number of results
    /// - Returns: Array of found papers
    func searchArXiv(keywords: [String], field: ResearchField, maxResults: Int = 20) async throws -> [Paper] {
        // Construct search query
        let searchTerms = (keywords + field.keywords).joined(separator: "+OR+")
        let queryString = "search_query=all:\(searchTerms)&start=0&max_results=\(maxResults)&sortBy=submittedDate&sortOrder=descending"

        guard var components = URLComponents(string: arxivBaseURL) else {
            throw SearchError.invalidURL
        }

        components.percentEncodedQuery = queryString

        guard let url = components.url else {
            throw SearchError.invalidURL
        }

        // Perform request
        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw SearchError.networkError
        }

        // Parse arXiv XML response
        let papers = try parseArXivResponse(data)

        return papers
    }

    /// Search for papers related to a user's uploaded paper
    /// Uses AI agents to find semantically similar papers
    /// - Parameters:
    ///   - paper: User's uploaded paper
    ///   - maxResults: Maximum number of results
    /// - Returns: Array of related papers
    func searchRelatedPapers(for paper: Paper, maxResults: Int = 15) async throws -> [Paper] {
        // Extract keywords from paper
        var searchKeywords = paper.keywords

        // Add keywords from title
        let titleWords = extractImportantWords(from: paper.title)
        searchKeywords.append(contentsOf: titleWords)

        // Add keywords from abstract if available
        if let abstract = paper.abstract {
            let abstractWords = extractImportantWords(from: abstract)
            searchKeywords.append(contentsOf: Array(abstractWords.prefix(5)))
        }

        // Remove duplicates
        searchKeywords = Array(Set(searchKeywords))

        // Determine research field
        let field = determineField(from: searchKeywords)

        // Search arXiv
        let results = try await searchArXiv(keywords: searchKeywords, field: field, maxResults: maxResults)

        // Calculate relevance scores
        return results.map { result in
            let relevance = calculateRelevance(between: paper, and: result)
            return Paper(
                id: result.id,
                title: result.title,
                authors: result.authors,
                abstract: result.abstract,
                publicationDate: result.publicationDate,
                arxivId: result.arxivId,
                pdfURL: result.pdfURL,
                localPDFPath: result.localPDFPath,
                keywords: result.keywords,
                researchField: result.researchField,
                isUserUploaded: false,
                relevanceScore: relevance
            )
        }.sorted { ($0.relevanceScore ?? 0) > ($1.relevanceScore ?? 0) }
    }

    // MARK: - AI Agent Integration (Placeholder)

    /// Call Claude agent for intelligent paper search
    /// This method demonstrates how to integrate with Claude agents/skills
    /// Usage: Configure your .claude/agents/ or .claude/skills/ and call this method
    /// - Parameters:
    ///   - query: Natural language query
    ///   - context: Additional context (e.g., user's paper abstract)
    /// - Returns: Array of papers found by AI agent
    func searchWithAIAgent(query: String, context: String? = nil) async throws -> [Paper] {
        // PLACEHOLDER: Integration with Claude agents
        // In production, this would call your configured agent:
        //
        // Example integration pattern:
        // 1. Load agent configuration from .claude/agents/literature-search.json
        // 2. Prepare prompt with query and context
        // 3. Call agent API endpoint
        // 4. Parse agent response into Paper objects
        //
        // For now, fall back to keyword-based search
        let keywords = extractImportantWords(from: query)
        let field = determineField(from: keywords)

        return try await searchArXiv(keywords: keywords, field: field, maxResults: 20)
    }

    // MARK: - Private Helpers

    private func parseArXivResponse(_ data: Data) throws -> [Paper] {
        let parser = ArXivXMLParser()
        return try parser.parse(data)
    }

    private func extractImportantWords(from text: String) -> [String] {
        // Remove common stop words
        let stopWords = Set(["the", "a", "an", "and", "or", "but", "in", "on", "at", "to", "for", "of", "with", "by"])

        let words = text
            .lowercased()
            .components(separatedBy: .punctuationCharacters)
            .joined(separator: " ")
            .components(separatedBy: .whitespaces)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { $0.count > 3 && !stopWords.contains($0) }

        return Array(Set(words))
    }

    private func determineField(from keywords: [String]) -> ResearchField {
        // Simple heuristic: match keywords to predefined fields
        for field in ResearchField.predefinedFields {
            let matchCount = keywords.filter { keyword in
                field.keywords.contains { $0.lowercased().contains(keyword.lowercased()) }
            }.count

            if matchCount > 0 {
                return field
            }
        }

        // Default to Computer Science
        return ResearchField.predefinedFields.first { $0.name == "Computer Science" }!
    }

    private func calculateRelevance(between paper1: Paper, and paper2: Paper) -> Double {
        var score: Double = 0.0

        // Compare keywords
        let keywords1 = Set(paper1.keywords.map { $0.lowercased() })
        let keywords2 = Set(paper2.keywords.map { $0.lowercased() })
        let commonKeywords = keywords1.intersection(keywords2).count

        if !keywords1.isEmpty {
            score += Double(commonKeywords) / Double(keywords1.count) * 0.5
        }

        // Compare title words
        let titleWords1 = Set(extractImportantWords(from: paper1.title))
        let titleWords2 = Set(extractImportantWords(from: paper2.title))
        let commonTitleWords = titleWords1.intersection(titleWords2).count

        if !titleWords1.isEmpty {
            score += Double(commonTitleWords) / Double(titleWords1.count) * 0.3
        }

        // Compare abstracts if available
        if let abstract1 = paper1.abstract, let abstract2 = paper2.abstract {
            let abstractWords1 = Set(extractImportantWords(from: abstract1))
            let abstractWords2 = Set(extractImportantWords(from: abstract2))
            let commonAbstractWords = abstractWords1.intersection(abstractWords2).count

            if !abstractWords1.isEmpty {
                score += Double(commonAbstractWords) / Double(abstractWords1.count) * 0.2
            }
        }

        return min(score, 1.0)
    }
}

// MARK: - ArXiv XML Parser
private class ArXivXMLParser: NSObject, XMLParserDelegate {
    private var papers: [Paper] = []
    private var currentElement = ""
    private var currentTitle = ""
    private var currentSummary = ""
    private var currentAuthors: [String] = []
    private var currentPublished = ""
    private var currentArXivId = ""
    private var currentPDFLink = ""
    private var isInAuthor = false

    func parse(_ data: Data) throws -> [Paper] {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return papers
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName

        if elementName == "entry" {
            currentTitle = ""
            currentSummary = ""
            currentAuthors = []
            currentPublished = ""
            currentArXivId = ""
            currentPDFLink = ""
        } else if elementName == "author" {
            isInAuthor = true
        } else if elementName == "link" {
            if let type = attributeDict["type"], type == "application/pdf",
               let href = attributeDict["href"] {
                currentPDFLink = href
            }
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return }

        switch currentElement {
        case "title":
            currentTitle += trimmed
        case "summary":
            currentSummary += trimmed
        case "name" where isInAuthor:
            currentAuthors.append(trimmed)
        case "published":
            currentPublished += trimmed
        case "id":
            currentArXivId += trimmed
        default:
            break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "entry" {
            // Extract arXiv ID from full ID URL
            let arxivId = currentArXivId.components(separatedBy: "/").last ?? ""

            // Parse date
            let dateFormatter = ISO8601DateFormatter()
            let date = dateFormatter.date(from: currentPublished)

            let paper = Paper(
                title: currentTitle,
                authors: currentAuthors,
                abstract: currentSummary,
                publicationDate: date,
                arxivId: arxivId,
                pdfURL: URL(string: currentPDFLink),
                keywords: [],
                isUserUploaded: false
            )

            papers.append(paper)
        } else if elementName == "author" {
            isInAuthor = false
        }
    }
}

// MARK: - Search Errors
enum SearchError: LocalizedError {
    case invalidURL
    case networkError
    case parsingError
    case noResults

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid search URL"
        case .networkError:
            return "Network request failed"
        case .parsingError:
            return "Failed to parse search results"
        case .noResults:
            return "No results found"
        }
    }
}
