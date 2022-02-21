//
//  CharactersClientServiceTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 29/1/22.
//

@testable import Marvel_Debug
import XCTest

class CharactersClientServiceTests: XCTestCase {
    private var sut: CharactersClientService!
    private var networkServiceMock: NetworkServiceMock!
    private var jsonParserMock: JSONParserMock!
    private var errorHandler: NetworkErrorHandler!

    override func setUp() {
        super.setUp()
        jsonParserMock = JSONParserMock()
        errorHandler = DataServicesNetworkErrorHandler()
    }

    override func tearDown() {
        sut = nil
        networkServiceMock = nil
        jsonParserMock = nil
        errorHandler = nil
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

    func test_givenACachingNetworkServiceFake_whenRetrievingCharacters_requestIsCalledWithExpectedComponents() {
        let offsetStub = 40
        let charactersPath = MarvelAPIPaths.characters.rawValue
        let expectedComponentsPath = RequestComponents(
            path: charactersPath,
            queryParameters: ["offset": String(offsetStub)]
        )
        givenSutWithNetworkServiceCacherFake()
        whenRetrievingCharactersIgnoringResult(from: offsetStub)
        let actualComponents = whenGettingCachedComponentsFromNetworkService()
        XCTAssertEqual(actualComponents, expectedComponentsPath)
    }

    func test_givenASucessfulNetworkServiceAndSuccessfulParser_whenRetrievingCharacters_resultIsSuccess() {
        givenSuccesfulParser()
        givenSutWithSuccessfulNetworkService()
        let result = whenRetrievingCharacters()
        assertIsSuccess(result) {
            XCTAssertEqual($0, ContentPage<Character>.empty)
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

    func test_givenFailingNetworkService_whenRetrievingCharacters_delegatesErrorToErrorHandler() {
        givenErrorHandlerMock()
        givenSutWithFailingNetworkService(providingError: .invalidURL)
        assertErrorHandlerHandle(callCount: 0)
        whenRetrievingCharactersIgnoringResult()
        assertErrorHandlerHandle(callCount: 1)
    }
}

private extension CharactersClientServiceTests {
    static let dataWrapperResponseStub = DataWrapper<CharacterData>.empty

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
        jsonParserMock = JSONParserSuccessfulStub<DataWrapper<CharacterData>>(dataStub: Self.dataWrapperResponseStub)
    }

    func givenErrorHandlerMock() {
        errorHandler = NetworkErroHandlerMock()
    }

    func givenSutWithNetworkServiceCacherFake() {
        networkServiceMock = NetworkServiceRequestCacheFake()
        givenSut(with: networkServiceMock)
    }

    func givenSut(with networkService: NetworkService) {
        let resultHandler = ClientResultHandler(parser: jsonParserMock, errorHandler: errorHandler)
        sut = CharactersClientService(
            client: networkService,
            resultHandler: resultHandler,
            dataResultHandler: CharacterDataResultHandlerFactory.createWithDataMappers()
        )
    }

    func whenRetrievingCharactersIgnoringResult(from offset: Int = 0) {
        _ = sut.characters(from: offset) { _ in }
    }

    func whenRetrievingCharacters(from offset: Int = 0) -> CharactersServiceResult {
        var charactersResult: CharactersServiceResult!
        _ = sut.characters(from: offset) { result in
            charactersResult = result
        }
        return charactersResult
    }

    func whenGettingCachedComponentsFromNetworkService() -> RequestComponents {
        let cacher = try! XCTUnwrap(networkServiceMock as? NetworkServiceRequestCacheFake)
        return try! XCTUnwrap(cacher.cachedComponents)
    }

    func assertNetworkServiceRequest(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(networkServiceMock.requestCallCount, callCount, line: line)
    }

    func assertErrorHandlerHandle(callCount: Int, line: UInt = #line) {
        let errorHandlerMock = errorHandler as! NetworkErroHandlerMock
        XCTAssertEqual(errorHandlerMock.handleCallCount, callCount, line: line)
    }

    func assert(_ actualError: CharactersServiceError, isEqualTo expectedError: CharactersServiceError) {
        if case actualError = expectedError { } else { failExpectingErrorMatching(actualError) }
    }

    func assertWhenRetrievingCharacters(
        returnsFailureWithError expectedError: CharactersServiceError,
        whenNetworkErrorWas networkError: NetworkError,
        line: UInt = #line
    ) {
        givenSutWithFailingNetworkService(providingError: networkError)
        let result = whenRetrievingCharacters()
        assertIsFailure(result, then: { assert($0, isEqualTo: expectedError) }, line: line)
    }
}
