//
//  CharacterDetailClientServiceTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 29/1/22.
//

@testable import Marvel_Debug
import XCTest

class CharacterDetailClientServiceTests: XCTestCase {
    private var sut: CharacterDetailClientService!
    private var jsonParserMock: JSONParserMock!
    private var networkServiceMock: NetworkServiceMock!
    private var errorHandler: NetworkErrorHandler!

    override func setUp() {
        super.setUp()
        jsonParserMock = JSONParserMock()
        errorHandler = DataServicesNetworkErrorHandler()
    }

    override func tearDown() {
        sut = nil
        jsonParserMock = nil
        networkServiceMock = nil
        errorHandler = nil
        super.tearDown()
    }

    func test_givenANetworkServiceMock_whenRetrievingCharacters_callsRequest() async {
        givenSutWithNetworkServiceMock()
        assertNetworkServiceRequest(callCount: 0)
        await whenRetrievingCharacterIgnoringResult()
        assertNetworkServiceRequest(callCount: 1)
    }

    func test_givenACachingNetworkServiceFake_whenRetrievingCharacter_requestIsCalledWithExpectedComponents() async {
        let characterIdStub = 1234
        let expectedComponentsPath = MarvelAPIPaths.characters.rawValue + "/" + String(characterIdStub)
        givenSutWithNetworkServiceCacherFake()
        await whenRetrievingCharacterIgnoringResult(with: characterIdStub)
        let actualComponents = whenGettingCachedComponentsFromNetworkService()
        XCTAssertEqual(actualComponents.path, expectedComponentsPath)
    }

    func test_givenASucessfulNetworkServiceAndFailingParser_whenRetrievingCharacters_resultIsFailure() async {
        givenFailingParser()
        givenSutWithSuccessfulNetworkService()
        let result = await whenRetrievingCharacter()
        assertIsFailure(result) {
            assert($0, isEqualTo: .emptyData)
        }
    }

    func test_givenASucessfulNetworkServiceAndSuccessfulParser_whenRetrievingCharacters_resultIsSuccess() async {
        givenSuccesfulParser()
        givenSutWithSuccessfulNetworkService()
        let result = await whenRetrievingCharacter()
        assertIsSuccess(result) {
            XCTAssertEqual($0, ContentPage<Character>.empty)
        }
    }

    func test_givenNoConnection_whenRetrievingCharacters_resultIsFailureWithNoConnectionError() async {
        await assertWhenRetrievingCharacter(
            returnsFailureWithError: .noConnection,
            whenNetworkErrorWas: .notConnected
        )
    }

    func test_givenNoAuthentication_whenRetrievingCharacters_resultIsFailureWithUnauthorized() async {
        await assertWhenRetrievingCharacter(
            returnsFailureWithError: .unauthorized,
            whenNetworkErrorWas: .unauthorized
        )
    }

    func test_givenGenericError_whenRetrievingCharacters_resultIsFailureWithEmptyData() async {
        await assertWhenRetrievingCharacter(
            returnsFailureWithError: .emptyData,
            whenNetworkErrorWas: .statusCodeError(statusCode: 500)
        )
    }

    func test_givenFailingNetworkService_whenRetrievingCharacters_delegatesErrorToErrorHandler() async {
        givenErrorHandlerMock()
        givenSutWithFailingNetworkService(providingError: .invalidURL)
        assertErrorHandlerHandle(callCount: 0)
        await whenRetrievingCharacterIgnoringResult()
        assertErrorHandlerHandle(callCount: 1)
    }
}

private extension CharacterDetailClientServiceTests {
    static let dataWrapperResponseStub = DataWrapper<CharacterData>.empty

    func givenSutWithNetworkServiceMock() {
        networkServiceMock = NetworkServiceMock()
        givenSut(with: networkServiceMock)
    }

    func givenSutWithNetworkServiceCacherFake() {
        networkServiceMock = NetworkServiceRequestCacheFake()
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

    func givenSut(with networkService: NetworkService) {
        let resultHandler = ClientResultHandler(parser: jsonParserMock, errorHandler: errorHandler)
        sut = CharacterDetailClientService(
            networkService: networkService,
            networkResultHandler: resultHandler,
            dataResultHandler: CharacterDataResultHandlerFactory.createWithDataMappers()
        )
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

    func whenRetrievingCharacterIgnoringResult(with identifier: Int = 0) async {
        await sut.character(with: identifier) { _ in }
    }

    func whenRetrievingCharacter(with identifier: Int = 0) async -> CharacterDetailServiceResult {
        var characterResult: CharacterDetailServiceResult!
        let expectation = expectation(description: "Received result")
        await sut.character(with: identifier) { result in
            characterResult = result
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
        return characterResult
    }

    func whenGettingCachedComponentsFromNetworkService() -> RequestComponents {
        let cacher = try! XCTUnwrap(networkServiceMock as? NetworkServiceRequestCacheFake)
        return try! XCTUnwrap(cacher.cachedComponents)
    }

    func assertNetworkServiceRequest(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(networkServiceMock.requestCallCount, callCount, line: line)
    }

    func assert(_ actualError: CharacterDetailServiceError, isEqualTo expectedError: CharacterDetailServiceError) {
        if case actualError = expectedError { } else { failExpectingErrorMatching(actualError) }
    }

    func assertWhenRetrievingCharacter(
        returnsFailureWithError expectedError: CharacterDetailServiceError,
        whenNetworkErrorWas networkError: NetworkError,
        line: UInt = #line
    ) async {
        givenSutWithFailingNetworkService(providingError: networkError)
        let result = await whenRetrievingCharacter()
        assertIsFailure(result, then: { assert($0, isEqualTo: expectedError) }, line: line)
    }

    func assertErrorHandlerHandle(callCount: Int, line: UInt = #line) {
        let errorHandlerMock = errorHandler as! NetworkErroHandlerMock
        XCTAssertEqual(errorHandlerMock.handleCallCount, callCount, line: line)
    }
}
