//
//  DataServicesNetworkErrorHandlerTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 29/1/22.
//

@testable import Marvel_Debug
import XCTest

class DataServicesNetworkErrorHandlerTests: XCTestCase {
    private var sut: DataServicesNetworkErrorHandler!

    override func setUp() {
        super.setUp()
        sut = DataServicesNetworkErrorHandler()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_givenNotConnected_whenHandling_returnsNoConnectionError() {
        assertHandling(.notConnected, returns: .noConnection)
    }

    func test_givenUnauthorized_whenHandling_returnsUnauthorized() {
        assertHandling(.unauthorized, returns: .unauthorized)
    }

    func test_givenOtherError_whenHandling_returnsEmptyData() {
        assertHandling(.invalidURL, returns: .emptyData)
    }
}

private extension DataServicesNetworkErrorHandlerTests {
    func assertHandling(_ networkError: NetworkError, returns dataServiceError: DataServiceError, line: UInt = #line) {
        XCTAssertEqual(sut.handle(networkError), dataServiceError, line: line)
    }
}
