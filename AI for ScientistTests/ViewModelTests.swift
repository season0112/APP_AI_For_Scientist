//
//  ViewModelTests.swift
//  AI for ScientistTests
//
//  Unit tests for ViewModels
//

import XCTest
import Combine
@testable import AI_for_Scientist

@MainActor
final class ViewModelTests: XCTestCase {

    // MARK: - MainViewModel Tests

    func testMainViewModelInitialization() {
        let viewModel = MainViewModel()

        XCTAssertEqual(viewModel.selectedTab, .home)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.showError)
        XCTAssertNotNil(viewModel.userProfile)
    }

    func testUpdatePreferredFields() {
        let viewModel = MainViewModel()
        let fields = [ResearchField.predefinedFields[0], ResearchField.predefinedFields[1]]

        viewModel.updatePreferredFields(fields)

        XCTAssertEqual(viewModel.userProfile.preferredFields.count, 2)
    }

    func testAddUploadedPaper() {
        let viewModel = MainViewModel()
        let paper = Paper(title: "Test Paper", authors: ["Author"])

        viewModel.addUploadedPaper(paper)

        XCTAssertEqual(viewModel.userProfile.uploadedPapers.count, 1)
        XCTAssertEqual(viewModel.userProfile.uploadedPapers[0].title, "Test Paper")
    }

    func testRemoveUploadedPaper() {
        let viewModel = MainViewModel()
        let paper = Paper(title: "Test Paper", authors: ["Author"])

        viewModel.addUploadedPaper(paper)
        XCTAssertEqual(viewModel.userProfile.uploadedPapers.count, 1)

        viewModel.removeUploadedPaper(paper)
        XCTAssertEqual(viewModel.userProfile.uploadedPapers.count, 0)
    }

    func testUpdateNotificationSettings() {
        let viewModel = MainViewModel()

        viewModel.updateNotificationSettings(enabled: false, frequency: .monthly)

        XCTAssertFalse(viewModel.userProfile.notificationEnabled)
        XCTAssertEqual(viewModel.userProfile.notificationFrequency, .monthly)
    }

    func testErrorHandling() {
        let viewModel = MainViewModel()
        let error = NSError(domain: "Test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Test error"])

        viewModel.handleError(error)

        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "Test error")

        viewModel.clearError()

        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.errorMessage)
    }

    // MARK: - PDFUploadViewModel Tests

    func testPDFUploadViewModelInitialization() {
        let mainViewModel = MainViewModel()
        let uploadViewModel = PDFUploadViewModel(mainViewModel: mainViewModel)

        XCTAssertNil(uploadViewModel.uploadedPaper)
        XCTAssertFalse(uploadViewModel.isUploading)
        XCTAssertEqual(uploadViewModel.uploadProgress, 0.0)
        XCTAssertFalse(uploadViewModel.showFilePicker)
    }

    func testResetUpload() {
        let mainViewModel = MainViewModel()
        let uploadViewModel = PDFUploadViewModel(mainViewModel: mainViewModel)

        // Simulate upload state
        uploadViewModel.uploadedPaper = Paper(title: "Test", authors: [])
        uploadViewModel.uploadProgress = 0.5

        uploadViewModel.resetUpload()

        XCTAssertNil(uploadViewModel.uploadedPaper)
        XCTAssertEqual(uploadViewModel.uploadProgress, 0.0)
    }

    // MARK: - NewsletterGenerationViewModel Tests

    func testNewsletterGenerationViewModelInitialization() {
        let mainViewModel = MainViewModel()
        let viewModel = NewsletterGenerationViewModel(mainViewModel: mainViewModel)

        XCTAssertNil(viewModel.selectedField)
        XCTAssertNil(viewModel.selectedPaper)
        XCTAssertTrue(viewModel.searchResults.isEmpty)
        XCTAssertFalse(viewModel.isSearching)
        XCTAssertFalse(viewModel.isGenerating)
    }

    func testSelectField() {
        let mainViewModel = MainViewModel()
        let viewModel = NewsletterGenerationViewModel(mainViewModel: mainViewModel)
        let field = ResearchField.predefinedFields[0]

        viewModel.selectField(field)

        XCTAssertNotNil(viewModel.selectedField)
        XCTAssertEqual(viewModel.selectedField?.id, field.id)
    }

    func testSelectPaper() {
        let mainViewModel = MainViewModel()
        let viewModel = NewsletterGenerationViewModel(mainViewModel: mainViewModel)
        let paper = Paper(title: "Test", authors: [])

        viewModel.selectPaper(paper)

        XCTAssertNotNil(viewModel.selectedPaper)
        XCTAssertEqual(viewModel.selectedPaper?.id, paper.id)
    }

    func testReset() {
        let mainViewModel = MainViewModel()
        let viewModel = NewsletterGenerationViewModel(mainViewModel: mainViewModel)

        // Set some state
        viewModel.selectField(ResearchField.predefinedFields[0])
        viewModel.selectPaper(Paper(title: "Test", authors: []))
        viewModel.searchResults = [Paper(title: "Result", authors: [])]

        viewModel.reset()

        XCTAssertNil(viewModel.selectedField)
        XCTAssertNil(viewModel.selectedPaper)
        XCTAssertTrue(viewModel.searchResults.isEmpty)
    }

    // MARK: - NewsletterListViewModel Tests

    func testNewsletterListViewModelInitialization() {
        let mainViewModel = MainViewModel()
        let viewModel = NewsletterListViewModel(mainViewModel: mainViewModel)

        XCTAssertTrue(viewModel.newsletters.isEmpty)
        XCTAssertNil(viewModel.selectedNewsletter)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testSelectNewsletter() {
        let mainViewModel = MainViewModel()
        let viewModel = NewsletterListViewModel(mainViewModel: mainViewModel)
        let newsletter = Newsletter(
            title: "Test",
            researchField: ResearchField.predefinedFields[0]
        )

        viewModel.selectNewsletter(newsletter)

        XCTAssertNotNil(viewModel.selectedNewsletter)
        XCTAssertEqual(viewModel.selectedNewsletter?.id, newsletter.id)
    }
}
