//
//  FactoriesTests.swift
//
//
//  Created by Diego Rogel on 9/7/22.
//

@testable import Data
import XCTest

class FactoriesTests: XCTestCase {
    func test_givenANetworkServiceFactory_WhenCreatingNetworkService_ReturnsExpectedNetworkServiceType() {
        let urlStub = URL(string: "http://example.com")!
        XCTAssertTrue(NetworkServiceFactory.create(baseApiURL: urlStub) is AuthenticatedNetworkService)
    }

    func test_givenACharactersServiceFactory_WhenCreatingService_ReturnsExpectedServiceType() {
        let networkServiceMock = NetworkServiceMock()
        XCTAssertTrue(CharactersServiceFactory.create(with: networkServiceMock) is CharactersClientService)
    }

    func test_givenACharactersServiceFactory_WhenCreatingDebugService_ReturnsExpectedServiceType() {
        XCTAssertTrue(CharactersServiceFactory.createDebug() is CharactersDebugService)
    }
}
