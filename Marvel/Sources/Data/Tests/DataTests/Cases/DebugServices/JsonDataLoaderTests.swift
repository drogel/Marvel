//
//  JsonDataLoaderTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 19/1/22.
//

@testable import Data
import XCTest

class JsonDataLoaderTests: XCTestCase {
    private var sut: JsonDecoderDataLoader!

    override func setUp() {
        super.setUp()
        sut = JsonDecoderDataLoader(parser: JSONDecoderParser())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_givenJsonNotFound_returnsNil() {
        let result: DataObjectMock? = sut.load(fromFileNamed: "ThereIsNoJSONWithThisFileName")
        XCTAssertNil(result)
    }

    func test_givenValidDebugJson_returnsData() {
        let fileName = DebugDataFileName.charactersFileName.rawValue
        let result: DataWrapper<CharacterData>? = sut.load(fromFileNamed: fileName)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.code, 200)
    }
}

private class DataObjectMock: DataObject {
    static func == (_: DataObjectMock, _: DataObjectMock) -> Bool {
        true
    }
}
