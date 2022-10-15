//
//  FactoriesTests.swift
//
//
//  Created by Diego Rogel on 9/7/22.
//

@testable import Data
import XCTest

class FactoriesTests: XCTestCase {
    private var urlStub: URL!

    override func setUp() {
        super.setUp()
        urlStub = URL(string: "http://example.com")
    }

    override func tearDown() {
        urlStub = nil
        super.tearDown()
    }

    func test_givenACharactersServiceFactory_WhenCreatingService_ReturnsExpectedServiceType() {
        XCTAssertTrue(CharactersServiceFactory.create(with: urlStub) is CharactersClientService)
    }

    func test_givenACharactersServiceFactory_WhenCreatingDebugService_ReturnsExpectedServiceType() {
        XCTAssertTrue(CharactersServiceFactory.createDebug() is CharactersDebugService)
    }

    func test_givenACharacterDetailServiceFactory_WhenCreatingService_ReturnsExpectedServiceType() {
        let actualService = CharacterDetailServiceFactory.create(with: urlStub)
        XCTAssertTrue(actualService is CharacterDetailClientService)
    }

    func test_givenACharacterDetailServiceFactory_WhenCreatingDebugService_ReturnsExpectedServiceType() {
        XCTAssertTrue(CharacterDetailServiceFactory.createDebug() is CharacterDetailDebugService)
    }

    func test_givenAComicsServiceFactory_WhenCreatingService_ReturnsExpectedServiceType() {
        let actualService = ComicsServiceFactory.create(with: urlStub)
        XCTAssertTrue(actualService is ComicsClientService)
    }

    func test_givenAComicsServiceFactory_WhenCreatingDebugService_ReturnsExpectedServiceType() {
        XCTAssertTrue(ComicsServiceFactory.createDebug() is ComicsDebugService)
    }
}
