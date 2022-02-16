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

    func test_givenANetworkServiceMock_whenRetrievingCharacters_callsRequest() {
        givenSutWithNetworkServiceMock()
        assertNetworkServiceRequest(callCount: 0)
        whenRetrievingCharacterIgnoringResult()
        assertNetworkServiceRequest(callCount: 1)
    }

    func test_givenACachingNetworkServiceFake_whenRetrievingCharacter_requestIsCalledWithExpectedComponents() {
        let characterIdStub = 1234
        let expectedComponentsPath = MarvelAPIPaths.characters.rawValue + "/" + String(characterIdStub)
        givenSutWithNetworkServiceCacherFake()
        whenRetrievingCharacterIgnoringResult(with: characterIdStub)
        let actualComponents = whenGettingCachedComponentsFromNetworkService()
        XCTAssertEqual(actualComponents.path, expectedComponentsPath)
    }

    func test_givenASucessfulNetworkServiceAndFailingParser_whenRetrievingCharacters_resultIsFailure() {
        givenFailingParser()
        givenSutWithSuccessfulNetworkService()
        let result = whenRetrievingCharacter()
        assertIsFailure(result) {
            assert($0, isEqualTo: .emptyData)
        }
    }

    func test_givenASucessfulNetworkServiceAndSuccessfulParser_whenRetrievingCharacters_resultIsSuccess() {
        givenSuccesfulParser()
        givenSutWithSuccessfulNetworkService()
        let result = whenRetrievingCharacter()
        assertIsSuccess(result) {
            XCTAssertEqual($0, ContentPage<Character>.empty)
        }
    }

    func test_givenNoConnection_whenRetrievingCharacters_resultIsFailureWithNoConnectionError() {
        assertWhenRetrievingCharacter(
            returnsFailureWithError: .noConnection,
            whenNetworkErrorWas: .notConnected
        )
    }

    func test_givenNoAuthentication_whenRetrievingCharacters_resultIsFailureWithUnauthorized() {
        assertWhenRetrievingCharacter(
            returnsFailureWithError: .unauthorized,
            whenNetworkErrorWas: .unauthorized
        )
    }

    func test_givenGenericError_whenRetrievingCharacters_resultIsFailureWithEmptyData() {
        assertWhenRetrievingCharacter(
            returnsFailureWithError: .emptyData,
            whenNetworkErrorWas: .statusCodeError(statusCode: 500)
        )
    }

    func test_givenFailingNetworkService_whenRetrievingCharacters_delegatesErrorToErrorHandler() {
        givenErrorHandlerMock()
        givenSutWithFailingNetworkService(providingError: .invalidURL)
        assertErrorHandlerHandle(callCount: 0)
        whenRetrievingCharacterIgnoringResult()
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
            client: networkService,
            networkResultHandler: resultHandler,
            dataResultHandler: CharacterDataServiceResultHandler(
                characterMapper: CharacterDataMapper(imageMapper: ImageDataMapper()),
                pageMapper: PageDataMapper()
            )
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

    func whenRetrievingCharacterIgnoringResult(with identifier: Int = 0) {
        _ = sut.character(with: identifier) { _ in }
    }

    func whenRetrievingCharacter(with identifier: Int = 0) -> CharacterDetailServiceResult {
        var characterResult: CharacterDetailServiceResult!
        _ = sut.character(with: identifier) { result in
            characterResult = result
        }
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
    ) {
        givenSutWithFailingNetworkService(providingError: networkError)
        let result = whenRetrievingCharacter()
        assertIsFailure(result, then: { assert($0, isEqualTo: expectedError) }, line: line)
    }

    func assertErrorHandlerHandle(callCount: Int, line: UInt = #line) {
        let errorHandlerMock = errorHandler as! NetworkErroHandlerMock
        XCTAssertEqual(errorHandlerMock.handleCallCount, callCount, line: line)
    }
}
