//
//  ComicsViewModel.swift
//  Marvel
//
//  Created by Diego Rogel on 5/2/22.
//

import Foundation

protocol ComicsViewModelProtocol: ViewModel {}

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
    private var cancellable: Cancellable?

    init(comicsFetcher: FetchComicsUseCase, characterID: Int) {
        self.comicsFetcher = comicsFetcher
        self.characterID = characterID
    }

    func start() {
        viewDelegate?.viewModelDidStartLoading(self)
        loadComics()
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
        case .success(let pageInfo):
            handleSuccess(with: pageInfo)
        case .failure(_):
            handleFailure()
        }
    }

    func handleSuccess(with pageInfo: PageInfo<ComicData>) {
        viewDelegate?.viewModelDidRetrieveData(self)
    }

    func handleFailure() {
        viewDelegate?.viewModelDidFailRetrievingData(self)
    }
}
