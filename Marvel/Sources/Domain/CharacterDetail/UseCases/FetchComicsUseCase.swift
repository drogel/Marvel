//
//  FetchComicsUseCase.swift
//  Marvel
//
//  Created by Diego Rogel on 4/2/22.
//

import Foundation

protocol FetchComicsUseCase {
    func fetch(
        query: FetchComicsQuery,
        completion: @escaping (FetchComicsResult) -> Void
    ) -> Cancellable?
}

struct FetchComicsQuery: Equatable {
    let characterID: Int
    let offset: Int
}

typealias FetchComicsUseCaseError = ComicsServiceError

typealias FetchComicsResult = Result<ContentPage<Comic>, FetchComicsUseCaseError>

class FetchComicsServiceUseCase: FetchComicsUseCase {
    private let service: ComicsService
    private let comicMapper: ComicMapper
    private let pageMapper: PageMapper

    init(service: ComicsService, comicMapper: ComicMapper, pageMapper: PageMapper) {
        self.service = service
        self.comicMapper = comicMapper
        self.pageMapper = pageMapper
    }

    func fetch(
        query: FetchComicsQuery,
        completion: @escaping (FetchComicsResult) -> Void
    ) -> Cancellable? {
        service.comics(for: query.characterID, from: query.offset) { [weak self] result in
            guard let self = self else { return }
            self.handle(result, completion: completion)
        }
    }
}

private extension FetchComicsServiceUseCase {
    func handle(_ result: ComicsServiceResult, completion: @escaping (FetchComicsResult) -> Void) {
        switch result {
        case let .success(dataWrapper):
            completion(buildResult(from: dataWrapper))
        case let .failure(error):
            completion(.failure(error))
        }
    }

    func buildResult(from dataWrapper: DataWrapper<ComicData>) -> FetchComicsResult {
        guard let contentPage = mapToComicsPage(dataWrapper.data) else { return .failure(.emptyData) }
        return .success(contentPage)
    }

    func mapToComicsPage(_ pageData: PageData<ComicData>?) -> ContentPage<Comic>? {
        let comics = mapToComics(pageData?.results)
        guard let pageData = pageData,
              let pageDataCount = pageData.count,
              let pageInfo = pageMapper.mapToPageInfo(pageData),
              pageDataCount == comics.count
        else { return nil }
        return ContentPage(offset: pageInfo.offset, limit: pageInfo.limit, total: pageInfo.total, contents: comics)
    }

    func mapToComics(_ comicsData: [ComicData]?) -> [Comic] {
        guard let comicsData = comicsData else { return [] }
        return comicsData.compactMap(comicMapper.mapToComic)
    }
}
