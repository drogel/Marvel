//
//  CharactersDataSourceFactoryTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 4/3/22.
//

@testable import Marvel_Debug
import XCTest

class CharactersDataSourceFactoryTests: XCTestCase {
    private var sut: CharactersDataSourceFactory!

    override func setUp() {
        super.setUp()
        let viewModelMock = CharactersViewModelMock()
        sut = CharactersDataSourceFactory(viewModel: viewModelMock)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_conformsToCharactersDataSourceFactory() {
        XCTAssertTrue((sut as AnyObject) is CharactersDataSourceFactory)
    }

    func test_whenCreating_returnsDataSource() {
        let collectionViewStub = UICollectionViewStub()
        let dataSource = sut.create(collectionView: collectionViewStub)
        XCTAssertTrue(dataSource is CharactersDataSource)
    }
}
