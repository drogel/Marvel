//
//  CharacterInfoModelTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation
@testable import Presentation_CharacterDetail
import XCTest

class CharacterInfoModelTests: XCTestCase {
    private var sut: CharacterDescriptionModel!

    override func setUp() {
        super.setUp()
        sut = CharacterDescriptionModel(name: "name", description: "description")
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_givenOther_areEqualIfNameAndDescriptionAreEqual() {
        let other = CharacterDescriptionModel(name: "name", description: "description")
        XCTAssertEqual(other, sut)
    }

    func test_givenOther_areNotEqualIfNameAndDescriptionAreNotEqual() {
        let other = CharacterDescriptionModel(name: "", description: "description")
        XCTAssertNotEqual(other, sut)
    }
}
