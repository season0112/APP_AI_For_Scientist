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
            ZStack {
                // Dark background
                ThemeConfig.Background.primary
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: ThemeConfig.Spacing.lg) {
                        // Upload Section
                        uploadSection

                        // Uploaded Papers List
                        if !mainViewModel.userProfile.uploadedPapers.isEmpty {
                            uploadedPapersSection
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Upload Papers")
            .toolbarBackground(ThemeConfig.Background.secondary, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
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
        VStack(spacing: ThemeConfig.Spacing.lg) {
            // Upload Button
            Button(action: { showFilePicker = true }) {
                VStack(spacing: ThemeConfig.Spacing.lg) {
                    ZStack {
                        Circle()
                            .fill(ThemeConfig.Gradients.neonPurpleBlue)
                            .frame(width: 80, height: 80)
                            .neonGlow(color: ThemeConfig.Neon.purple, radius: 20)

                        Image(systemName: "arrow.up.doc.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    }

                    VStack(spacing: 8) {
                        Text("Upload PDF Paper")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(ThemeConfig.Text.primary)

                        Text("Tap to select a PDF file from your device or iCloud")
                            .font(.subheadline)
                            .foregroundColor(ThemeConfig.Text.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(ThemeConfig.Spacing.xl)
                .background(
                    RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.xl)
                        .fill(ThemeConfig.Background.elevated)
                        .overlay(
                            RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.xl)
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            ThemeConfig.Neon.purple.opacity(0.6),
                                            ThemeConfig.Neon.electricBlue.opacity(0.6)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                )
                .shadow(color: ThemeConfig.Shadows.purpleGlow, radius: 20, x: 0, y: 10)
            }
            .disabled(uploadViewModel.isUploading)

            // Upload Progress
            if uploadViewModel.isUploading {
                VStack(spacing: ThemeConfig.Spacing.md) {
                    // Custom neon progress bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.pill)
                                .fill(ThemeConfig.Background.tertiary)
                                .frame(height: 8)

                            RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.pill)
                                .fill(ThemeConfig.Gradients.neonCyanMagenta)
                                .frame(width: geometry.size.width * CGFloat(uploadViewModel.uploadProgress), height: 8)
                                .neonGlow(color: ThemeConfig.Neon.cyan, radius: 8)
                        }
                    }
                    .frame(height: 8)

                    HStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: ThemeConfig.Neon.cyan))

                        Text("Uploading and processing...")
                            .font(.subheadline)
                            .foregroundColor(ThemeConfig.Text.secondary)
                    }
                }
                .padding(ThemeConfig.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                        .fill(ThemeConfig.Background.tertiary)
                )
            }

            // Recently Uploaded Paper
            if let paper = uploadViewModel.uploadedPaper {
                VStack(alignment: .leading, spacing: ThemeConfig.Spacing.md) {
                    HStack(spacing: ThemeConfig.Spacing.sm) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(ThemeConfig.Neon.neonGreen)
                            .neonGlow(color: ThemeConfig.Neon.neonGreen, radius: 8)

                        Text("Successfully Uploaded")
                            .font(.headline)
                            .foregroundColor(ThemeConfig.Text.primary)
                    }

                    PaperDetailView(paper: paper)

                    Button(action: { showNewsletterGeneration = true }) {
                        HStack {
                            Text("Generate Newsletter")
                                .font(.headline)
                                .fontWeight(.semibold)

                            Spacer()

                            Image(systemName: "arrow.right.circle.fill")
                                .font(.title3)
                        }
                        .foregroundColor(.white)
                        .padding(ThemeConfig.Spacing.md)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                                .fill(ThemeConfig.Gradients.neonGreenCyan)
                        )
                        .neonGlow(color: ThemeConfig.Neon.neonGreen, radius: 10)
                    }
                }
                .padding(ThemeConfig.Spacing.lg)
                .background(
                    RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.lg)
                        .fill(ThemeConfig.Background.elevated)
                        .overlay(
                            RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.lg)
                                .stroke(ThemeConfig.Neon.neonGreen.opacity(0.3), lineWidth: 2)
                        )
                )
                .shadow(color: ThemeConfig.Shadows.greenGlow, radius: 15, x: 0, y: 8)
            }
        }
    }

    private var uploadedPapersSection: some View {
        VStack(alignment: .leading, spacing: ThemeConfig.Spacing.md) {
            HStack {
                Text("Your Papers")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(ThemeConfig.Text.primary)

                Spacer()

                Text("\(mainViewModel.userProfile.uploadedPapers.count)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(ThemeConfig.Neon.cyan)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(ThemeConfig.Neon.cyan.opacity(0.2))
                            .overlay(
                                Capsule()
                                    .stroke(ThemeConfig.Neon.cyan, lineWidth: 1)
                            )
                    )
            }

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
        VStack(alignment: .leading, spacing: ThemeConfig.Spacing.md) {
            Text(paper.title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(ThemeConfig.Text.primary)

            if !paper.authors.isEmpty {
                HStack(spacing: 8) {
                    Image(systemName: "person.2.fill")
                        .foregroundColor(ThemeConfig.Neon.cyan)
                    Text(paper.formattedAuthors)
                        .font(.subheadline)
                        .foregroundColor(ThemeConfig.Text.secondary)
                }
            }

            if let abstract = paper.abstract {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Abstract")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(ThemeConfig.Neon.magenta)
                        .textCase(.uppercase)
                        .tracking(1)

                    Text(abstract)
                        .font(.caption)
                        .foregroundColor(ThemeConfig.Text.secondary)
                        .lineLimit(5)
                }
                .padding(ThemeConfig.Spacing.sm)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.sm)
                        .fill(ThemeConfig.Background.tertiary)
                )
            }

            if !paper.keywords.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(paper.keywords, id: \.self) { keyword in
                            Text(keyword)
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundColor(ThemeConfig.Neon.cyan)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(
                                    Capsule()
                                        .fill(ThemeConfig.Neon.cyan.opacity(0.1))
                                        .overlay(
                                            Capsule()
                                                .stroke(ThemeConfig.Neon.cyan.opacity(0.5), lineWidth: 1)
                                        )
                                )
                        }
                    }
                }
            }
        }
        .padding(ThemeConfig.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                .fill(ThemeConfig.Background.tertiary)
        )
    }
}

