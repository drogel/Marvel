//
//  ComicsViewModel.swift
//  Marvel
//
//  Created by Diego Rogel on 5/2/22.
//

import Combine
import Domain
import Foundation

protocol ComicsViewModelProtocol: ViewModel {
    var comicCellModelsPublisher: AnyPublisher<[ComicCellModel], Never> { get }
    func willDisplayComicCell(at indexPath: IndexPath) async
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

    init(comicsFetcher: FetchComicsUseCase, characterID: Int, imageURLBuilder: ImageURLBuilder, pager: Pager) {
        self.comicsFetcher = comicsFetcher
        self.characterID = characterID
        self.imageURLBuilder = imageURLBuilder
        self.pager = pager
        publishedComicCellModels = []
    }

    func start() async {
        await loadComics(with: startingQuery)
    }

    func willDisplayComicCell(at indexPath: IndexPath) async {
        guard shouldLoadMore(at: indexPath) else { return }
        await loadMore()
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

    func loadMore() async {
        await loadComics(with: query(atOffset: publishedComicCellModels.count))
    }

    func loadComics(with query: FetchComicsQuery) async {
        do {
            let contentPage = try await comicsFetcher.fetch(query: query)
            handleSuccess(with: contentPage)
        } catch {
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
        let identifier = String(comic.identifier)
        return ComicCellModel(identifier: identifier, title: title, issueNumber: issueNumber, imageURL: imageURL)
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
