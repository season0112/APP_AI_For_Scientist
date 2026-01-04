//
//  ModelTests.swift
//  AI for ScientistTests
//
//  Unit tests for model objects
//

import XCTest
@testable import AI_for_Scientist

final class ModelTests: XCTestCase {

    // MARK: - ResearchField Tests

    func testResearchFieldInitialization() {
        let field = ResearchField(
            name: "Test Field",
            description: "Test description",
            keywords: ["test", "field"]
        )

        XCTAssertEqual(field.name, "Test Field")
        XCTAssertEqual(field.description, "Test description")
        XCTAssertEqual(field.keywords.count, 2)
    }

    func testPredefinedResearchFields() {
        XCTAssertFalse(ResearchField.predefinedFields.isEmpty)
        XCTAssertTrue(ResearchField.predefinedFields.contains { $0.name == "Artificial Intelligence" })
    }

    // MARK: - Paper Tests

    func testPaperInitialization() {
        let paper = Paper(
            title: "Test Paper",
            authors: ["Author 1", "Author 2"],
            abstract: "This is a test abstract",
            keywords: ["test", "paper"]
        )

        XCTAssertEqual(paper.title, "Test Paper")
        XCTAssertEqual(paper.authors.count, 2)
        XCTAssertNotNil(paper.abstract)
    }

    func testPaperFormattedAuthors() {
        let singleAuthor = Paper(title: "Test", authors: ["Author 1"])
        XCTAssertEqual(singleAuthor.formattedAuthors, "Author 1")

        let twoAuthors = Paper(title: "Test", authors: ["Author 1", "Author 2"])
        XCTAssertEqual(twoAuthors.formattedAuthors, "Author 1 and Author 2")

        let multipleAuthors = Paper(title: "Test", authors: ["Author 1", "Author 2", "Author 3"])
        XCTAssertEqual(multipleAuthors.formattedAuthors, "Author 1 et al.")
    }

    func testPaperAbstractPreview() {
        let shortAbstract = "Short abstract"
        let paper1 = Paper(title: "Test", authors: [], abstract: shortAbstract)
        XCTAssertEqual(paper1.abstractPreview, shortAbstract)

        let longAbstract = String(repeating: "a", count: 200)
        let paper2 = Paper(title: "Test", authors: [], abstract: longAbstract)
        XCTAssertTrue(paper2.abstractPreview.hasSuffix("..."))
        XCTAssertLessThanOrEqual(paper2.abstractPreview.count, 154)
    }

    // MARK: - Newsletter Tests

    func testNewsletterInitialization() {
        let field = ResearchField.predefinedFields[0]
        let newsletter = Newsletter(
            title: "Test Newsletter",
            researchField: field,
            relatedPapers: [],
            summary: "Test summary"
        )

        XCTAssertEqual(newsletter.title, "Test Newsletter")
        XCTAssertEqual(newsletter.status, .draft)
        XCTAssertEqual(newsletter.totalPapers, 0)
    }

    func testNewsletterTotalPapers() {
        let field = ResearchField.predefinedFields[0]
        let paper1 = Paper(title: "Paper 1", authors: [])
        let paper2 = Paper(title: "Paper 2", authors: [])

        let newsletter = Newsletter(
            title: "Test",
            researchField: field,
            userPaper: paper1,
            relatedPapers: [paper2]
        )

        XCTAssertEqual(newsletter.totalPapers, 2)
    }

    func testNewsletterHTMLGeneration() {
        let field = ResearchField.predefinedFields[0]
        let newsletter = Newsletter(
            title: "Test Newsletter",
            researchField: field,
            summary: "Test summary"
        )

        let html = newsletter.generateHTMLContent()
        XCTAssertTrue(html.contains("<!DOCTYPE html>"))
        XCTAssertTrue(html.contains("Test Newsletter"))
        XCTAssertTrue(html.contains("Test summary"))
    }

    // MARK: - UserProfile Tests

    func testUserProfileInitialization() {
        let profile = UserProfile()

        XCTAssertTrue(profile.preferredFields.isEmpty)
        XCTAssertTrue(profile.uploadedPapers.isEmpty)
        XCTAssertTrue(profile.notificationEnabled)
        XCTAssertEqual(profile.notificationFrequency, .weekly)
    }

    func testUserProfileComplete() {
        var profile = UserProfile()
        XCTAssertFalse(profile.isProfileComplete)

        profile.preferredFields = [ResearchField.predefinedFields[0]]
        XCTAssertTrue(profile.isProfileComplete)
    }

    func testUserProfileKeywords() {
        var profile = UserProfile()
        profile.preferredFields = [
            ResearchField(name: "Field 1", description: "", keywords: ["keyword1", "keyword2"]),
            ResearchField(name: "Field 2", description: "", keywords: ["keyword2", "keyword3"])
        ]

        let keywords = profile.allKeywords
        XCTAssertTrue(keywords.contains("keyword1"))
        XCTAssertTrue(keywords.contains("keyword2"))
        XCTAssertTrue(keywords.contains("keyword3"))
    }
}
