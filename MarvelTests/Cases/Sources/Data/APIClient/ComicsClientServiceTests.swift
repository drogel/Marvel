//
//  ComicsClientServiceTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 7/2/22.
//

import CryptoKit
@testable import Marvel_Debug
import XCTest

class ComicsClientServiceTests: XCTestCase {
    private var sut: ComicsClientService!
    private var networkServiceMock: NetworkServiceRequestCacheFake!
    private var resultHandlerMock: ResultHandlerMock!

    override func setUp() {
        super.setUp()
        networkServiceMock = NetworkServiceRequestCacheFake()
        resultHandlerMock = ResultHandlerMock()
        givenSut(with: networkServiceMock)
    }

    override func tearDown() {
        sut = nil
        networkServiceMock = nil
        resultHandlerMock = nil
        super.tearDown()
    }

    func test_conformsToComicsService() {
        XCTAssertTrue((sut as AnyObject) is ComicsService)
    }

    func test_whenRequestingComics_delegatesToNetworkService() {
        assertNetworkServiceRequest(callCount: 0)
        whenRequestingComics()
        assertNetworkServiceRequest(callCount: 1)
    }

    func test_whenRequestingComics_buildsExpectedRequestComponents() {
        let expectedComponents = RequestComponents(
            path: "characters/0/comics",
            queryParameters: ["offset": "0"]
        )
        whenRequestingComics()
        XCTAssertEqual(networkServiceMock.cachedComponents, expectedComponents)
    }

    func test_whenComicsRequestCompletes_delegatesResultHandlingToHandler() {
        givenSutWithSuccessfulNetworkService()
        assertResultHandlerHandle(callCount: 0)
        whenRequestingComics()
        assertResultHandlerHandle(callCount: 1)
    }
}

private extension ComicsClientServiceTests {
    func givenSut(with networkService: NetworkService) {
        sut = ComicsClientService(
            networkService: networkService,
            resultHandler: resultHandlerMock,
            comicMapper: ComicDataMapper(imageMapper: ImageDataMapper()),
            pageMapper: PageDataMapper()
        )
    }

    func givenSutWithSuccessfulNetworkService() {
        let networkServiceStub = NetworkServiceSuccessfulStub()
        givenSut(with: networkServiceStub)
    }

    func whenRequestingComics() {
        _ = sut.comics(for: 0, from: 0, completion: { _ in })
    }

    func assertNetworkServiceRequest(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(networkServiceMock.requestCallCount, callCount, line: line)
    }

    func assertResultHandlerHandle(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(resultHandlerMock.handleCallCount, callCount, line: line)
    }
}
