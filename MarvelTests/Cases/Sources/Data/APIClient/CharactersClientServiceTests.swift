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
    private var networkDataHandlerMock: NetworkDataHandlerMock!
    private var errorHandler: NetworkErrorHandler!

    override func setUp() {
        super.setUp()
        jsonParserMock = JSONParserMock()
        networkDataHandlerMock = NetworkDataHandlerMock()
        errorHandler = DataServicesNetworkErrorHandler()
    }

    override func tearDown() {
        sut = nil
        networkDataHandlerMock = nil
        networkServiceMock = nil
        jsonParserMock = nil
        errorHandler = nil
        super.tearDown()
    }

    func test_givenANetworkServiceMock_whenRetrievingCharacters_callsRequest() async {
        givenSutWithNetworkServiceMock()
        assertNetworkServiceRequest(callCount: 0)
        await whenRetrievingCharactersIgnoringResult()
        assertNetworkServiceRequest(callCount: 1)
    }

    func test_givenASucessfulNetworkServiceAndFailingParser_whenRetrievingCharacters_resultIsFailure() async {
        givenFailingDataHandler()
        givenSutWithSuccessfulNetworkService()
        let result = await whenRetrievingCharacters()
        assertIsFailure(result) {
            assert($0, isEqualTo: .emptyData)
        }
    }

    func test_givenACachingNetworkServiceFake_whenRetrievingCharacters_requestIsCalledWithExpectedComponents() async {
        let offsetStub = 40
        let charactersPath = MarvelAPIPaths.characters.rawValue
        let expectedComponentsPath = RequestComponents(
            path: charactersPath,
            queryParameters: ["offset": String(offsetStub)]
        )
        givenSutWithNetworkServiceCacherFake()
        await whenRetrievingCharactersIgnoringResult(from: offsetStub)
        let actualComponents = whenGettingCachedComponentsFromNetworkService()
        XCTAssertEqual(actualComponents, expectedComponentsPath)
    }

    func test_givenASucessfulNetworkServiceAndSuccessfulParser_whenRetrievingCharacters_resultIsSuccess() async {
        givenSuccesfulParser()
        givenSutWithSuccessfulNetworkService()
        let result = await whenRetrievingCharacters()
        assertIsSuccess(result) {
            XCTAssertEqual($0, ContentPage<Character>.empty)
        }
    }

    func test_givenNoConnection_whenRetrievingCharacters_resultIsFailureWithNoConnectionError() async {
        await assertWhenRetrievingCharacters(
            returnsFailureWithError: .noConnection,
            whenNetworkErrorWas: .notConnected
        )
    }

    func test_givenNoAuthentication_whenRetrievingCharacters_resultIsFailureWithUnauthorized() async {
        await assertWhenRetrievingCharacters(
            returnsFailureWithError: .unauthorized,
            whenNetworkErrorWas: .unauthorized
        )
    }

    func test_givenGenericError_whenRetrievingCharacters_resultIsFailureWithEmptyData() async {
        await assertWhenRetrievingCharacters(
            returnsFailureWithError: .emptyData,
            whenNetworkErrorWas: .statusCodeError(statusCode: 500)
        )
    }

    func test_givenFailingNetworkService_whenRetrievingCharacters_delegatesErrorToErrorHandler() async {
        givenErrorHandlerMock()
        givenSutWithFailingNetworkService(providingError: .invalidURL)
        assertErrorHandlerHandle(callCount: 0)
        await whenRetrievingCharactersIgnoringResult()
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

    func givenFailingDataHandler() {
        networkDataHandlerMock = NetworkDataHandlerFailingStub()
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
        sut = CharactersClientService(
            networkService: networkService,
            dataHandler: networkDataHandlerMock,
            networkErrorHandler: errorHandler,
            dataResultHandler: CharacterDataResultHandlerFactory.createWithDataMappers()
        )
    }

    func whenRetrievingCharactersIgnoringResult(from offset: Int = 0) async {
        await sut.characters(from: offset) { _ in }
    }

    func whenRetrievingCharacters(from offset: Int = 0) async -> CharactersServiceResult {
        var charactersResult: CharactersServiceResult!
        let expectation = expectation(description: "Received result")
        await sut.characters(from: offset) { result in
            charactersResult = result
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
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
    ) async {
        givenSutWithFailingNetworkService(providingError: networkError)
        let result = await whenRetrievingCharacters()
        assertIsFailure(result, then: { assert($0, isEqualTo: expectedError) }, line: line)
    }
}
