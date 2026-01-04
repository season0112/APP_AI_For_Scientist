//
//  PDFUploadView.swift
//  AI for Scientist
//
//  View for uploading and managing PDF papers
//

import SwiftUI
import UniformTypeIdentifiers

struct PDFUploadView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @State private var showFilePicker = false
    @State private var showNewsletterGeneration = false

    var body: some View {
        PDFUploadContentView(
            mainViewModel: mainViewModel,
            showFilePicker: $showFilePicker,
            showNewsletterGeneration: $showNewsletterGeneration
        )
    }
}

struct PDFUploadContentView: View {
    @ObservedObject var mainViewModel: MainViewModel
    @StateObject private var uploadViewModel: PDFUploadViewModel
    @Binding var showFilePicker: Bool
    @Binding var showNewsletterGeneration: Bool

    init(mainViewModel: MainViewModel, showFilePicker: Binding<Bool>, showNewsletterGeneration: Binding<Bool>) {
        self.mainViewModel = mainViewModel
        self._showFilePicker = showFilePicker
        self._showNewsletterGeneration = showNewsletterGeneration
        self._uploadViewModel = StateObject(wrappedValue: PDFUploadViewModel(mainViewModel: mainViewModel))
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Upload Section
                    uploadSection

                    // Uploaded Papers List
                    if !mainViewModel.userProfile.uploadedPapers.isEmpty {
                        uploadedPapersSection
                    }
                }
                .padding()
            }
            .navigationTitle("Upload Papers")
            .fileImporter(
                isPresented: $showFilePicker,
                allowedContentTypes: [.pdf],
                allowsMultipleSelection: false
            ) { result in
                handleFileImport(result)
            }
            .sheet(isPresented: $showNewsletterGeneration) {
                NewsletterGenerationView()
            }
            .alert("Error", isPresented: $uploadViewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(uploadViewModel.errorMessage ?? "An error occurred")
            }
        }
    }

    // MARK: - View Components

    private var uploadSection: some View {
        VStack(spacing: 15) {
            // Upload Button
            Button(action: { showFilePicker = true }) {
                VStack(spacing: 15) {
                    Image(systemName: "arrow.up.doc.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)

                    Text("Upload PDF Paper")
                        .font(.headline)

                    Text("Tap to select a PDF file from your device or iCloud")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(30)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
            }
            .disabled(uploadViewModel.isUploading)

            // Upload Progress
            if uploadViewModel.isUploading {
                VStack(spacing: 10) {
                    ProgressView(value: uploadViewModel.uploadProgress)
                        .progressViewStyle(.linear)

                    Text("Uploading and processing...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            // Recently Uploaded Paper
            if let paper = uploadViewModel.uploadedPaper {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)

                        Text("Successfully Uploaded")
                            .font(.headline)
                    }

                    PaperDetailView(paper: paper)

                    Button(action: { showNewsletterGeneration = true }) {
                        Text("Generate Newsletter")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
            }
        }
    }

    private var uploadedPapersSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Your Papers")
                .font(.headline)

            ForEach(mainViewModel.userProfile.uploadedPapers) { paper in
                PaperCardView(paper: paper) {
                    mainViewModel.removeUploadedPaper(paper)
                }
            }
        }
    }

    // MARK: - Actions

    private func handleFileImport(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else { return }

            Task {
                await uploadViewModel.handlePDFSelection(url)
            }

        case .failure(let error):
            uploadViewModel.errorMessage = error.localizedDescription
            uploadViewModel.showError = true
        }
    }
}

// MARK: - Supporting Views

struct PaperDetailView: View {
    let paper: Paper

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(paper.title)
                .font(.title3)
                .fontWeight(.semibold)

            if !paper.authors.isEmpty {
                HStack {
                    Image(systemName: "person.2")
                        .foregroundColor(.secondary)
                    Text(paper.formattedAuthors)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            if let abstract = paper.abstract {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Abstract")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)

                    Text(abstract)
                        .font(.caption)
                        .lineLimit(5)
                }
            }

            if !paper.keywords.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 5) {
                        ForEach(paper.keywords, id: \.self) { keyword in
                            Text(keyword)
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(4)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct PaperCardView: View {
    let paper: Paper
    let onDelete: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(paper.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)

                Text(paper.formattedAuthors)
                    .font(.caption)
                    .foregroundColor(.secondary)

                if !paper.keywords.isEmpty {
                    Text(paper.keywords.prefix(3).joined(separator: ", "))
                        .font(.caption2)
                        .foregroundColor(.blue)
                        .lineLimit(1)
                }
            }

            Spacer()

            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    PDFUploadView()
        .environmentObject(MainViewModel())
}
