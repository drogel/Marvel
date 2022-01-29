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

    func test_givenASucessfulNetworkServiceAndFailingParser_whenRetrievingCharacters_resultIsFailure() {
        givenFailingParser()
        givenSutWithSuccessfulNetworkService()
        let result = whenRetrievingCharacters()
        assertIsFailure(result) {
            assert($0, isEqualTo: .emptyData)
        }
    }

    func test_givenASucessfulNetworkServiceAndSuccessfulParser_whenRetrievingCharacters_resultIsSuccess() {
        givenSuccesfulParser()
        givenSutWithSuccessfulNetworkService()
        let result = whenRetrievingCharacters()
        assertIsSuccess(result) {
            XCTAssertEqual($0, Self.dataWrapperResponseStub)
        }
    }

    func test_givenNoConnection_whenRetrievingCharacters_resultIsFailureWithNoConnectionError() {
        assertWhenRetrievingCharacters(
            returnsFailureWithError: .noConnection,
            whenNetworkErrorWas: .notConnected
        )
    }

    func test_givenNoAuthentication_whenRetrievingCharacters_resultIsFailureWithUnauthorized() {
        assertWhenRetrievingCharacters(
            returnsFailureWithError: .unauthorized,
            whenNetworkErrorWas: .unauthorized
        )
    }

    func test_givenGenericError_whenRetrievingCharacters_resultIsFailureWithEmptyData() {
        assertWhenRetrievingCharacters(
            returnsFailureWithError: .emptyData,
            whenNetworkErrorWas: .statusCodeError(statusCode: 500)
        )
    }
}

private extension CharactersClientServiceTests {

    static let dataWrapperResponseStub = DataWrapper.withNilData

    func givenSutWithNetworkServiceMock() {
        networkServiceMock = NetworkServiceMock()
        givenSut(with: networkServiceMock)
    }

    func givenSutWithSuccessfulNetworkService() {
        networkServiceMock = NetworkServiceSuccessfulStub()
        givenSut(with: networkServiceMock)
    }

    func givenSutWithFailingNetworkService(providingError error: NetworkError) {
        networkServiceMock = NetworkServiceFailingStub(errorStub: error)
        givenSut(with: networkServiceMock)
    }

    func givenFailingParser() {
        jsonParserMock = JSONParserFailingStub()
    }

    func givenSuccesfulParser() {
        jsonParserMock = JSONParserSuccessfulStub<DataWrapper>(dataStub: Self.dataWrapperResponseStub)
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

    func assert(_ actualError: CharactersServiceError, isEqualTo expectedError: CharactersServiceError) {
        if case actualError = expectedError { } else { XCTFail() }
    }

    func assertWhenRetrievingCharacters(returnsFailureWithError expectedError: CharactersServiceError, whenNetworkErrorWas networkError: NetworkError, line: UInt = #line) {
        givenSutWithFailingNetworkService(providingError: networkError)
        let result = whenRetrievingCharacters()
        assertIsFailure(result, then: { assert($0, isEqualTo: expectedError) }, line: line)
    }
}
