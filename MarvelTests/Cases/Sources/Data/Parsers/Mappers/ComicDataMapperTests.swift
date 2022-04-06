//
//  ComicDataMapperTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 13/2/22.
//

import Domain
@testable import Marvel_Debug
import XCTest

class ComicDataMapperTests: XCTestCase {
    private var sut: ComicDataMapper!
    private var imageMapper: ImageMapper!

    override func setUp() {
        super.setUp()
        imageMapper = ImageDataMapper()
        sut = ComicDataMapper(imageMapper: imageMapper)
    }

    override func tearDown() {
        sut = nil
        imageMapper = nil
        super.tearDown()
    }

    func test_conformsToComicMapper() {
        XCTAssertTrue((sut as AnyObject) is ComicMapper)
    }

    func test_givenValidComicData_mapsToExpectedComic() throws {
        let comicData = ComicData.theInitiative
        let expectedComic = buildExpectedMappedComic(from: comicData)
        let actualComic = try XCTUnwrap(sut.mapToComic(comicData))
        XCTAssertEqual(actualComic, expectedComic)
    }

    func test_givenNotValidComicData_returnsNil() throws {
        let comicData = ComicData.empty
        let actualComic = sut.mapToComic(comicData)
        XCTAssertNil(actualComic)
    }
}

private extension ComicDataMapperTests {
    func buildExpectedMappedComic(from comicData: ComicData) -> Comic {
        Comic(
            identifier: comicData.identifier!,
            title: comicData.title!,
            issueNumber: comicData.issueNumber!,
            image: imageMapper.mapToImage(comicData.thumbnail!)!
        )
    }
}