struct PaperCardView: View {
    let paper: Paper
    let onDelete: () -> Void
    @State private var showDeleteConfirm = false

    var body: some View {
        HStack(spacing: ThemeConfig.Spacing.md) {
            // Paper icon
            ZStack {
                RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.sm)
                    .fill(ThemeConfig.Gradients.neonPurpleBlue.opacity(0.2))
                    .frame(width: 50, height: 50)

                Image(systemName: "doc.fill")
                    .font(.title3)
                    .foregroundColor(ThemeConfig.Neon.purple)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(paper.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(ThemeConfig.Text.primary)
                    .lineLimit(2)

                Text(paper.formattedAuthors)
                    .font(.caption)
                    .foregroundColor(ThemeConfig.Text.secondary)
                    .lineLimit(1)

                if !paper.keywords.isEmpty {
                    HStack(spacing: 4) {
                        ForEach(paper.keywords.prefix(2), id: \.self) { keyword in
                            Text(keyword)
                                .font(.caption2)
                                .foregroundColor(ThemeConfig.Neon.purple)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(
                                    Capsule()
                                        .fill(ThemeConfig.Neon.purple.opacity(0.2))
                                )
                        }
                        if paper.keywords.count > 2 {
                            Text("+\(paper.keywords.count - 2)")
                                .font(.caption2)
                                .foregroundColor(ThemeConfig.Text.tertiary)
                        }
                    }
                }
            }

            Spacer()

            Button(action: { showDeleteConfirm = true }) {
                Image(systemName: "trash.fill")
                    .foregroundColor(ThemeConfig.Neon.magenta)
                    .padding(8)
                    .background(
                        Circle()
                            .fill(ThemeConfig.Neon.magenta.opacity(0.1))
                            .overlay(
                                Circle()
                                    .stroke(ThemeConfig.Neon.magenta.opacity(0.3), lineWidth: 1)
                            )
                    )
            }
            .confirmationDialog("Delete Paper?", isPresented: $showDeleteConfirm) {
                Button("Delete", role: .destructive) {
                    onDelete()
                }
                Button("Cancel", role: .cancel) {}
            }
        }
        .padding(ThemeConfig.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                .fill(ThemeConfig.Background.elevated)
                .overlay(
                    RoundedRectangle(cornerRadius: ThemeConfig.CornerRadius.md)
                        .stroke(ThemeConfig.Neon.purple.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#Preview {
    PDFUploadView()
        .environmentObject(MainViewModel())
}
