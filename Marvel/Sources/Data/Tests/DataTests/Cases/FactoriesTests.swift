//
//  FactoriesTests.swift
//
//
//  Created by Diego Rogel on 9/7/22.
//

@testable import Data
import XCTest

class FactoriesTests: XCTestCase {
    private var networkServiceMock: NetworkService!

    override func setUp() {
        super.setUp()
        networkServiceMock = NetworkServiceMock()
    }

    override func tearDown() {
        networkServiceMock = nil
        super.tearDown()
    }

    func test_givenANetworkServiceFactory_WhenCreatingNetworkService_ReturnsExpectedNetworkServiceType() {
        let urlStub = URL(string: "http://example.com")!
        XCTAssertTrue(NetworkServiceFactory.create(baseApiURL: urlStub) is AuthenticatedNetworkService)
    }

    func test_givenACharactersServiceFactory_WhenCreatingService_ReturnsExpectedServiceType() {
        XCTAssertTrue(CharactersServiceFactory.create(with: networkServiceMock) is CharactersClientService)
    }

    func test_givenACharactersServiceFactory_WhenCreatingDebugService_ReturnsExpectedServiceType() {
        XCTAssertTrue(CharactersServiceFactory.createDebug() is CharactersDebugService)
    }

    func test_givenACharacterDetailServiceFactory_WhenCreatingService_ReturnsExpectedServiceType() {
        let actualService = CharacterDetailServiceFactory.create(with: networkServiceMock)
        XCTAssertTrue(actualService is CharacterDetailClientService)
    }

    func test_givenACharacterDetailServiceFactory_WhenCreatingDebugService_ReturnsExpectedServiceType() {
        XCTAssertTrue(CharacterDetailServiceFactory.createDebug() is CharacterDetailDebugService)
    }
}
