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
    private let imageDataDomainStub = "test.com"
    private let imageDataPathStub = "/test"
    private let imageDataExtensionStub = "jpg"
    private var imageDataFullPathStub: String {
        imageDataSchemeStub + imageDataDomainStub + imageDataPathStub
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
        let actualURL = whenBuildingURLFromImageDataStub()
        let expectedURLScheme = "https://"
        let expectedURL = expectedURLScheme + imageDataDomainStub + imageDataPathStub + "." + imageDataExtensionStub
        XCTAssertEqual(actualURL.absoluteString, expectedURL)
    }

    func test_whenBuildingURLWithoutExtension_returnsNil() {
        let imageDataWithoutExtension = ImageData(path: imageDataFullPathStub, imageExtension: nil)
        let actualURL = sut.buildURL(from: imageDataWithoutExtension)
        XCTAssertNil(actualURL)
    }

    func test_givenAVariant_whenBuildingURL_returnsURLWithAppendedVariant() {
        let actualURL = whenBuildingURL(withVariant: .landscapeLarge)
        let expectedPath = imageDataPathStub + "/" + ImageVariant.landscapeLarge.rawValue + "." + imageDataExtensionStub
        XCTAssertEqual(actualURL.path, expectedPath)
    }
}

private extension ImageDataURLBuilderTests {
    func whenBuildingURLFromImageDataStub() -> URL {
        try! XCTUnwrap(sut.buildURL(from: imageDataStub))
    }

    func whenBuildingURL(withVariant variant: ImageVariant) -> URL {
        try! XCTUnwrap(sut.buildURL(from: imageDataStub, variant: variant))
    }
}
