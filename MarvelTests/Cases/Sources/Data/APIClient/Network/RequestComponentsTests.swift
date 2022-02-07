//
//  RequestComponentsTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 7/2/22.
//

@testable import Marvel_Debug
import XCTest

class RequestComponentsTests: XCTestCase {
    private var sut: RequestComponents!

    override func setUp() {
        super.setUp()
        sut = RequestComponents(path: "", queryParameters: [:])
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_givenOtherComponents_areEqualIfPathAndParametersAreEqual() {
        let other = RequestComponents(path: "", queryParameters: [:])
        XCTAssertEqual(sut, other)
    }

    func test_givenOtherComponents_areNotEqualIfPathAndParametersAreNotEqual() {
        let other = RequestComponents(path: "/testPath", queryParameters: [:])
        XCTAssertNotEqual(sut, other)
    }

    func test_emptyConstructor_returnsEmptyPathComponents() {
        XCTAssertEqual(sut, RequestComponents())
    }

    func test_pathComponents_returnsACopyWithAppendedPathComponents() {
        let expectedPathComponents = RequestComponents(path: "testPath/test", queryParameters: [:])
        XCTAssertEqual(sut.appendingPathComponents(["testPath", "test"]), expectedPathComponents)
    }

    func test_givenRequestComponentsWithPath_whenAppendingPathComponents_returnsACopyWithAppendedPathComponents() {
        sut = sut.appendingPathComponents(["testFirst"])
        let expectedPathComponents = RequestComponents(path: "testFirst/testPath/test", queryParameters: [:])
        XCTAssertEqual(sut.appendingPathComponents(["testPath", "test"]), expectedPathComponents)
    }

    func test_withOffsetQuery_returnsACopyWithOffset() {
        let expectedPathComponents = RequestComponents(queryParameters: ["offset": "0"])
        XCTAssertEqual(sut.withOffsetQuery(0), expectedPathComponents)
    }

    func test_givenRequestComponentsWithOffset_withOffsetQuery_overwritesExistingOffset() {
        sut = sut.withOffsetQuery(0)
        let expectedPathComponents = RequestComponents(queryParameters: ["offset": "1"])
        XCTAssertEqual(sut.withOffsetQuery(1), expectedPathComponents)
    }
}
