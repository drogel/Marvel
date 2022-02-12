//
//  ComicsViewModel.swift
//  Marvel
//
//  Created by Diego Rogel on 5/2/22.
//

import Foundation

protocol ComicsViewModelProtocol: ViewModel {
    var numberOfComics: Int { get }
    func comicCellData(at indexPath: IndexPath) -> ComicCellData?
    func willDisplayComicCell(at indexPath: IndexPath)
}

protocol ComicsViewModelViewDelegate: AnyObject {
    func viewModelDidStartLoading(_ viewModel: ComicsViewModelProtocol)
    func viewModelDidFinishLoading(_ viewModel: ComicsViewModelProtocol)
    func viewModelDidRetrieveData(_ viewModel: ComicsViewModelProtocol)
    func viewModelDidFailRetrievingData(_ viewModel: ComicsViewModelProtocol)
}

class ComicsViewModel: ComicsViewModelProtocol {
    weak var viewDelegate: ComicsViewModelViewDelegate?

    private let comicsFetcher: FetchComicsUseCase
    private let characterID: Int
    private let imageURLBuilder: ImageURLBuilder
    private let pager: Pager
    private var cancellable: Cancellable?
    private var comics: [ComicCellData]

    var numberOfComics: Int {
        comics.count
    }

    init(comicsFetcher: FetchComicsUseCase, characterID: Int, imageURLBuilder: ImageURLBuilder, pager: Pager) {
        self.comicsFetcher = comicsFetcher
        self.characterID = characterID
        self.imageURLBuilder = imageURLBuilder
        self.pager = pager
        comics = []
    }

    func start() {
        viewDelegate?.viewModelDidStartLoading(self)
        loadComics(with: startingQuery)
    }

    func comicCellData(at indexPath: IndexPath) -> ComicCellData? {
        let row = indexPath.row
        guard comics.indices.contains(row) else { return nil }
        return comics[row]
    }

    func willDisplayComicCell(at indexPath: IndexPath) {
        guard shouldLoadMore(at: indexPath) else { return }
        loadMore()
    }

    func dispose() {
        cancellable?.cancel()
    }
}

private extension ComicsViewModel {
    var startingQuery: FetchComicsQuery {
        query(atOffset: 0)
    }

    func shouldLoadMore(at indexPath: IndexPath) -> Bool {
        pager.isAtEndOfCurrentPageWithMoreContent(indexPath.row)
    }

    func query(atOffset offset: Int) -> FetchComicsQuery {
        FetchComicsQuery(characterID: characterID, offset: offset)
    }

    func loadMore() {
        loadComics(with: query(atOffset: comics.count))
    }

    func loadComics(with query: FetchComicsQuery) {
        cancellable?.cancel()
        cancellable = comicsFetcher.fetch(query: query, completion: handle)
    }

    func handle(result: FetchComicsResult) {
        viewDelegate?.viewModelDidFinishLoading(self)
        switch result {
        case let .success(pageInfo):
            handleSuccess(with: pageInfo)
        case .failure:
            handleFailure()
        }
    }

    func handleSuccess(with pageInfo: PageInfo<ComicData>) {
        guard let comicsCellData = mapToCells(comicData: pageInfo.results) else { return }
        pager.update(currentPage: pageInfo)
        comics.append(contentsOf: comicsCellData)
        viewDelegate?.viewModelDidRetrieveData(self)
    }

    func mapToCells(comicData: [ComicData]?) -> [ComicCellData]? {
        comicData?.compactMap(comicCell)
    }

    func comicCell(from comicData: ComicData) -> ComicCellData? {
        guard let dataTitle = comicData.title, let dataIssueNumber = comicData.issueNumber else { return nil }
        let imageURL = buildImageURL(from: comicData)
        let title = buildTitle(from: dataTitle)
        let issueNumber = buildIssueNumber(from: dataIssueNumber)
        return ComicCellData(title: title, issueNumber: issueNumber, imageURL: imageURL)
    }

    func buildTitle(from title: String) -> String {
        removeIssueNumber(from: title)
    }

    func buildIssueNumber(from issueNumber: Int) -> String {
        let issueNumberString = String(issueNumber)
        return String(format: "issue_number %@".localized, issueNumberString)
    }

    func buildImageURL(from comicData: ComicData) -> URL? {
        guard let thumbnail = comicData.thumbnail else { return nil }
        return imageURLBuilder.buildURL(from: thumbnail, variant: .portraitLarge)
    }

    func handleFailure() {
        viewDelegate?.viewModelDidFailRetrievingData(self)
    }

    func removeIssueNumber(from comicTitle: String) -> String {
        comicTitle
            .replacingOccurrences(of: #"\s#\d*"#, with: "", options: .regularExpression)
            .trimmingCharacters(in: .whitespaces)
    }
}
