//
//  CharacterCellDataTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 20/1/22.
//

@testable import Marvel_Debug
import XCTest

class CharacterCellDataTests: XCTestCase {
    private var sut: CharacterCellData!

    override func setUp() {
        super.setUp()
        sut = CharacterCellData(identifier: 0, name: "name", description: "description")
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_givenOther_areEqualIfIDNameAndDescriptionAreEqual() {
        let other = CharacterCellData(identifier: 0, name: "name", description: "description")
        XCTAssertEqual(other, sut)
    }

    func test_givenOther_areNotEqualIfIDNameOrDescriptionAreNotEqual() {
        let other = CharacterCellData(identifier: 0, name: "", description: "description")
        XCTAssertNotEqual(other, sut)
    }
}
