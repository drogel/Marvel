//
//  NetworkServiceTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 21/1/22.
//

@testable import Marvel_Debug
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

    func test_givenASuccessfulRequest_whenRequesting_completesSuccessfully() {
        givenSutWithSuccessfulSession()
        let result = whenRequesting()
        assertIsSuccess(result)
    }

    func test_givenAFailingRequest_whenRequesting_completesWithFailure() {
        givenSutWithFailingSession()
        let result = whenRequesting()
        assertIsFailure(result)
    }

    func test_givenASuccessfulRequest_whenRequesting_tellsComposerToComposeURL() {
        givenSutWithSuccessfulSession()
        assertComposerCompose(callCount: 0)
        _ = whenRequesting()
        assertComposerCompose(callCount: 1)
    }

    func test_givenAFailingRequest_whenRequesting_tellsComposerToComposeURL() {
        givenSutWithFailingSession()
        assertComposerCompose(callCount: 0)
        _ = whenRequesting()
        assertComposerCompose(callCount: 1)
    }

    func test_givenAnInvalidURLFromComposer_whenRequesting_failsWithInvalidURL() {
        givenInvalidURLComposer()
        givenSutWithSuccessfulSession()
        let result = whenRequesting()
        assertIsFailure(result) {
            if case NetworkError.invalidURL = $0 { } else { XCTFail() }
        }
    }

    func test_givenAnUnauthorizedHTTPResponse_whenRequesting_failsWithUnauthorized() {
        givenSutWithHTTPResponseSesssion(responseStatusCode: 401)
        let result = whenRequesting()
        assertIsFailure(result) {
            if case NetworkError.unauthorized = $0 { } else { XCTFail() }
        }
    }

    func test_givenAnErrorHTTPResponse_whenRequesting_failsWithStatusCodeError() {
        let errorStatusCode = 500
        givenSutWithHTTPResponseSesssion(responseStatusCode: errorStatusCode)
        let result = whenRequesting()
        assertIsFailure(result) {
            if case NetworkError.statusCodeError(statusCode: errorStatusCode) = $0 { } else { XCTFail() }
        }
    }

    func test_givenIsNotConnected_whenRequesting_failsWithNotConnected() {
        givenSutWithFailingSession(errorStub: URLError(.notConnectedToInternet))
        let result = whenRequesting()
        assertIsFailure(result) {
            if case NetworkError.notConnected = $0 { } else { XCTFail() }
        }
    }

    func test_givenRequestIsCancelled_whenRequesting_failsWithCancelled() {
        givenSutWithFailingSession(errorStub: URLError(.cancelled))
        let result = whenRequesting()
        assertIsFailure(result) {
            if case NetworkError.cancelled = $0 { } else { XCTFail() }
        }
    }

    func test_givenRequestFailsWithURLError_whenRequesting_failsWithRequestError() {
        givenSutWithFailingSession(errorStub: URLError(.badURL))
        let result = whenRequesting()
        assertIsFailure(result) {
            if case NetworkError.requestError = $0 { } else { XCTFail() }
        }
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

    func whenRequesting() -> Result<Data?, NetworkError> {
        var result: Result<Data?, NetworkError>!
        let expectation = expectation(description: "Request completed")
        _ = sut.request(endpoint: componentsStub) { requestResult in
            result = requestResult
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
        return result
    }

    func assertComposerCompose(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(composerMock.composeCallCount, callCount, line: line)
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
    func loadData(from request: URLRequest, completionHandler: @escaping NetworkCompletion) -> URLSessionDataTask {
        completionHandler(Data(base64Encoded: "data"), URLResponse(), nil)
        return URLSession(configuration: .default).dataTask(with: request)
    }
}

private class NetworkSessionFailureStub: NetworkSession {
    private let errorStub: Error

    init(errorStub: Error) {
        self.errorStub = errorStub
    }

    func loadData(from request: URLRequest, completionHandler: @escaping NetworkCompletion) -> URLSessionDataTask {
        completionHandler(nil, nil, errorStub)
        return URLSession(configuration: .default).dataTask(with: request)
    }
}

private class NetworkSessionHTTPResponseStub: NetworkSession {
    private let statusCodeStub: Int

    private var responseStub: HTTPURLResponse {
        let urlStub = URL(string: "https://example.com")!
        return HTTPURLResponse(url: urlStub, statusCode: statusCodeStub, httpVersion: nil, headerFields: nil)!
    }

    init(statusCodeStub: Int) {
        self.statusCodeStub = statusCodeStub
    }

    func loadData(from request: URLRequest, completionHandler: @escaping NetworkCompletion) -> URLSessionDataTask {
        completionHandler(nil, responseStub, nil)
        return URLSession(configuration: .default).dataTask(with: request)
    }
}
