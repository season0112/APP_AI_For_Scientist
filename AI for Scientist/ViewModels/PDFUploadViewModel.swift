//
//  PDFUploadViewModel.swift
//  AI for Scientist
//
//  ViewModel for PDF upload and paper metadata extraction
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers
import Combine

/// ViewModel managing PDF upload workflow
@MainActor
class PDFUploadViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var uploadedPaper: Paper?
    @Published var isUploading: Bool = false
    @Published var uploadProgress: Double = 0.0
    @Published var showFilePicker: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false

    // MARK: - Dependencies

    private let pdfService = PDFService.shared
    private let mainViewModel: MainViewModel

    // MARK: - Initialization

    init(mainViewModel: MainViewModel) {
        self.mainViewModel = mainViewModel
    }

    // MARK: - PDF Upload

    /// Handle PDF file selection and upload
    func handlePDFSelection(_ url: URL) async {
        isUploading = true
        uploadProgress = 0.1
        clearError()

        do {
            // Import PDF to local storage
            uploadProgress = 0.3
            let localURL = try await pdfService.importPDF(from: url)

            // Extract metadata
            uploadProgress = 0.6
            let paper = try await pdfService.extractMetadata(from: localURL)

            // Update state
            uploadProgress = 1.0
            uploadedPaper = paper

            // Add to main view model
            mainViewModel.addUploadedPaper(paper)

            isUploading = false

        } catch {
            handleError(error)
        }
    }

    /// Reset upload state
    func resetUpload() {
        uploadedPaper = nil
        uploadProgress = 0.0
        clearError()
    }

    // MARK: - Error Handling

    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        showError = true
        isUploading = false
        uploadProgress = 0.0
    }

    private func clearError() {
        errorMessage = nil
        showError = false
    }
}
