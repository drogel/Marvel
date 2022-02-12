//
//  ComicCellDataTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 5/2/22.
//

@testable import Marvel_Debug
import XCTest

class ComicCellDataTests: XCTestCase {
    private var sut: ComicCellData!

    override func setUp() {
        super.setUp()
        sut = ComicCellData(title: "TestTitle", issueNumber: "Issue 0", imageURL: nil)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_givenOther_areEqualIfTitleAndIssueNumberAreEqual() {
        let other = ComicCellData(title: "TestTitle", issueNumber: "Issue 0", imageURL: nil)
        XCTAssertEqual(other, sut)
    }

    func test_givenOther_areNotEqualIfTitleAndIssueNumberAreNotEqual() {
        let other = ComicCellData(title: "OtherTitle", issueNumber: "Issue 1", imageURL: nil)
        XCTAssertNotEqual(other, sut)
    }
}
