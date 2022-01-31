//
//  AuthenticatorTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 20/1/22.
//

@testable import Marvel_Debug
import XCTest

class AuthenticatorTests: XCTestCase {
    private var sut: MD5Authenticator!
    private var secretsStub: SecretsRetrieverStub!

    override func setUp() {
        super.setUp()
        secretsStub = SecretsRetrieverStub()
        sut = MD5Authenticator(secrets: secretsStub)
    }

    override func tearDown() {
        secretsStub = nil
        sut = nil
        super.tearDown()
    }

    func test_whenAuthenticating_returnsMD5DigestOfTimestampPrivateKeyAndPublicKey() {
        let timestamp: Double = 1
        let expectedTsParameter = String(Int(timestamp))
        let result = sut.authenticate(with: timestamp)
        let expectedParameters = [
            "hash": "ffd275c5130566a2916217b101f26150",
            "apikey": SecretsRetrieverStub.publicKeyStub,
            "ts": expectedTsParameter,
        ]
        XCTAssertEqual(result, expectedParameters)
    }

    func test_givenEmptySecrets_whenAuthenticating_returnsNil() {
        givenSutWithEmptySecrets()
        XCTAssertNil(sut.authenticate(with: 1))
    }
}

private extension AuthenticatorTests {
    func givenSutWithEmptySecrets() {
        sut = MD5Authenticator(secrets: SecretsRetrieverEmptyStub())
    }
}

private class SecretsRetrieverStub: SecretsRetriever {
    static let publicKeyStub = "1234"
    static let privateKeyStub = "abcd"

    var publicKey: String? {
        Self.publicKeyStub
    }

    var privateKey: String? {
        Self.privateKeyStub
    }
}

private class SecretsRetrieverEmptyStub: SecretsRetriever {
    var publicKey: String? {
        nil
    }

    var privateKey: String? {
        nil
    }
}
