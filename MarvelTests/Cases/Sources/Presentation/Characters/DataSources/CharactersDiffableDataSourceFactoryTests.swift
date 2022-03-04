//
//  CharactersDiffableDataSourceFactoryTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 4/3/22.
//

@testable import Marvel_Debug
import XCTest

class CharactersDiffableDataSourceFactoryTests: XCTestCase {
    private var sut: CharactersDiffableDataSourceFactory!

    override func setUp() {
        super.setUp()
        sut = CharactersDiffableDataSourceFactory()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_conformsToCharactersDataSourceFactory() {
        XCTAssertTrue((sut as AnyObject) is CharactersDataSourceFactory)
    }

    func test_whenCreating_returnsDiffableDataSource() {
        let collectionViewStub = UICollectionViewStub()
        let presentationModelMock = CharactersPresentationModelMock()
        let dataSource = sut.create(collectionView: collectionViewStub, presentationModel: presentationModelMock)
        XCTAssertTrue(dataSource is CharactersDataSource)
    }
}
