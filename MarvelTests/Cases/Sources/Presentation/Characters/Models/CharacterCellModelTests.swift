//
//  CharacterCellModelTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 20/1/22.
//

@testable import Marvel_Debug
import XCTest

class CharacterCellModelTests: XCTestCase {
    private var sut: CharacterCellModel!

    override func setUp() {
        super.setUp()
        sut = CharacterCellModel(identifier: 0, name: "name", description: "description")
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_givenOther_areEqualIfIDNameAndDescriptionAreEqual() {
        let other = CharacterCellModel(identifier: 0, name: "name", description: "description")
        XCTAssertEqual(other, sut)
    }

    func test_givenOther_areNotEqualIfIDNameOrDescriptionAreNotEqual() {
        let other = CharacterCellModel(identifier: 0, name: "", description: "description")
        XCTAssertNotEqual(other, sut)
    }
}
