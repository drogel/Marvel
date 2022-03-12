//
//  ComicsPresentationModel.swift
//  Marvel
//
//  Created by Diego Rogel on 5/2/22.
//

import Combine
import Foundation

protocol ComicsPresentationModelProtocol: PresentationModel {
    var comicCellModelsPublisher: AnyPublisher<[ComicCellModel], Never> { get }
    func willDisplayComicCell(at indexPath: IndexPath)
}

protocol ComicsPresentationModelViewDelegate: AnyObject {
    func modelDidStartLoading(_ presentationModel: ComicsPresentationModelProtocol)
    func modelDidFinishLoading(_ presentationModel: ComicsPresentationModelProtocol)
    func modelDidRetrieveData(_ presentationModel: ComicsPresentationModelProtocol)
    func modelDidFailRetrievingData(_ presentationModel: ComicsPresentationModelProtocol)
}

// TODO: Rename to view model when refactor is finished
class ComicsPresentationModel: ComicsPresentationModelProtocol {
    weak var viewDelegate: ComicsPresentationModelViewDelegate?

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
        viewDelegate?.modelDidStartLoading(self)
        loadComics(with: startingQuery)
    }

    func willDisplayComicCell(at indexPath: IndexPath) {
        guard shouldLoadMore(at: indexPath) else { return }
        loadMore()
    }

    func dispose() {
        disposable?.dispose()
    }
}

private extension ComicsPresentationModel {
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
        disposable = comicsFetcher.fetch(query: query, completion: handle)
    }

    func handle(result: FetchComicsResult) {
        viewDelegate?.modelDidFinishLoading(self)
        switch result {
        case let .success(contentPage):
            handleSuccess(with: contentPage)
        case .failure:
            handleFailure()
        }
    }

    func handleSuccess(with contentPage: ContentPage<Comic>) {
        guard let comicsCellData = mapToCells(comics: contentPage.contents) else { return }
        pager.update(currentPage: contentPage)
        publishedComicCellModels += comicsCellData
        viewDelegate?.modelDidRetrieveData(self)
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

    func handleFailure() {
        viewDelegate?.modelDidFailRetrievingData(self)
    }

    func removeIssueNumber(from comicTitle: String) -> String {
        comicTitle
            .replacingOccurrences(of: #"\s#\d*"#, with: "", options: .regularExpression)
            .trimmingCharacters(in: .whitespaces)
    }
}
