//
//  CharactersDebugServiceTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 19/1/22.
//

@testable import Marvel_Debug
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
        do {
            try await whenRetrievingCharactersIgnoringResult()
            XCTFail("Expected error")
        } catch {}
    }

    func test_givenSutDataLoader_whenRetrievingCharacters_completesWithSuccess() async {
        givenSutWithDataLoader()
        do {
            try await whenRetrievingCharactersIgnoringResult()
        } catch {
            XCTFail("Did not expect error")
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
