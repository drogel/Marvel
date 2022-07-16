//
//  NetworkServiceTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 21/1/22.
//

@testable import Data
import XCTest

class NetworkServiceTests: XCTestCase {
    private var sut: NetworkSessionService!
    private var baseURLStub: URL!
    private var composerMock: URLComposerMock!
    private var componentsStub: RequestComponents!

    override func setUp() {
        super.setUp()
        composerMock = URLComposerMock()
        baseURLStub = URL(string: "https://test.com")!
        componentsStub = RequestComponents(path: "/testPath", queryParameters: [:])
    }

    override func tearDown() {
        componentsStub = nil
        composerMock = nil
        baseURLStub = nil
        sut = nil
        super.tearDown()
    }

    func test_givenASuccessfulRequest_whenRequesting_completesSuccessfully() async throws {
        givenSutWithSuccessfulSession()
        let result = try await whenRequesting()
        XCTAssertNotNil(result)
    }

    func test_givenAFailingRequest_whenRequesting_completesWithFailure() async throws {
        givenSutWithFailingSession()
        await assertRequestingThrows()
    }

    func test_givenASuccessfulRequest_whenRequesting_tellsComposerToComposeURL() async throws {
        givenSutWithSuccessfulSession()
        assertComposerCompose(callCount: 0)
        try await whenRequestingIgnoringResult()
        assertComposerCompose(callCount: 1)
    }

    func test_givenAnInvalidURLFromComposer_whenRequesting_failsWithInvalidURL() async throws {
        givenInvalidURLComposer()
        givenSutWithSuccessfulSession()
        await assertThrowsError {
            try await whenRequestingIgnoringResult()
        } didCatchErrorBlock: { error in
            if case NetworkError.invalidURL = error { } else { failExpectingErrorMatching(error) }
        }
    }

    func test_givenAnUnauthorizedHTTPResponse_whenRequesting_failsWithUnauthorized() async throws {
        givenSutWithHTTPResponseSesssion(responseStatusCode: 401)
        await assertThrowsError {
            try await whenRequestingIgnoringResult()
        } didCatchErrorBlock: { error in
            if case NetworkError.unauthorized = error { } else { failExpectingErrorMatching(error) }
        }
    }

    func test_givenAnErrorHTTPResponse_whenRequesting_failsWithStatusCodeError() async throws {
        let errorStatusCode = 500
        givenSutWithHTTPResponseSesssion(responseStatusCode: errorStatusCode)
        await assertThrowsError {
            try await whenRequestingIgnoringResult()
        } didCatchErrorBlock: { error in
            if case NetworkError.statusCodeError(statusCode: errorStatusCode) = error {
            } else {
                failExpectingErrorMatching(error)
            }
        }
    }

    func test_givenIsNotConnected_whenRequesting_failsWithNotConnected() async throws {
        await assertRequestOnSessionFailing(
            with: URLError(.notConnectedToInternet),
            throwsWithCatchErrorBlock: { error in
                if case NetworkError.notConnected = error { } else { failExpectingErrorMatching(error) }
            }
        )
    }

    func test_givenRequestIsCancelled_whenRequesting_failsWithCancelled() async throws {
        await assertRequestOnSessionFailing(
            with: URLError(.cancelled),
            throwsWithCatchErrorBlock: { error in
                if case NetworkError.cancelled = error { } else { failExpectingErrorMatching(error) }
            }
        )
    }

    func test_givenRequestFailsWithURLError_whenRequesting_failsWithRequestError() async throws {
        await assertRequestOnSessionFailing(
            with: URLError(.badURL),
            throwsWithCatchErrorBlock: { error in
                if case NetworkError.requestError = error { } else { failExpectingErrorMatching(error) }
            }
        )
    }

    func test_givenARequestError_whenRequesting_fails() async throws {
        let error = NSError(domain: "", code: 0, userInfo: nil)
        givenSutWithFailingSession(errorStub: NetworkError.requestError(error))
        await assertRequestingThrows()
    }

    func test_givenAGenericError_whenRequesting_fails() async throws {
        let error = NSError(domain: "", code: 0, userInfo: nil)
        givenSutWithFailingSession(errorStub: error)
        await assertRequestingThrows()
    }
}

private extension NetworkServiceTests {
    func givenSutWithSuccessfulSession() {
        givenSut(with: NetworkSessionSuccessfulStub())
    }

    func givenSutWithFailingSession(errorStub: Error = NetworkError.statusCodeError(statusCode: 400)) {
        givenSut(with: NetworkSessionFailureStub(errorStub: errorStub))
    }

    func givenSutWithHTTPResponseSesssion(responseStatusCode: Int) {
        let session = NetworkSessionHTTPResponseStub(statusCodeStub: responseStatusCode)
        givenSut(with: session)
    }

    func givenSut(with session: NetworkSession) {
        sut = NetworkSessionService(session: session, baseURL: baseURLStub, urlComposer: composerMock)
    }

    func givenInvalidURLComposer() {
        composerMock = URLComposerInvalidStub()
    }

    func whenRequesting() async throws -> Data? {
        try await sut.request(endpoint: componentsStub)
    }

    func whenRequestingIgnoringResult() async throws {
        _ = try await whenRequesting()
    }

    func assertRequestingThrows() async {
        await assertThrows { try await whenRequestingIgnoringResult() }
    }

    func assertComposerCompose(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(composerMock.composeCallCount, callCount, line: line)
    }

    func assertRequestOnSessionFailing(
        with errorStub: Error,
        throwsWithCatchErrorBlock didCatchErrorBlock: (Error) -> Void,
        line: UInt = #line,
        file: StaticString = #filePath
    ) async {
        givenSutWithFailingSession(errorStub: errorStub)
        let whenRequestingBlock: () async throws -> Void = { [weak self] in
            try await self?.whenRequestingIgnoringResult()
        }
        await assertThrowsError(whenRequestingBlock, didCatchErrorBlock: didCatchErrorBlock, line: line, file: file)
    }
}

private class URLComposerMock: URLComposer {
    var composeCallCount = 0

    func compose(from _: URL, adding _: RequestComponents) -> URL? {
        composeCallCount += 1
        return URL(string: "https://example.com")
    }
}

private class URLComposerInvalidStub: URLComposerMock {
    override func compose(from baseURL: URL, adding components: RequestComponents) -> URL? {
        _ = super.compose(from: baseURL, adding: components)
        return nil
    }
}

private class NetworkSessionSuccessfulStub: NetworkSession {
    private let dataStub = Data(base64Encoded: "data")!
    private let responseStub = URLResponse()

    func loadData(from _: URLRequest) async throws -> (data: Data, response: URLResponse) {
        return (dataStub, responseStub)
    }
}

private class NetworkSessionFailureStub: NetworkSession {
    private let errorStub: Error

    init(errorStub: Error) {
        self.errorStub = errorStub
    }

    func loadData(from _: URLRequest) async throws -> (data: Data, response: URLResponse) {
        throw errorStub
    }
}

private class NetworkSessionHTTPResponseStub: NetworkSession {
    private let dataStub = Data(base64Encoded: "data")!
    private let statusCodeStub: Int

    private var responseStub: HTTPURLResponse {
        let urlStub = URL(string: "https://example.com")!
        return HTTPURLResponse(url: urlStub, statusCode: statusCodeStub, httpVersion: nil, headerFields: nil)!
    }

    init(statusCodeStub: Int) {
        self.statusCodeStub = statusCodeStub
    }

    func loadData(from _: URLRequest) async throws -> (data: Data, response: URLResponse) {
        (dataStub, responseStub)
    }
}
