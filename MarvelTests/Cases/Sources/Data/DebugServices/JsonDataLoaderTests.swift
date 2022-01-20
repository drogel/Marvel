//
//  JsonDataLoaderTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 19/1/22.
//

import XCTest
@testable import Marvel_Debug

class JsonDataLoaderTests: XCTestCase {

    private var sut: JsonDataLoader!

    override func setUp() {
        super.setUp()
        sut = JsonDataLoader()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_givenJsonNotFound_returnsNil() {
        let result: DecodableMock? = sut.load(fromFileNamed: "ThereIsNoJSONWithThisFileName")
        XCTAssertNil(result)
    }

    func test_givenValidDebugJson_returnsData() {
        let fileName = DebugDataFileName.charactersFileName.rawValue
        let result: DataWrapper? = sut.load(fromFileNamed: fileName)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.code, 200)
    }
}

private class DecodableMock: Decodable { }
