//
//  ClientDataHandlerTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 22/3/22.
//

@testable import Marvel_Debug
import XCTest

class ClientDataHandlerTests: XCTestCase {
    private var sut: ClientDataHandler!
    private var jsonParserMock: JSONParserMock!

    override func setUp() {
        super.setUp()
        jsonParserMock = JSONParserMock()
        givenSut(with: jsonParserMock)
    }

    override func tearDown() {
        sut = nil
        jsonParserMock = nil
        super.tearDown()
    }

    func test_givenNilData_whenHandling_throwsEmptyDataError() {
        assertThrowsEmptyDataErrorWhenHandling()
    }

    func test_givenFailingParser_whenHandling_throwsEmptyDataError() {
        givenSutWithFailingParser()
        assertThrowsEmptyDataErrorWhenHandling()
    }

    func test_givenSuccessfulParse_whenHandling_returnsExpectedDataWrapper() throws {
        let expectedContent: DataWrapper<String> = DataWrapper.empty
        givenSutWithSuccessfulParser(returnedContentStub: expectedContent)
        let actualDataWrapper: DataWrapper<String> = try sut.handle("".data(using: .utf8))
        XCTAssertEqual(expectedContent, actualDataWrapper)
    }
}

private extension ClientDataHandlerTests {
    func givenSut(with parser: JSONParserMock) {
        sut = ClientDataHandler(parser: parser)
    }

    func givenSutWithFailingParser() {
        jsonParserMock = JSONParserFailingStub()
        givenSut(with: jsonParserMock)
    }

    func givenSutWithSuccessfulParser(returnedContentStub: DataWrapper<String>) {
        jsonParserMock = JSONParserSuccessfulStub(dataStub: returnedContentStub)
        givenSut(with: jsonParserMock)
    }

    func assertThrowsEmptyDataErrorWhenHandling() {
        let expectedError = DataServiceError.emptyData
        do {
            let _: DataWrapper<Int> = try sut.handle(nil)
            failExpectingErrorMatching(expectedError)
        } catch let error as DataServiceError {
            XCTAssertEqual(expectedError, error)
        } catch {
            failExpectingErrorMatching(expectedError)
        }
    }
}
