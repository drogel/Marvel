//
//  CharacterDetailDebugServiceTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 23/1/22.
//

import Domain
import Foundation
@testable import Marvel_Debug
import XCTest

class CharacterDetailDebugServiceTests: XCTestCase {
    private var sut: CharacterDetailDebugService!

    override func setUp() {
        super.setUp()
        givenSutWithEmptyDataLoader()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_conformsToCharacterDetailService() {
        XCTAssertTrue((sut as AnyObject) is CharacterDetailService)
    }

    func test_givenSutWithEmptyDataLoader_whenRetrievingCharacterDetail_completesWithFailure() async throws {
        givenSutWithEmptyDataLoader()
        await assertThrows {
            try await whenRetrievingCharacterDetailIgnoringResult()
        }
    }

    func test_givenSutDataLoader_whenRetrievingCharacterDetail_completesWithSuccess() async throws {
        givenSutWithDataLoader()
        try await whenRetrievingCharacterDetailIgnoringResult()
    }
}

private extension CharacterDetailDebugServiceTests {
    func givenSutWithDataLoader() {
        let jsonDataLoader = JsonDataLoaderStub<CharacterData>()
        givenSut(with: jsonDataLoader)
    }

    func givenSutWithEmptyDataLoader() {
        let jsonDataLoader = JsonDataLoaderEmptyStub()
        givenSut(with: jsonDataLoader)
    }

    func givenSut(with dataLoader: JsonDataLoader) {
        sut = CharacterDetailDebugService(
            dataLoader: dataLoader,
            dataResultHandler: CharacterDataResultHandlerFactory.createWithDataMappers()
        )
    }

    func whenRetrievingResultFromCharacterDetail() async throws -> ContentPage<Character> {
        try await sut.character(with: 123_456)
    }

    func whenRetrievingCharacterDetailIgnoringResult() async throws {
        _ = try await whenRetrievingResultFromCharacterDetail()
    }
}
