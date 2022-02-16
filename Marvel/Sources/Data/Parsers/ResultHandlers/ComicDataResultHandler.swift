//
//  ComicDataResultHandler.swift
//  Marvel
//
//  Created by Diego Rogel on 16/2/22.
//

import Foundation

enum ComicDataResultHandlerFactory {
    static func createWithDataMappers() -> ComicDataResultHandler {
        ComicDataServiceResultHandler(comicMapper: comicMapper, pageMapper: PageDataMapper())
    }

    private static var comicMapper: ComicMapper {
        ComicDataMapper(imageMapper: ImageDataMapper())
    }
}

protocol ComicDataResultHandler {
    func completeWithServiceResult(
        _ handlerResult: DataServiceResult<ComicData>,
        completion: @escaping (Result<ContentPage<Comic>, DataServiceError>) -> Void
    )
}

class ComicDataServiceResultHandler: ComicDataResultHandler {
    private let comicMapper: ComicMapper
    private let pageMapper: PageMapper

    init(comicMapper: ComicMapper, pageMapper: PageMapper) {
        self.comicMapper = comicMapper
        self.pageMapper = pageMapper
    }

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
