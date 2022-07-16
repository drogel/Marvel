//
//  URLComponentsBuilderTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 1/2/22.
//

@testable import Data
import XCTest

class URLComponentsBuilderTests: XCTestCase {
    private var sut: URLComponentsBuilder!
    private var baseURL: URL!

    override func setUp() {
        super.setUp()
        baseURL = URL(string: "https://test.com")!
        sut = URLComponentsBuilder()
    }

    override func tearDown() {
        baseURL = nil
        sut = nil
        super.tearDown()
    }

    func test_givenEmptyComponents_whenComposingURL_returnsBaseURL() {
        assertCompose(with: RequestComponents.empty, returnsExcludingBaseURL: "")
    }

    func test_givenPath_whenComposingURL_returnsBaseURLAppendingPath() {
        let pathComponents = RequestComponents(path: "path")
        assertCompose(with: pathComponents, returnsExcludingBaseURL: "/path?")
    }

    func test_givenQueries_whenComposingURL_returnsBaseURLAppendingQueries() {
        let queryComponents = RequestComponents(path: "", queryParameters: ["queryKey": "queryValue"])
        assertCompose(with: queryComponents, returnsExcludingBaseURL: "/?queryKey=queryValue")
    }

    func test_givenPathAndQueries_whenComposingURL_returnsBaseURLAppendingPathAndQueries() {
        let components = RequestComponents(path: "path", queryParameters: ["queryKey": "queryValue"])
        assertCompose(with: components, returnsExcludingBaseURL: "/path?queryKey=queryValue")
    }
}

private extension URLComponentsBuilderTests {
    func assertCompose(
        with components: RequestComponents,
        returnsExcludingBaseURL expected: String,
        line: UInt = #line
    ) {
        let expectedURL = baseURL.absoluteString + expected
        let actualURL = sut.compose(from: baseURL, adding: components)?.absoluteString
        XCTAssertEqual(expectedURL, actualURL, line: line)
    }
}
