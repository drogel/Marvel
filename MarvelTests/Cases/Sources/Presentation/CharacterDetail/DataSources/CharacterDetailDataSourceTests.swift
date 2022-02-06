//
//  CharacterDetailDataSourceTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 3/2/22.
//

@testable import Marvel_Debug
import XCTest

class CharacterDetailDataSourceTests: XCTestCase {
    private var sut: CharacterDetailDataSource!
    private var viewModelMock: CharacterDetailViewModelMock!
    private var collectionViewStub: UICollectionViewStub!

    override func setUp() {
        super.setUp()
        collectionViewStub = UICollectionViewStub()
        viewModelMock = CharacterDetailViewModelMock()
        sut = CharacterDetailDataSource(viewModel: viewModelMock)
        sut.registerSubviews(in: collectionViewStub)
    }

    override func tearDown() {
        sut = nil
        collectionViewStub = nil
        viewModelMock = nil
        super.tearDown()
    }

    func test_givenViewDidLoad_whenRetrievingCellAtImageSection_callsViewModelImageCellData() {
        assertViewModelImageCellData(callCount: 0)
        whenRetrievingCell(inSection: .image)
        assertViewModelImageCellData(callCount: 1)
    }

    func test_givenViewDidLoad_whenRetrievingCellAtInfoSection_callsViewModelInfoCellData() {
        assertViewModelInfoCellData(callCount: 0)
        whenRetrievingCell(inSection: .info)
        assertViewModelInfoCellData(callCount: 1)
    }

    func test_givenViewDidLoad_whenRetrievingCellAtComicsSection_callsViewModelComicCellData() {
        assertViewModelComicCellData(callCount: 0)
        whenRetrievingCell(inSection: .comics)
        assertViewModelComicCellData(callCount: 1)
    }

    func test_collectionViewHasOneCellPerSectionInImageAndInfoSections() {
        XCTAssertEqual(whenRetrievingNumberOfCells(inSection: .image), 1)
        XCTAssertEqual(whenRetrievingNumberOfCells(inSection: .info), 1)
    }

    func test_collectionViewComicsSectionHasComicsViewModelItemsCount() {
        XCTAssertEqual(whenRetrievingNumberOfCells(inSection: .comics), viewModelMock.numberOfComics)
    }

    func test_numberOfSections_equalsCharacterDetailSectionCasesCount() {
        XCTAssertEqual(sut.numberOfSections(in: collectionViewStub), CharacterDetailSection.allCases.count)
    }
}

private class CharacterDetailViewModelMock: CharacterDetailViewModelProtocol {
    var imageCellDataCallCount = 0
    var infoCellDataCallCount = 0
    var comicsSectionTitleCallCount = 0
    var comicCellDataCallCount = 0

    var comicsSectionTitle: String {
        comicsSectionTitleCallCount += 1
        return ""
    }

    var imageCellData: CharacterImageData? {
        imageCellDataCallCount += 1
        return nil
    }

    var infoCellData: CharacterInfoData? {
        infoCellDataCallCount += 1
        return nil
    }

    var numberOfComics: Int {
        0
    }

    func comicCellData(at _: IndexPath) -> ComicCellData? {
        comicCellDataCallCount += 1
        return nil
    }

    func start() {}

    func dispose() {}
}

private extension CharacterDetailDataSourceTests {
    func indexPath(for section: CharacterDetailSection) -> IndexPath {
        IndexPath(row: 0, section: section.rawValue)
    }

    func whenRetrievingCell(inSection section: CharacterDetailSection) {
        _ = sut.collectionView(collectionViewStub, cellForItemAt: indexPath(for: section))
    }

    func whenRetrievingNumberOfCells(inSection section: CharacterDetailSection) -> Int {
        sut.collectionView(collectionViewStub, numberOfItemsInSection: section.rawValue)
    }

    func assertViewModelImageCellData(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(viewModelMock.imageCellDataCallCount, callCount, line: line)
    }

    func assertViewModelInfoCellData(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(viewModelMock.infoCellDataCallCount, callCount, line: line)
    }

    func assertViewModelComicCellData(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(viewModelMock.comicCellDataCallCount, callCount, line: line)
    }
}
