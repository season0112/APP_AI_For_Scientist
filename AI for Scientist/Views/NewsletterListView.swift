//
//  NewsletterListView.swift
//  AI for Scientist
//
//  View for displaying saved newsletters
//

import SwiftUI

struct NewsletterListView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @State private var showGenerateSheet = false

    var body: some View {
        NewsletterListContentView(mainViewModel: mainViewModel, showGenerateSheet: $showGenerateSheet)
    }
}

struct NewsletterListContentView: View {
    @ObservedObject var mainViewModel: MainViewModel
    @StateObject private var viewModel: NewsletterListViewModel
    @Binding var showGenerateSheet: Bool

    init(mainViewModel: MainViewModel, showGenerateSheet: Binding<Bool>) {
        self.mainViewModel = mainViewModel
        self._showGenerateSheet = showGenerateSheet
        self._viewModel = StateObject(wrappedValue: NewsletterListViewModel(mainViewModel: mainViewModel))
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.newsletters.isEmpty && !viewModel.isLoading {
                    emptyStateView
                } else {
                    newsletterListView
                }
            }
            .navigationTitle("Newsletters")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showGenerateSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showGenerateSheet) {
                NewsletterGenerationView()
            }
            .onAppear {
                Task {
                    await viewModel.loadNewsletters()
                }
            }
            .refreshable {
                await viewModel.loadNewsletters()
            }
        }
    }

    // MARK: - View Components

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "envelope.badge")
                .font(.system(size: 80))
                .foregroundColor(.gray)

            Text("No Newsletters Yet")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Generate your first newsletter to get started with curated research updates")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: { showGenerateSheet = true }) {
                Text("Generate Newsletter")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
    }

    private var newsletterListView: some View {
        List {
            ForEach(viewModel.newsletters) { newsletter in
                NavigationLink(destination: NewsletterDetailView(newsletter: newsletter)) {
                    NewsletterListRowView(newsletter: newsletter)
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    let newsletter = viewModel.newsletters[index]
                    Task {
                        await viewModel.deleteNewsletter(newsletter)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
    }
}

// MARK: - Newsletter List Row

struct NewsletterListRowView: View {
    let newsletter: Newsletter

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Title
            Text(newsletter.title)
                .font(.headline)
                .lineLimit(2)

            // Summary preview
            Text(newsletter.previewText)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(3)

            // Metadata
            HStack {
                // Field badge
                Text(newsletter.researchField.name)
                    .font(.caption2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(4)

                // Paper count
                Text("\(newsletter.totalPapers) papers")
                    .font(.caption2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(4)

                Spacer()

                // Date
                Text(newsletter.formattedDate)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    NewsletterListView()
        .environmentObject(MainViewModel())
}
