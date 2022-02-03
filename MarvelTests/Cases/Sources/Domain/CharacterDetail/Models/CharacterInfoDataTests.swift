//
//  CharacterInfoDataTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation
@testable import Marvel_Debug
import XCTest

class CharacterInfoDataTests: XCTestCase {
    private var sut: CharacterInfoData!

    override func setUp() {
        super.setUp()
        sut = CharacterInfoData(name: "name", description: "description")
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_givenOther_areEqualIfNameAndDescriptionAreEqual() {
        let other = CharacterInfoData(name: "name", description: "description")
        XCTAssertEqual(other, sut)
    }

    func test_givenOther_areNotEqualIfNameAndDescriptionAreNotEqual() {
        let other = CharacterInfoData(name: "", description: "description")
        XCTAssertNotEqual(other, sut)
    }
}
