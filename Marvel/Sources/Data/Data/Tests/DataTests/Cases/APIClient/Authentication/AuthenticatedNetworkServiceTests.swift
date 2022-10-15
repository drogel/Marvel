//
//  AuthenticatedNetworkServiceTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 31/1/22.
//

@testable import Data
import XCTest

class AuthenticatedNetworkServiceTests: XCTestCase {
    private var sut: AuthenticatedNetworkService!
    private var networkServiceMock: NetworkServiceRequestCacheFake!
    private var authenticatorMock: AuthenticatorMock!
    private var componentsStub: RequestComponents!

    override func setUp() {
        super.setUp()
        componentsStub = RequestComponents(path: "")
        networkServiceMock = NetworkServiceRequestCacheFake()
        authenticatorMock = AuthenticatorMock()
        givenSut(with: authenticatorMock)
    }

    override func tearDown() {
        componentsStub = nil
        sut = nil
        networkServiceMock = nil
        authenticatorMock = nil
        super.tearDown()
    }

    func test_givenSutWithNonEmptyAuthenticator_whenRequesting_callsAuthenticate() async throws {
        givenSutWithNonEmptyAuthenticator()
        assertAuthenticatorAuthenticate(callCount: 0)
        try await whenRequestingIgnoringResult()
        assertAuthenticatorAuthenticate(callCount: 1)
    }

    func test_givenAuthenticatorMock_whenRequesting_throwsUnauthorizedError() async throws {
        await assertThrowsError {
            try await whenRequestingIgnoringResult()
        } didCatchErrorBlock: { error in
            if case NetworkError.unauthorized = error { } else { failExpectingErrorMatching(error) }
        }
    }

    func test_givenNonEmptyAuthenticator_whenRequesting_requestsFromInnerNetworkService() async throws {
        givenSutWithNonEmptyAuthenticator()
        assertNetworkServiceRequest(callCount: 0)
        try await whenRequestingIgnoringResult()
        assertNetworkServiceRequest(callCount: 1)
    }

    func test_givenNonEmptyAuthenticator_whenRequesting_componentsContainAuthenticationParams() async throws {
        givenSutWithNonEmptyAuthenticator()
        try await whenRequestingIgnoringResult()
        let expectedComponents = RequestComponents(
            path: componentsStub.path,
            queryParameters: AuthenticatorStub.authenticationParamsStub
        )
        XCTAssertEqual(networkServiceMock.cachedComponents, expectedComponents)
    }
}

private extension AuthenticatedNetworkServiceTests {
    func givenSut(with authenticator: Authenticator) {
        sut = AuthenticatedNetworkService(networkService: networkServiceMock, authenticator: authenticator)
    }

    func givenSutWithNonEmptyAuthenticator() {
        authenticatorMock = AuthenticatorStub()
        givenSut(with: authenticatorMock)
    }

    func whenRequestingIgnoringResult() async throws {
        _ = try await whenRequesting()
    }

    func whenRequesting() async throws -> Data? {
        try await sut.request(endpoint: componentsStub)
    }

    func assertAuthenticatorAuthenticate(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(authenticatorMock.authenticateCallCount, callCount, line: line)
    }

    func assertNetworkServiceRequest(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(networkServiceMock.requestCallCount, callCount, line: line)
    }
}

private class AuthenticatorMock: Authenticator {
    var authenticateCallCount = 0

    func authenticate(with _: TimeInterval) -> [String: String]? {
        authenticateCallCount += 1
        return nil
    }
}

private class AuthenticatorStub: AuthenticatorMock {
    static let authenticationParamsStub = ["testAuthParam": "testAuthKey"]

    override func authenticate(with timestamp: TimeInterval) -> [String: String]? {
        _ = super.authenticate(with: timestamp)
        return Self.authenticationParamsStub
    }
}
