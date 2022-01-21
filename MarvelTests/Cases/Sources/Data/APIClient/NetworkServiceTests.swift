//
//  NetworkServiceTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 21/1/22.
//

import XCTest
@testable import Marvel_Debug

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
        let _ = whenRequesting()
        assertComposerCompose(callCount: 1)
    }

    func test_givenAFailingRequest_whenRequesting_tellsComposerToComposeURL() {
        givenSutWithFailingSession()
        assertComposerCompose(callCount: 0)
        let _ = whenRequesting()
        assertComposerCompose(callCount: 1)
    }
}

private extension NetworkServiceTests {

    func givenSutWithSuccessfulSession() {
        givenSut(with: NetworkSessionSuccessfulStub())
    }

    func givenSutWithFailingSession() {
        givenSut(with: NetworkSessionFailureStub())
    }

    func givenSut(with session: NetworkSession) {
        sut = NetworkSessionService(session: session, baseURL: baseURLStub, urlComposer: composerMock)
    }

    func whenRequesting() -> Result<Data?, NetworkError> {
        var result: Result<Data?, NetworkError>!
        let expectation = expectation(description: "Request completed")
        let _ = sut.request(endpoint: componentsStub) { requestResult in
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

    func compose(from baseURL: URL, adding components: RequestComponents) -> URL? {
        composeCallCount += 1
        return URL(string: "https://example.com")
    }
}

private class NetworkSessionSuccessfulStub: NetworkSession {

    func loadData(from request: URLRequest, completionHandler: @escaping NetworkCompletion) -> URLSessionDataTask {
        completionHandler(Data(base64Encoded: "data"), URLResponse(), nil)
        return URLSession(configuration: .default).dataTask(with: request)
    }
}

private class NetworkSessionFailureStub: NetworkSession {

    func loadData(from request: URLRequest, completionHandler: @escaping NetworkCompletion) -> URLSessionDataTask {
        completionHandler(nil, nil, NetworkError.errorStatusCode(statusCode: 400))
        return URLSession(configuration: .default).dataTask(with: request)
    }
}
