//
//  ExtensionTests.swift
//  AI for ScientistTests
//
//  Unit tests for utility extensions
//

import XCTest
@testable import AI_for_Scientist

final class ExtensionTests: XCTestCase {

    // MARK: - Date Extensions Tests

    func testDateIsWithinLast() {
        let today = Date()
        XCTAssertTrue(today.isWithinLast(days: 1))

        let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: Date())!
        XCTAssertTrue(threeDaysAgo.isWithinLast(days: 7))
        XCTAssertFalse(threeDaysAgo.isWithinLast(days: 2))
    }

    // MARK: - String Extensions Tests

    func testStringTruncated() {
        let shortString = "Hello"
        XCTAssertEqual(shortString.truncated(to: 10), "Hello")

        let longString = "This is a very long string"
        let truncated = longString.truncated(to: 10)
        XCTAssertTrue(truncated.hasSuffix("..."))
        XCTAssertEqual(truncated.count, 13) // 10 + "..."
    }

    func testStringCleaned() {
        let messy = "  Hello   World  \n  Test  "
        let cleaned = messy.cleaned
        XCTAssertEqual(cleaned, "Hello World Test")
    }

    func testStringContainsAny() {
        let text = "The quick brown fox"
        XCTAssertTrue(text.containsAny(of: ["quick", "slow"]))
        XCTAssertTrue(text.containsAny(of: ["QUICK"])) // Case-insensitive
        XCTAssertFalse(text.containsAny(of: ["dog", "cat"]))
    }

    // MARK: - Array Extensions Tests

    func testRemovingDuplicates() {
        let papers = [
            Paper(id: UUID(), title: "Paper 1", authors: []),
            Paper(id: UUID(), title: "Paper 2", authors: []),
            Paper(id: UUID(), title: "Paper 3", authors: [])
        ]

        // Create array with duplicate
        let withDuplicate = papers + [papers[0]]
        XCTAssertEqual(withDuplicate.count, 4)

        let unique = withDuplicate.removingDuplicates()
        XCTAssertEqual(unique.count, 3)
    }

    // MARK: - URL Extensions Tests

    func testURLIsPDF() {
        let pdfURL = URL(string: "file:///test.pdf")!
        XCTAssertTrue(pdfURL.isPDF)

        let txtURL = URL(string: "file:///test.txt")!
        XCTAssertFalse(txtURL.isPDF)

        let pdfUpperCase = URL(string: "file:///test.PDF")!
        XCTAssertTrue(pdfUpperCase.isPDF)
    }

    // MARK: - Color Extensions Tests

    func testColorFromHex() {
        // Test 6-digit hex
        let color1 = Color(hex: "#FF0000")
        XCTAssertNotNil(color1)

        // Test 3-digit hex
        let color2 = Color(hex: "F00")
        XCTAssertNotNil(color2)

        // Test 8-digit hex (with alpha)
        let color3 = Color(hex: "#FF0000FF")
        XCTAssertNotNil(color3)
    }
}
