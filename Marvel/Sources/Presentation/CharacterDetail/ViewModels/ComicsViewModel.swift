//
//  ComicsViewModel.swift
//  Marvel
//
//  Created by Diego Rogel on 5/2/22.
//

import Combine
import Foundation

protocol ComicsViewModelProtocol: ViewModel {
    var comicCellModelsPublisher: AnyPublisher<[ComicCellModel], Never> { get }
    func willDisplayComicCell(at indexPath: IndexPath)
}

class ComicsViewModel: ComicsViewModelProtocol {
    var comicCellModelsPublisher: AnyPublisher<[ComicCellModel], Never> {
        $publishedComicCellModels.eraseToAnyPublisher()
    }

    @Published private var publishedComicCellModels: [ComicCellModel]
    private let comicsFetcher: FetchComicsUseCase
    private let characterID: Int
    private let imageURLBuilder: ImageURLBuilder
    private let pager: Pager
    private var disposable: Disposable?

    init(comicsFetcher: FetchComicsUseCase, characterID: Int, imageURLBuilder: ImageURLBuilder, pager: Pager) {
        self.comicsFetcher = comicsFetcher
        self.characterID = characterID
        self.imageURLBuilder = imageURLBuilder
        self.pager = pager
        publishedComicCellModels = []
    }

    func start() {
        loadComics(with: startingQuery)
    }

    func willDisplayComicCell(at indexPath: IndexPath) {
        guard shouldLoadMore(at: indexPath) else { return }
        // TODO: Comic pagination seems broken
        loadMore()
    }

    func dispose() {
        disposable?.dispose()
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
        loadComics(with: query(atOffset: publishedComicCellModels.count))
    }

    func loadComics(with query: FetchComicsQuery) {
        disposable?.dispose()
        disposable = comicsFetcher.fetch(query: query) { [weak self] result in
            self?.handle(result)
        }
    }

    func handle(_ result: FetchComicsResult) {
        switch result {
        case let .success(contentPage):
            handleSuccess(with: contentPage)
        case .failure:
            return
        }
    }

    func handleSuccess(with contentPage: ContentPage<Comic>) {
        guard let comicsCellData = mapToCells(comics: contentPage.contents) else { return }
        pager.update(currentPage: contentPage)
        publishedComicCellModels += comicsCellData
    }

    func mapToCells(comics: [Comic]) -> [ComicCellModel]? {
        comics.compactMap(comicCell)
    }

    func comicCell(from comic: Comic) -> ComicCellModel? {
        let imageURL = buildImageURL(from: comic)
        let title = buildTitle(from: comic.title)
        let issueNumber = buildIssueNumber(from: comic.issueNumber)
        return ComicCellModel(title: title, issueNumber: issueNumber, imageURL: imageURL)
    }

    func buildTitle(from title: String) -> String {
        removeIssueNumber(from: title)
    }

    func buildIssueNumber(from issueNumber: Int) -> String {
        let issueNumberString = String(issueNumber)
        return String(format: "issue_number %@".localized, issueNumberString)
    }

    func buildImageURL(from comic: Comic) -> URL? {
        imageURLBuilder.buildURL(from: comic.image, variant: .portraitLarge)
    }

    func removeIssueNumber(from comicTitle: String) -> String {
        comicTitle
            .replacingOccurrences(of: #"\s#\d*"#, with: "", options: .regularExpression)
            .trimmingCharacters(in: .whitespaces)
    }
}
