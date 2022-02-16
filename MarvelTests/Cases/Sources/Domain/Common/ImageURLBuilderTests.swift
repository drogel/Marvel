//
//  ImageURLBuilderTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 12/2/22.
//

@testable import Marvel_Debug
import XCTest

class ImageURLBuilderTests: XCTestCase {
    private var sut: ImageURLBuilder!
    private var imageStub: Image!
    private let imageSchemeStub = "http://"
    private let imageDomainStub = "test.com"
    private let imagePathStub = "/test"
    private let imageExtensionStub = "jpg"
    private var imageFullPathStub: String {
        imageSchemeStub + imageDomainStub + imagePathStub
    }

    override func setUp() {
        super.setUp()
        sut = SecureImageURLBuilder()
        imageStub = Image(path: imageFullPathStub, imageExtension: imageExtensionStub)
    }

    override func tearDown() {
        sut = nil
        imageStub = nil
        super.tearDown()
    }

    func test_whenBuildingURL_returnsHTTPSImagePathWithAppendedExtension() {
        let actualURL = whenBuildingURLFromImageStub()
        let expectedURLScheme = "https://"
        let expectedURL = expectedURLScheme + imageDomainStub + imagePathStub + "." + imageExtensionStub
        XCTAssertEqual(actualURL.absoluteString, expectedURL)
    }

    func test_whenBuildingInvalidURL_returnsNil() {
        let imageWithoutExtension = Image(path: " ", imageExtension: "")
        let actualURL = sut.buildURL(from: imageWithoutExtension)
        XCTAssertNil(actualURL)
    }

    func test_givenAVariant_whenBuildingURL_returnsURLWithAppendedVariant() {
        let actualURL = whenBuildingURL(withVariant: .landscapeLarge)
        let expectedPath = imagePathStub + "/" + ImageVariant.landscapeLarge.rawValue + "." + imageExtensionStub
        XCTAssertEqual(actualURL.path, expectedPath)
    }
}

private extension ImageURLBuilderTests {
    func whenBuildingURLFromImageStub() -> URL {
        try! XCTUnwrap(sut.buildURL(from: imageStub))
    }

    func whenBuildingURL(withVariant variant: ImageVariant) -> URL {
        try! XCTUnwrap(sut.buildURL(from: imageStub, variant: variant))
    }
}
