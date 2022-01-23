//
//  CharacterDetailDataTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation
import XCTest
@testable import Marvel_Debug

class CharacterDetailDataTests: XCTestCase {

    private var sut: CharacterDetailData!

    override func setUp() {
        super.setUp()
        sut = CharacterDetailData(name: "name", description: "description")
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_givenOther_areEqualIfNameAndDescriptionAreEqual() {
        let other = CharacterDetailData(name: "name", description: "description")
        XCTAssertEqual(other, sut)
    }

    func test_givenOther_areNotEqualIfNameAndDescriptionAreNotEqual() {
        let other = CharacterDetailData(name: "", description: "description")
        XCTAssertNotEqual(other, sut)
    }
}
