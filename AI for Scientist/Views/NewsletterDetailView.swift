//
//  NewsletterDetailView.swift
//  AI for Scientist
//
//  Detailed view of a generated newsletter
//

import SwiftUI
import WebKit

struct NewsletterDetailView: View {
    let newsletter: Newsletter

    @State private var showShareSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                headerSection

                // Summary
                summarySection

                // User's Paper (if exists)
                if let userPaper = newsletter.userPaper {
                    userPaperSection(userPaper)
                }

                // Related Papers
                if !newsletter.relatedPapers.isEmpty {
                    relatedPapersSection
                }
            }
            .padding()
        }
        .navigationTitle("Newsletter")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showShareSheet = true }) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if let pdfURL = newsletter.pdfURL {
                ShareSheet(items: [pdfURL])
            }
        }
    }

    // MARK: - View Components

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(newsletter.title)
                .font(.title2)
                .fontWeight(.bold)

            HStack {
                Text(newsletter.researchField.name)
                    .font(.subheadline)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(6)

                Text(newsletter.formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()
            }
        }
    }

    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Summary")
                .font(.headline)

            Text(newsletter.summary)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.blue.opacity(0.05))
        .cornerRadius(10)
    }

    private func userPaperSection(_ paper: Paper) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Your Paper")
                .font(.headline)

            PaperDetailCardView(paper: paper, showRelevance: false)
        }
    }

    private var relatedPapersSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Related Research (\(newsletter.relatedPapers.count) papers)")
                .font(.headline)

            ForEach(newsletter.relatedPapers) { paper in
                PaperDetailCardView(paper: paper, showRelevance: true)
            }
        }
    }
}

// MARK: - Paper Detail Card

struct PaperDetailCardView: View {
    let paper: Paper
    let showRelevance: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Title
            Text(paper.title)
                .font(.subheadline)
                .fontWeight(.semibold)

            // Authors and date
            HStack {
                Image(systemName: "person.2")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(paper.formattedAuthors)
                    .font(.caption)
                    .foregroundColor(.secondary)

                if let _ = paper.publicationDate {
                    Text("•")
                        .foregroundColor(.secondary)

                    Text(paper.formattedDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            // Abstract
            if let abstract = paper.abstract {
                Text(abstract)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            // Metadata
            HStack {
                if showRelevance, let score = paper.relevanceScore {
                    Text("Relevance: \(Int(score * 100))%")
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(4)
                }

                if let arxivId = paper.arxivId {
                    Link(destination: URL(string: "https://arxiv.org/abs/\(arxivId)")!) {
                        HStack(spacing: 3) {
                            Text("arXiv")
                            Image(systemName: "arrow.up.right.square")
                        }
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(4)
                    }
                }

                if let pdfURL = paper.pdfURL {
                    Link(destination: pdfURL) {
                        HStack(spacing: 3) {
                            Text("PDF")
                            Image(systemName: "doc.fill")
                        }
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.red.opacity(0.2))
                        .cornerRadius(4)
                    }
                }
            }

            // Keywords
            if !paper.keywords.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 5) {
                        ForEach(paper.keywords.prefix(5), id: \.self) { keyword in
                            Text(keyword)
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background(Color.purple.opacity(0.1))
                                .cornerRadius(4)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(10)
    }
}

// MARK: - Share Sheet

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    NavigationView {
        NewsletterDetailView(
            newsletter: Newsletter(
                title: "AI Research Newsletter - December 2025",
                researchField: ResearchField.predefinedFields[0],
                relatedPapers: [],
                summary: "This newsletter covers recent advances in artificial intelligence."
            )
        )
    }
}
