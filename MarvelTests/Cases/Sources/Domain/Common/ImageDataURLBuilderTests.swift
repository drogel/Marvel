//
//  ImageDataURLBuilderTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 12/2/22.
//

@testable import Marvel_Debug
import XCTest

class ImageDataURLBuilderTests: XCTestCase {
    private var sut: ImageDataURLBuilder!
    private var imageDataStub: ImageData!
    private let imageDataSchemeStub = "http://"
    private let imageDataPathStub = "test.com/test"
    private let imageDataExtensionStub = "jpg"
    private var imageDataFullPathStub: String {
        imageDataSchemeStub + imageDataPathStub
    }

    override func setUp() {
        super.setUp()
        sut = ImageDataURLBuilder()
        imageDataStub = ImageData(path: imageDataFullPathStub, imageExtension: imageDataExtensionStub)
    }

    override func tearDown() {
        sut = nil
        imageDataStub = nil
        super.tearDown()
    }

    func test_whenBuildingURL_returnsHTTPSImageDataPathWithAppendedExtension() {
        let acutalURL = whenBuildingURLFromImageDataStub()
        let expectedURLScheme = "https://"
        let expectedURL = expectedURLScheme + imageDataPathStub + "." + imageDataExtensionStub
        XCTAssertEqual(acutalURL.absoluteString, expectedURL)
    }

    func test_whenBuildingURLWithoutExtension_returnsNil() {
        let imageDataWithoutExtension = ImageData(path: imageDataFullPathStub, imageExtension: nil)
        let actualURL = sut.buildURL(from: imageDataWithoutExtension)
        XCTAssertNil(actualURL)
    }
}

private extension ImageDataURLBuilderTests {
    func whenBuildingURLFromImageDataStub() -> URL {
        try! XCTUnwrap(sut.buildURL(from: imageDataStub))
    }
}
