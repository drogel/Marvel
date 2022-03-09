//
//  CharacterDetailDataSourceFactoryTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 6/3/22.
//

@testable import Marvel_Debug
import XCTest

class CharacterDetailDataSourceFactoryTests: XCTestCase {
    private var sut: CharacterDetailDataSourceFactory!

    override func setUp() {
        super.setUp()
        let presentationModelMock = CharacterDetailPresentationModelMock()
        sut = CharacterDetailDataSourceFactory(presentationModel: presentationModelMock)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_conformsToCharactersDataSourceFactory() {
        XCTAssertTrue((sut as AnyObject) is CharacterDetailDataSourceFactory)
    }

    func test_whenCreating_returnsDataSource() {
        let collectionViewStub = UICollectionViewStub()
        let dataSource = sut.create(collectionView: collectionViewStub)
        XCTAssertTrue(dataSource is CharacterDetailDataSource)
    }
}
