//
//  CharactersClientServiceTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 29/1/22.
//

@testable import Data
import Domain
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

    func test_givenANetworkServiceMock_whenRetrievingCharacters_callsRequest() async throws {
        givenSutWithNetworkServiceMock()
        assertNetworkServiceRequest(callCount: 0)
        try await whenRetrievingCharactersIgnoringResult()
        assertNetworkServiceRequest(callCount: 1)
    }

    func test_givenASucessfulNetworkServiceAndFailingParser_whenRetrievingCharacters_resultIsFailure() async {
        let expectedError = CharactersServiceError.emptyData
        givenFailingDataHandler()
        givenSutWithSuccessfulNetworkService()
        await assertWhenRetrievingCharacters(returnsFailureWithError: expectedError)
    }

    func test_givenACachingNetworkServiceFake_whenRetrievingCharacters_requestHasExpectedComponents() async throws {
        let offsetStub = 40
        let charactersPath = MarvelAPIPaths.characters.rawValue
        let expectedComponentsPath = RequestComponents(
            path: charactersPath,
            queryParameters: ["offset": String(offsetStub)]
        )
        givenSutWithNetworkServiceCacherFake()
        try await whenRetrievingCharactersIgnoringResult(from: offsetStub)
        let actualComponents = try whenGettingCachedComponentsFromNetworkService()
        XCTAssertEqual(actualComponents, expectedComponentsPath)
    }

    func test_givenASucessfulNetworkServiceAndSuccessfulParser_whenRetrievingCharacters_resultIsSuccess() async throws {
        let expectedCharacters = ContentPage<Character>.empty
        givenSuccesfulParser()
        givenSutWithSuccessfulNetworkService()
        let actualCharacters = try await whenRetrievingCharacters()
        XCTAssertEqual(actualCharacters, expectedCharacters)
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

    func test_givenInvalidURL_whenRetrievingCharacters_resultIsFailureWithEmptyData() async {
        await assertWhenRetrievingCharacters(
            returnsFailureWithError: .emptyData,
            whenNetworkErrorWas: .invalidURL
        )
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
        errorHandler = NetworkErrorHandlerMock()
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

    func whenRetrievingCharactersIgnoringResult(from offset: Int = 0) async throws {
        _ = try await whenRetrievingCharacters(from: offset)
    }

    func whenRetrievingCharacters(from offset: Int = 0) async throws -> ContentPage<Character> {
        try await sut.characters(from: offset)
    }

    func whenGettingCachedComponentsFromNetworkService() throws -> RequestComponents {
        let cacher = try XCTUnwrap(networkServiceMock as? NetworkServiceRequestCacheFake)
        return try XCTUnwrap(cacher.cachedComponents)
    }

    func assertNetworkServiceRequest(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(networkServiceMock.requestCallCount, callCount, line: line)
    }

    func assertErrorHandlerHandle(callCount: Int, line: UInt = #line) {
        let errorHandlerMock = errorHandler as? NetworkErrorHandlerMock
        XCTAssertEqual(errorHandlerMock?.handleCallCount, callCount, line: line)
    }

    func assertWhenRetrievingCharacters(
        returnsFailureWithError expectedError: CharactersServiceError,
        whenNetworkErrorWas networkError: NetworkError,
        line: UInt = #line
    ) async {
        givenSutWithFailingNetworkService(providingError: networkError)
        await assertWhenRetrievingCharacters(returnsFailureWithError: expectedError, line: line)
    }

    func assertWhenRetrievingCharacters(
        returnsFailureWithError expectedError: CharactersServiceError,
        line: UInt = #line
    ) async {
        let retrievingCharactersBlock: () async throws -> Void = { [weak self] in
            try await self?.whenRetrievingCharactersIgnoringResult()
        }
        await assertThrows(retrievingCharactersBlock, expectedError: expectedError, line: line)
    }
}
