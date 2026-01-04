//
//  Newsletter.swift
//  AI for Scientist
//
//  Model representing a generated newsletter with curated papers
//

import Foundation

/// Represents a generated newsletter containing curated research papers
struct Newsletter: Identifiable, Codable {
    let id: UUID
    let title: String
    let generatedDate: Date
    let researchField: ResearchField
    let userPaper: Paper?
    let relatedPapers: [Paper]
    let summary: String
    let htmlContent: String?
    let pdfURL: URL?

    /// Status of newsletter generation
    let status: NewsletterStatus

    init(
        id: UUID = UUID(),
        title: String,
        generatedDate: Date = Date(),
        researchField: ResearchField,
        userPaper: Paper? = nil,
        relatedPapers: [Paper] = [],
        summary: String = "",
        htmlContent: String? = nil,
        pdfURL: URL? = nil,
        status: NewsletterStatus = .draft
    ) {
        self.id = id
        self.title = title
        self.generatedDate = generatedDate
        self.researchField = researchField
        self.userPaper = userPaper
        self.relatedPapers = relatedPapers
        self.summary = summary
        self.htmlContent = htmlContent
        self.pdfURL = pdfURL
        self.status = status
    }
}

/// Status of newsletter generation process
enum NewsletterStatus: String, Codable {
    case draft = "draft"
    case generating = "generating"
    case completed = "completed"
    case failed = "failed"
}

// MARK: - Computed Properties
extension Newsletter {
    /// Formatted generation date
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: generatedDate)
    }

    /// Total number of papers in newsletter
    var totalPapers: Int {
        return relatedPapers.count + (userPaper != nil ? 1 : 0)
    }

    /// Newsletter preview text
    var previewText: String {
        if summary.count <= 200 {
            return summary
        } else {
            let index = summary.index(summary.startIndex, offsetBy: 200)
            return String(summary[..<index]) + "..."
        }
    }
}

// MARK: - Newsletter Template
extension Newsletter {
    /// Generates HTML content for the newsletter
    func generateHTMLContent() -> String {
        var html = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <style>
                body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; line-height: 1.6; padding: 20px; max-width: 800px; margin: 0 auto; }
                h1 { color: #2c3e50; border-bottom: 3px solid #3498db; padding-bottom: 10px; }
                h2 { color: #34495e; margin-top: 30px; }
                .paper { background: #f8f9fa; padding: 15px; margin: 15px 0; border-radius: 8px; border-left: 4px solid #3498db; }
                .paper-title { font-size: 1.2em; font-weight: bold; color: #2c3e50; }
                .paper-authors { color: #7f8c8d; font-style: italic; margin: 5px 0; }
                .paper-abstract { margin-top: 10px; }
                .summary { background: #e8f4f8; padding: 15px; border-radius: 8px; margin: 20px 0; }
                .meta { color: #95a5a6; font-size: 0.9em; }
            </style>
        </head>
        <body>
            <h1>\(title)</h1>
            <p class="meta">Generated on \(formattedDate) • Field: \(researchField.name)</p>

            <div class="summary">
                <h2>Summary</h2>
                <p>\(summary)</p>
            </div>
        """

        if let userPaper = userPaper {
            html += """

            <h2>Your Paper</h2>
            <div class="paper">
                <div class="paper-title">\(userPaper.title)</div>
                <div class="paper-authors">\(userPaper.formattedAuthors)</div>
                <div class="paper-abstract">\(userPaper.abstract ?? "No abstract available")</div>
            </div>
            """
        }

        if !relatedPapers.isEmpty {
            html += "<h2>Related Research (\(relatedPapers.count) papers)</h2>"

            for paper in relatedPapers {
                html += """

                <div class="paper">
                    <div class="paper-title">\(paper.title)</div>
                    <div class="paper-authors">\(paper.formattedAuthors) • \(paper.formattedDate)</div>
                    <div class="paper-abstract">\(paper.abstractPreview)</div>
                </div>
                """
            }
        }

        html += """

        </body>
        </html>
        """

        return html
    }
}
