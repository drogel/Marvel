//
//  ComicDataTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 4/2/22.
//

@testable import Marvel_Debug
import XCTest

class ComicDataTests: XCTestCase {
    typealias ParseableObjectType = ComicData

    func test_givenComicDataFromJson_parsesExpectedValues() {
        runParsingTest()
    }
}

extension ComicDataTests: ParsingTestCaseTemplate {
    func buildExpectedObject() -> ComicData {
        let imageData = buildExpectedImageData()
        return buildExpectedCharacterData(with: imageData)
    }
}

private extension ComicDataTests {
    func buildExpectedImageData() -> ImageData {
        let imageData = ImageData(
            path: "http://i.annihil.us/u/prod/marvel/i/mg/d/03/58dd080719806",
            imageExtension: "jpg"
        )
        return imageData
    }

    func buildExpectedCharacterData(with imageData: ImageData) -> ComicData {
        let comicData = ComicData(
            identifier: 22506,
            title: "Avengers: The Initiative (2007) #19",
            issueNumber: 19,
            thumbnail: imageData
        )
        return comicData
    }
}
