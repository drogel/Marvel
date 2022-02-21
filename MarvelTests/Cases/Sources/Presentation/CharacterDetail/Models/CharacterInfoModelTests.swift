//
//  CharacterInfoModelTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation
@testable import Marvel_Debug
import XCTest

class CharacterInfoModelTests: XCTestCase {
    private var sut: CharacterInfoModel!

    override func setUp() {
        super.setUp()
        sut = CharacterInfoModel(name: "name", description: "description")
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_givenOther_areEqualIfNameAndDescriptionAreEqual() {
        let other = CharacterInfoModel(name: "name", description: "description")
        XCTAssertEqual(other, sut)
    }

    func test_givenOther_areNotEqualIfNameAndDescriptionAreNotEqual() {
        let other = CharacterInfoModel(name: "", description: "description")
        XCTAssertNotEqual(other, sut)
    }
}
