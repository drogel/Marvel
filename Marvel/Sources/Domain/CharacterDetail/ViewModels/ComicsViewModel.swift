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
    private var cancellable: Cancellable?
    private var comics: [ComicCellData]

    var numberOfComics: Int {
        comics.count
    }

    init(comicsFetcher: FetchComicsUseCase, characterID: Int, imageURLBuilder: ImageURLBuilder) {
        self.comicsFetcher = comicsFetcher
        self.characterID = characterID
        self.imageURLBuilder = imageURLBuilder
        comics = []
    }

    func start() {
        viewDelegate?.viewModelDidStartLoading(self)
        loadComics()
    }

    func comicCellData(at indexPath: IndexPath) -> ComicCellData? {
        let row = indexPath.row
        guard comics.indices.contains(row) else { return nil }
        return comics[row]
    }

    func dispose() {
        cancellable?.cancel()
    }
}

private extension ComicsViewModel {
    var startingQuery: FetchComicsQuery {
        FetchComicsQuery(characterID: characterID, offset: 0)
    }

    func loadComics() {
        cancellable?.cancel()
        cancellable = comicsFetcher.fetch(query: startingQuery, completion: handle)
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
        comics = comicsCellData
        viewDelegate?.viewModelDidRetrieveData(self)
    }

    func mapToCells(comicData: [ComicData]?) -> [ComicCellData]? {
        comicData?.compactMap { data in
            guard let title = data.title,
                  let issueNumber = data.issueNumber
            else { return nil }
            let imageURL = buildImageURL(from: data)
            // TODO: Change Issue Number into a readable string, remove issue number from title
            return ComicCellData(title: title, issueNumber: issueNumber, imageURL: imageURL)
        }
    }

    func buildImageURL(from comicData: ComicData) -> URL? {
        guard let thumbnail = comicData.thumbnail else { return nil }
        return imageURLBuilder.buildURL(from: thumbnail)
    }

    func handleFailure() {
        viewDelegate?.viewModelDidFailRetrievingData(self)
    }
}
