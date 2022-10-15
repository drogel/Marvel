//
//  ComicsClientServiceTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 7/2/22.
//

import CryptoKit
@testable import Data
import Domain
import XCTest

class ComicsClientServiceTests: XCTestCase {
    private var sut: ComicsClientService!
    private var networkServiceMock: NetworkServiceRequestCacheFake!
    private var networkDataHandlerMock: NetworkDataHandlerMock!

    override func setUp() {
        super.setUp()
        networkServiceMock = NetworkServiceRequestCacheFake()
        networkDataHandlerMock = NetworkDataHandlerMock()
        givenSut(with: networkServiceMock)
    }

    override func tearDown() {
        sut = nil
        networkServiceMock = nil
        networkDataHandlerMock = nil
        super.tearDown()
    }

    func test_conformsToComicsService() {
        XCTAssertTrue((sut as AnyObject) is ComicsService)
    }

    func test_whenRequestingComics_delegatesToNetworkService() async throws {
        assertNetworkServiceRequest(callCount: 0)
        try await whenRequestingComicsIgnoringResult()
        assertNetworkServiceRequest(callCount: 1)
    }

    func test_whenRequestingComics_buildsExpectedRequestComponents() async throws {
        let expectedComponents = RequestComponents(
            path: "characters/0/comics",
            queryParameters: ["offset": "0"]
        )
        try await whenRequestingComicsIgnoringResult()
        XCTAssertEqual(networkServiceMock.cachedComponents, expectedComponents)
    }

    func test_givenASucessfulNetworkService_whenRequestingComics_resultIsSuccess() async throws {
        let expectedComics = ContentPage<Comic>.empty
        givenSutWithSuccessfulNetworkService()
        let actualComics = try await whenRequestingComics()
        XCTAssertEqual(actualComics, expectedComics)
    }
}

private extension ComicsClientServiceTests {
    func givenSut(with networkService: NetworkService) {
        sut = ComicsClientService(
            networkService: networkService,
            dataHandler: networkDataHandlerMock,
            dataResultHandler: ComicDataResultHandlerFactory.createWithDataMappers()
        )
    }

    func givenSutWithSuccessfulNetworkService() {
        let networkServiceStub = NetworkServiceSuccessfulStub()
        givenSut(with: networkServiceStub)
    }

    func whenRequestingComicsIgnoringResult() async throws {
        _ = try await sut.comics(for: 0, from: 0)
    }

    func whenRequestingComics() async throws -> ContentPage<Comic> {
        try await sut.comics(for: 0, from: 0)
    }

    func assertNetworkServiceRequest(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(networkServiceMock.requestCallCount, callCount, line: line)
    }
}
