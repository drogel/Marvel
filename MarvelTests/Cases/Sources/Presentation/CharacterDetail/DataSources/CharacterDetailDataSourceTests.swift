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
    private var presentationModelMock: CharacterDetailPresentationModelMock!
    private var collectionViewStub: UICollectionViewStub!

    override func setUp() {
        super.setUp()
        collectionViewStub = UICollectionViewStub()
        presentationModelMock = CharacterDetailPresentationModelMock()
        sut = CharacterDetailDataSource(presentationModel: presentationModelMock)
    }

    override func tearDown() {
        sut = nil
        collectionViewStub = nil
        presentationModelMock = nil
        super.tearDown()
    }

    func test_givenViewDidLoad_whenRetrievingCellAtImageSection_callsPresentationModelImageCellData() {
        assertPresentationModelImageCellData(callCount: 0)
        whenRetrievingCell(inSection: .image)
        assertPresentationModelImageCellData(callCount: 1)
    }

    func test_givenViewDidLoad_whenRetrievingCellAtInfoSection_callsPresentationModelInfoCellData() {
        assertPresentationModelInfoCellData(callCount: 0)
        whenRetrievingCell(inSection: .info)
        assertPresentationModelInfoCellData(callCount: 1)
    }

    func test_givenViewDidLoad_whenRetrievingCellAtComicsSection_callsPresentationModelComicCellModel() {
        assertPresentationModelComicCellModel(callCount: 0)
        whenRetrievingCell(inSection: .comics)
        assertPresentationModelComicCellModel(callCount: 1)
    }

    func test_collectionViewHasOneCellPerSectionInImageAndInfoSections() {
        XCTAssertEqual(whenRetrievingNumberOfCells(inSection: .image), 1)
        XCTAssertEqual(whenRetrievingNumberOfCells(inSection: .info), 1)
    }

    func test_collectionViewComicsSectionHasComicsPresentationModelItemsCount() {
        XCTAssertEqual(whenRetrievingNumberOfCells(inSection: .comics), presentationModelMock.numberOfComics)
    }

    func test_numberOfSections_equalsCharacterDetailSectionCasesCount() {
        XCTAssertEqual(sut.numberOfSections(in: collectionViewStub), CharacterDetailSection.allCases.count)
    }

    func test_whenAboutToDisplayAComicCell_notifiesPresentationModel() {
        assertPresentationModelWillDisplayComicCell(callCount: 0)
        whenAboutToDisplayCell(inSection: .comics)
        assertPresentationModelWillDisplayComicCell(callCount: 1)
    }
}

private class CharacterDetailPresentationModelMock: CharacterDetailPresentationModelProtocol {
    var imageCellDataCallCount = 0
    var infoCellDataCallCount = 0
    var comicsSectionTitleCallCount = 0
    var comicCellDataCallCount = 0
    var willDisplayComicCellCallCount = 0

    var comicsSectionTitle: String {
        comicsSectionTitleCallCount += 1
        return ""
    }

    var imageCellData: CharacterImageModel? {
        imageCellDataCallCount += 1
        return nil
    }

    var infoCellData: CharacterInfoModel? {
        infoCellDataCallCount += 1
        return nil
    }

    var numberOfComics: Int {
        0
    }

    func comicCellData(at _: IndexPath) -> ComicCellModel? {
        comicCellDataCallCount += 1
        return nil
    }

    func start() {}

    func willDisplayComicCell(at _: IndexPath) {
        willDisplayComicCellCallCount += 1
    }

    func dispose() {}
}

private extension CharacterDetailDataSourceTests {
    func indexPath(for section: CharacterDetailSection) -> IndexPath {
        IndexPath(row: 0, section: section.rawValue)
    }

    func whenRetrievingCell(inSection section: CharacterDetailSection) {
        _ = sut.collectionView(collectionViewStub, cellForItemAt: indexPath(for: section))
    }

    func whenAboutToDisplayCell(inSection section: CharacterDetailSection) {
        sut.collectionView(collectionViewStub, willDisplay: UICollectionViewCell(), forItemAt: indexPath(for: section))
    }

    func whenRetrievingNumberOfCells(inSection section: CharacterDetailSection) -> Int {
        sut.collectionView(collectionViewStub, numberOfItemsInSection: section.rawValue)
    }

    func assertPresentationModelImageCellData(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(presentationModelMock.imageCellDataCallCount, callCount, line: line)
    }

    func assertPresentationModelInfoCellData(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(presentationModelMock.infoCellDataCallCount, callCount, line: line)
    }

    func assertPresentationModelComicCellModel(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(presentationModelMock.comicCellDataCallCount, callCount, line: line)
    }

    func assertPresentationModelWillDisplayComicCell(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(presentationModelMock.willDisplayComicCellCallCount, callCount, line: line)
    }
}
