//
//  ComicsClientService.swift
//  Marvel
//
//  Created by Diego Rogel on 7/2/22.
//

import Foundation

class ComicsClientService: ComicsService {
    private let charactersPath = MarvelAPIPaths.characters.rawValue
    private let comicsPath = MarvelAPIPaths.comics.rawValue
    private let resultHandler: ResultHandler
    private let networkService: NetworkService
    private let comicMapper: ComicMapper
    private let pageMapper: PageMapper

    init(
        networkService: NetworkService,
        resultHandler: ResultHandler,
        comicMapper: ComicMapper,
        pageMapper: PageMapper
    ) {
        self.resultHandler = resultHandler
        self.networkService = networkService
        self.comicMapper = comicMapper
        self.pageMapper = pageMapper
    }

    func comics(
        for characterID: Int,
        from offset: Int,
        completion: @escaping (ComicsServiceResult) -> Void
    ) -> Cancellable? {
        networkService.request(endpoint: components(for: characterID, offset: offset)) { [weak self] result in
            self?.resultHandler.handle(result: result) { handlerResult in
                self?.completeWithServiceResult(handlerResult, completion: completion)
            }
        }
    }
}

private extension ComicsClientService {
    func components(for characterID: Int, offset: Int) -> RequestComponents {
        let components = RequestComponents().appendingPathComponents([charactersPath, String(characterID), comicsPath])
        return components.withOffsetQuery(offset)
    }

    // TODO: Remove duplication
    func completeWithServiceResult(
        _ handlerResult: DataServiceResult<ComicData>,
        completion: @escaping (ComicsServiceResult) -> Void
    ) {
        switch handlerResult {
        case let .success(dataWrapper):
            completeHandlerSuccess(dataWrapper: dataWrapper, completion: completion)
        case let .failure(error):
            completion(.failure(error))
        }
    }

    func completeHandlerSuccess(
        dataWrapper: DataWrapper<ComicData>,
        completion: @escaping (ComicsServiceResult) -> Void
    ) {
        guard let contentPage = mapToComicsPage(dataWrapper.data) else {
            completion(.failure(.emptyData))
            return
        }
        completion(.success(contentPage))
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
