//
//  NetworkServiceFactoryTests.swift
//
//
//  Created by Diego Rogel on 9/7/22.
//

@testable import Data
import XCTest

class NetworkServiceFactoryTests: XCTestCase {
    func test_givenAFactory_WhenCreatingNetworkService_ReturnsExpectedNetworkServiceType() {
        let urlStub = URL(string: "http://example.com")!
        XCTAssertTrue(NetworkServiceFactory.create(baseApiURL: urlStub) is AuthenticatedNetworkService)
    }
}
