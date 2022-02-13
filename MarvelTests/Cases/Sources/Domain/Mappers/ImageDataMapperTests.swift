//
//  ImageDataMapperTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 13/2/22.
//

@testable import Marvel_Debug
import XCTest

class ImageDataMapperTests: XCTestCase {
    private var sut: ImageDataMapper!

    override func setUp() {
        super.setUp()
        sut = ImageDataMapper()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_givenValidImageData_mapsToExpectedImage() throws {
        let imageData = ImageData(path: "/test", imageExtension: "jpg")
        let expectedImage = buildExpectedMappedImage(from: imageData)
        let actualImage = try XCTUnwrap(sut.mapToImage(imageData))
        XCTAssertEqual(actualImage, expectedImage)
    }

    func test_givenNotValidImageData_returnsNil() throws {
        let imageData = ImageData(path: nil, imageExtension: nil)
        let actualImage = sut.mapToImage(imageData)
        XCTAssertNil(actualImage)
    }

    func test_givenNilImageData_returnsNil() {
        XCTAssertNil(sut.mapToImage(nil))
    }
}

private extension ImageDataMapperTests {
    func buildExpectedMappedImage(from imageData: ImageData) -> Image {
        Image(path: imageData.path!, imageExtension: imageData.imageExtension!)
    }
}
