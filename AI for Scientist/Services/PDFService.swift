//
//  PDFService.swift
//  AI for Scientist
//
//  Service for handling PDF operations: upload, parsing, text extraction
//

import Foundation
import PDFKit
import UniformTypeIdentifiers

/// Service responsible for PDF file operations
class PDFService {
    static let shared = PDFService()

    private init() {}

    // MARK: - PDF Upload

    /// Import PDF from local file system or iCloud
    /// - Parameter url: URL of the PDF file
    /// - Returns: Local file URL where PDF is stored
    func importPDF(from url: URL) async throws -> URL {
        // Start accessing security-scoped resource
        let accessGranted = url.startAccessingSecurityScopedResource()
        defer {
            if accessGranted {
                url.stopAccessingSecurityScopedResource()
            }
        }

        // Create documents directory if needed
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let pdfDirectory = documentsPath.appendingPathComponent("Papers", isDirectory: true)

        try FileManager.default.createDirectory(at: pdfDirectory, withIntermediateDirectories: true)

        // Generate unique filename
        let filename = "\(UUID().uuidString).pdf"
        let destinationURL = pdfDirectory.appendingPathComponent(filename)

        // Copy file to app's documents directory
        try FileManager.default.copyItem(at: url, to: destinationURL)

        return destinationURL
    }

    // MARK: - PDF Parsing

    /// Extract text content from PDF
    /// - Parameter url: URL of the PDF file
    /// - Returns: Extracted text content
    func extractText(from url: URL) async throws -> String {
        guard let pdfDocument = PDFDocument(url: url) else {
            throw PDFError.cannotOpenDocument
        }

        var fullText = ""

        for pageIndex in 0..<pdfDocument.pageCount {
            guard let page = pdfDocument.page(at: pageIndex),
                  let pageText = page.string else {
                continue
            }

            fullText += pageText + "\n\n"
        }

        guard !fullText.isEmpty else {
            throw PDFError.noTextContent
        }

        return fullText
    }

    /// Extract metadata from PDF (title, authors, abstract)
    /// - Parameter url: URL of the PDF file
    /// - Returns: Paper object with extracted metadata
    func extractMetadata(from url: URL) async throws -> Paper {
        let text = try await extractText(from: url)

        // Extract title (usually first non-empty line or largest text)
        let title = extractTitle(from: text)

        // Extract authors (heuristic: look for author patterns)
        let authors = extractAuthors(from: text)

        // Extract abstract (look for "Abstract" section)
        let abstract = extractAbstract(from: text)

        // Extract keywords if available
        let keywords = extractKeywords(from: text)

        return Paper(
            title: title,
            authors: authors,
            abstract: abstract,
            localPDFPath: url,
            keywords: keywords,
            isUserUploaded: true
        )
    }

    // MARK: - Private Helpers

    private func extractTitle(from text: String) -> String {
        let lines = text.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        // Take first substantial line as title
        return lines.first { $0.count > 10 } ?? "Untitled Paper"
    }

    private func extractAuthors(from text: String) -> [String] {
        // Simple heuristic: look for lines after title before abstract
        // In real implementation, use more sophisticated NLP or regex patterns
        let lines = text.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }

        var authors: [String] = []

        for (index, line) in lines.enumerated() {
            if index > 5 { break } // Authors usually in first few lines

            // Check if line contains typical author patterns
            if line.contains(",") || line.contains(" and ") {
                let potentialAuthors = line
                    .components(separatedBy: CharacterSet(charactersIn: ",;"))
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                    .filter { $0.count > 3 && $0.count < 50 }

                authors.append(contentsOf: potentialAuthors)
            }
        }

        return authors.isEmpty ? ["Unknown Author"] : Array(authors.prefix(5))
    }

    private func extractAbstract(from text: String) -> String? {
        let lowercasedText = text.lowercased()

        // Find abstract section
        if let abstractRange = lowercasedText.range(of: "abstract") {
            let startIndex = abstractRange.upperBound
            let remainingText = text[startIndex...]

            // Find end of abstract (usually before "Introduction" or after certain length)
            let endMarkers = ["introduction", "1. introduction", "keywords"]
            var endIndex = remainingText.endIndex

            for marker in endMarkers {
                if let range = remainingText.lowercased().range(of: marker) {
                    endIndex = range.lowerBound
                    break
                }
            }

            let abstract = String(remainingText[..<endIndex])
                .trimmingCharacters(in: .whitespacesAndNewlines)

            // Limit to reasonable abstract length
            if abstract.count > 2000 {
                let index = abstract.index(abstract.startIndex, offsetBy: 2000)
                return String(abstract[..<index])
            }

            return abstract
        }

        return nil
    }

    private func extractKeywords(from text: String) -> [String] {
        let lowercasedText = text.lowercased()

        if let keywordsRange = lowercasedText.range(of: "keywords:") {
            let startIndex = keywordsRange.upperBound
            let remainingText = text[startIndex...]

            // Extract until newline or certain characters
            if let lineEnd = remainingText.firstIndex(of: "\n") {
                let keywordsLine = remainingText[..<lineEnd]
                return keywordsLine
                    .components(separatedBy: CharacterSet(charactersIn: ",;"))
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                    .filter { !$0.isEmpty }
            }
        }

        return []
    }

    // MARK: - PDF Generation

    /// Generate PDF from HTML content
    /// - Parameters:
    ///   - html: HTML content string
    ///   - filename: Desired filename
    /// - Returns: URL of generated PDF
    func generatePDF(from html: String, filename: String) async throws -> URL {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let newslettersDirectory = documentsPath.appendingPathComponent("Newsletters", isDirectory: true)

        try FileManager.default.createDirectory(at: newslettersDirectory, withIntermediateDirectories: true)

        let pdfURL = newslettersDirectory.appendingPathComponent("\(filename).pdf")

        // Note: In production, use WKWebView or other rendering engine
        // This is a placeholder for PDF generation
        // For now, save HTML to file
        let htmlURL = newslettersDirectory.appendingPathComponent("\(filename).html")
        try html.write(to: htmlURL, atomically: true, encoding: .utf8)

        return htmlURL
    }
}

// MARK: - PDF Errors
enum PDFError: LocalizedError {
    case cannotOpenDocument
    case noTextContent
    case invalidFormat
    case permissionDenied

    var errorDescription: String? {
        switch self {
        case .cannotOpenDocument:
            return "Unable to open PDF document"
        case .noTextContent:
            return "PDF contains no extractable text"
        case .invalidFormat:
            return "Invalid PDF format"
        case .permissionDenied:
            return "Permission denied to access file"
        }
    }
}
