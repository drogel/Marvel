//
//  CharactersClientServiceTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 29/1/22.
//

import XCTest
@testable import Marvel_Debug

class CharactersClientServiceTests: XCTestCase {

    private var sut: CharactersClientService!
    private var networkServiceMock: NetworkServiceMock!
    private var jsonParserMock: JSONParserMock!

    override func setUp() {
        super.setUp()
        jsonParserMock = JSONParserMock()
    }

    override func tearDown() {
        sut = nil
        networkServiceMock = nil
        jsonParserMock = nil
        super.tearDown()
    }

    func test_givenANetworkServiceMock_whenRetrievingCharacters_callsRequest() {
        givenSutWithNetworkServiceMock()
        assertNetworkServiceRequest(callCount: 0)
        whenRetrievingCharactersIgnoringResult()
        assertNetworkServiceRequest(callCount: 1)
    }
}

private extension CharactersClientServiceTests {

    func givenSutWithNetworkServiceMock() {
        networkServiceMock = NetworkServiceMock()
        givenSut(with: networkServiceMock)
    }

    func givenSut(with networkService: NetworkService) {
        sut = CharactersClientService(client: networkService, parser: jsonParserMock)
    }

    func whenRetrievingCharactersIgnoringResult(from offset: Int = 0) {
        let _ = sut.characters(from: offset) { _ in }
    }

    func whenRetrievingCharacters(from offset: Int = 0) -> CharactersServiceResult {
        var charactersResult: CharactersServiceResult!
        let _ = sut.characters(from: offset) { result in
            charactersResult = result
        }
        return charactersResult
    }

    func assertNetworkServiceRequest(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(networkServiceMock.requestCallCount, callCount, line: line)
    }
}
