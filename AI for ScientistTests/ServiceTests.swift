//
//  ServiceTests.swift
//  AI for ScientistTests
//
//  Unit tests for service layer
//

import XCTest
@testable import AI_for_Scientist

final class ServiceTests: XCTestCase {

    // MARK: - PDFService Tests

    func testPDFServiceSharedInstance() {
        let service1 = PDFService.shared
        let service2 = PDFService.shared

        XCTAssertTrue(service1 === service2, "PDFService should be a singleton")
    }

    func testPDFErrorDescriptions() {
        XCTAssertNotNil(PDFError.cannotOpenDocument.errorDescription)
        XCTAssertNotNil(PDFError.noTextContent.errorDescription)
        XCTAssertNotNil(PDFError.invalidFormat.errorDescription)
        XCTAssertNotNil(PDFError.permissionDenied.errorDescription)
    }

    // MARK: - LiteratureSearchService Tests

    func testSearchServiceSharedInstance() {
        let service1 = LiteratureSearchService.shared
        let service2 = LiteratureSearchService.shared

        XCTAssertTrue(service1 === service2, "LiteratureSearchService should be a singleton")
    }

    func testSearchErrorDescriptions() {
        XCTAssertNotNil(SearchError.invalidURL.errorDescription)
        XCTAssertNotNil(SearchError.networkError.errorDescription)
        XCTAssertNotNil(SearchError.parsingError.errorDescription)
        XCTAssertNotNil(SearchError.noResults.errorDescription)
    }

    // Note: Add more comprehensive integration tests for actual search functionality
    // These would require mocking network requests or using test fixtures

    // MARK: - NewsletterService Tests

    func testNewsletterServiceSharedInstance() {
        let service1 = NewsletterService.shared
        let service2 = NewsletterService.shared

        XCTAssertTrue(service1 === service2, "NewsletterService should be a singleton")
    }

    func testNewsletterErrorDescriptions() {
        XCTAssertNotNil(NewsletterError.generationFailed.errorDescription)
        XCTAssertNotNil(NewsletterError.saveFailed.errorDescription)
        XCTAssertNotNil(NewsletterError.loadFailed.errorDescription)
    }

    // MARK: - Integration Tests (Async)

    func testNewsletterGenerationFlow() async throws {
        let field = ResearchField.predefinedFields[0]
        let papers = [
            Paper(title: "Test Paper 1", authors: ["Author 1"]),
            Paper(title: "Test Paper 2", authors: ["Author 2"])
        ]

        let newsletter = try await NewsletterService.shared.generateNewsletter(
            userPaper: nil,
            relatedPapers: papers,
            field: field
        )

        XCTAssertEqual(newsletter.status, .completed)
        XCTAssertEqual(newsletter.relatedPapers.count, 2)
        XCTAssertFalse(newsletter.summary.isEmpty)
        XCTAssertNotNil(newsletter.htmlContent)
    }

    // Note: Add mock implementations for testing API calls
    // Example:
    // func testArXivSearchWithMockData() async throws {
    //     // Load mock XML response
    //     // Test parsing
    //     // Verify results
    // }
}
