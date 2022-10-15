//
//  CharactersDebugServiceTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 19/1/22.
//

@testable import Data
import Domain
import XCTest

class CharactersDebugServiceTests: XCTestCase {
    private var sut: CharactersDebugService!

    override func setUp() {
        super.setUp()
        givenSutWithEmptyDataLoader()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_conformsToCharactersService() {
        XCTAssertTrue((sut as AnyObject) is CharactersService)
    }

    func test_givenSutWithEmptyDataLoader_whenRetrievingCharacters_completesWithFailure() async throws {
        givenSutWithEmptyDataLoader()
        await assertThrows {
            try await whenRetrievingCharactersIgnoringResult()
        }
    }

    func test_givenSutDataLoader_whenRetrievingCharacters_completesWithSuccess() async throws {
        givenSutWithDataLoader()
        try await whenRetrievingCharactersIgnoringResult()
    }

    func test_givenSutDataLoader_whenRetrievingCharactersForTheSecondTime_throwsError() async throws {
        givenSutWithDataLoader()
        try await whenRetrievingCharactersIgnoringResult()
        await assertThrows {
            try await whenRetrievingCharactersIgnoringResult()
        }
    }
}

private extension CharactersDebugServiceTests {
    func givenSutWithDataLoader() {
        let jsonDataLoader = JsonDataLoaderStub<CharacterData>()
        givenSut(with: jsonDataLoader)
    }

    func givenSutWithEmptyDataLoader() {
        let jsonDataLoader = JsonDataLoaderEmptyStub()
        givenSut(with: jsonDataLoader)
    }

    func givenSut(with dataLoader: JsonDataLoader) {
        sut = CharactersDebugService(
            dataLoader: dataLoader,
            dataResultHandler: CharacterDataResultHandlerFactory.createWithDataMappers()
        )
    }

    func whenRetrievingCharactersIgnoringResult() async throws {
        _ = try await sut.characters(from: 0)
    }
}
