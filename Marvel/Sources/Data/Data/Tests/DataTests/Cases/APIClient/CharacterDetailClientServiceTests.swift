//
//  CharacterDetailClientServiceTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 29/1/22.
//

@testable import Data
import Domain
import TestUtils
import XCTest

class CharacterDetailClientServiceTests: XCTestCase {
    private var sut: CharacterDetailClientService!
    private var networkServiceMock: NetworkServiceMock!
    private var dataHandlerMock: NetworkDataHandlerMock!
    private var errorHandlerMock: NetworkErrorHandlerMock!
    private var errorHandler: NetworkErrorHandler!

    override func setUp() {
        super.setUp()
        dataHandlerMock = NetworkDataHandlerMock()
        errorHandlerMock = NetworkErrorHandlerMock()
        errorHandler = DataServicesNetworkErrorHandler()
    }

    override func tearDown() {
        sut = nil
        dataHandlerMock = nil
        errorHandlerMock = nil
        networkServiceMock = nil
        errorHandler = nil
        super.tearDown()
    }

    func test_givenANetworkServiceMock_whenRetrievingCharacters_callsRequest() async throws {
        givenSutWithNetworkServiceMock()
        assertNetworkServiceRequest(callCount: 0)
        try await whenRetrievingCharacterIgnoringResult()
        assertNetworkServiceRequest(callCount: 1)
    }

    func test_givenACachingNetworkServiceFake_whenRetrievingCharacter_requestsWithExpectedComponents() async throws {
        let characterIdStub = 1234
        let expectedComponentsPath = MarvelAPIPaths.characters.rawValue + "/" + String(characterIdStub)
        givenSutWithNetworkServiceCacherFake()
        try await whenRetrievingCharacterIgnoringResult(with: characterIdStub)
        let actualComponents = try whenGettingCachedComponentsFromNetworkService()
        XCTAssertEqual(actualComponents.path, expectedComponentsPath)
    }

    func test_givenASucessfulNetworkServiceAndFailingDataHandler_whenRetrievingCharacters_throws() async throws {
        givenFailingDataHandler()
        givenSutWithSuccessfulNetworkService()
        await assertThrows({
            try await whenRetrievingCharacterIgnoringResult()
        }, expectedError: CharacterDetailServiceError.emptyData)
    }

    func test_givenASucessfulNetworkService_whenRetrievingCharacters_succeeds() async throws {
        givenSutWithSuccessfulNetworkService()
        let actualContentPage = try await whenRetrievingCharacter()
        XCTAssertEqual(actualContentPage, ContentPage<Character>.empty)
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
        try? await whenRetrievingCharacterIgnoringResult()
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
        errorHandlerMock = NetworkErrorHandlerMock(errorStub: DataServicesNetworkErrorHandler().handle(error))
        givenSut(with: networkServiceMock)
    }

    func givenSut(with networkService: NetworkService) {
        sut = CharacterDetailClientService(
            networkService: networkService,
            dataHandler: dataHandlerMock,
            networkErrorHandler: errorHandlerMock,
            dataResultHandler: CharacterDataResultHandlerFactory.createWithDataMappers()
        )
    }

    func givenFailingDataHandler() {
        dataHandlerMock = NetworkDataHandlerFailingStub()
    }

    func givenErrorHandlerMock() {
        errorHandler = NetworkErrorHandlerMock()
    }

    func whenRetrievingCharacterIgnoringResult(with identifier: Int = 0) async throws {
        _ = try await whenRetrievingCharacter(with: identifier)
    }

    func whenRetrievingCharacter(with identifier: Int = 0) async throws -> ContentPage<Character> {
        try await sut.character(with: identifier)
    }

    func whenGettingCachedComponentsFromNetworkService() throws -> RequestComponents {
        let cacher = try XCTUnwrap(networkServiceMock as? NetworkServiceRequestCacheFake)
        return try XCTUnwrap(cacher.cachedComponents)
    }

    func assertNetworkServiceRequest(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(networkServiceMock.requestCallCount, callCount, line: line)
    }

    func assertError(_ actualError: CharacterDetailServiceError, isEqualTo expectedError: CharacterDetailServiceError) {
        if case actualError = expectedError { } else { failExpectingErrorMatching(actualError) }
    }

    func assertWhenRetrievingCharacter(
        returnsFailureWithError expectedError: CharacterDetailServiceError,
        whenNetworkErrorWas networkError: NetworkError,
        line: UInt = #line
    ) async {
        givenSutWithFailingNetworkService(providingError: networkError)
        let whenRetrievingCharacterBlock: () async throws -> Void = { [weak self] in
            guard let self = self else { return }
            try await self.whenRetrievingCharacterIgnoringResult()
        }
        await assertThrows(whenRetrievingCharacterBlock, expectedError: expectedError, line: line)
    }

    func assertErrorHandlerHandle(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(errorHandlerMock.handleCallCount, callCount, line: line)
    }
}
