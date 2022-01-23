//
//  CharacterCellDataTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 20/1/22.
//

import XCTest
@testable import Marvel_Debug

class CharacterCellDataTests: XCTestCase {

    private var sut: CharacterCellData!

    override func setUp() {
        super.setUp()
        sut = CharacterCellData(id: 0, name: "name", description: "description")
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_givenOther_areEqualIfIDNameAndDescriptionAreEqual() {
        let other = CharacterCellData(id: 0, name: "name", description: "description")
        XCTAssertEqual(other, sut)
    }

    func test_givenOther_areNotEqualIfIDNameOrDescriptionAreNotEqual() {
        let other = CharacterCellData(id: 0, name: "", description: "description")
        XCTAssertNotEqual(other, sut)
    }
}
