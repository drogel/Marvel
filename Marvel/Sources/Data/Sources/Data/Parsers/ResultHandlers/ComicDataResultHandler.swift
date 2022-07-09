//
//  ComicDataResultHandler.swift
//  Marvel
//
//  Created by Diego Rogel on 16/2/22.
//

import Domain
import Foundation

public enum ComicDataResultHandlerFactory {
    public static func createWithDataMappers() -> ComicDataResultHandler {
        ComicDataServiceResultHandler(comicMapper: comicMapper, pageMapper: PageDataMapper())
    }

    private static var comicMapper: ComicMapper {
        ComicDataMapper(imageMapper: ImageDataMapper())
    }
}

public protocol ComicDataResultHandler {
    func handle(_ dataWrapper: DataWrapper<ComicData>) throws -> ContentPage<Comic>
}

public class ComicDataServiceResultHandler: ComicDataResultHandler {
    private let comicMapper: ComicMapper
    private let pageMapper: PageMapper

    public init(comicMapper: ComicMapper, pageMapper: PageMapper) {
        self.comicMapper = comicMapper
        self.pageMapper = pageMapper
    }

    public func handle(_ dataWrapper: DataWrapper<ComicData>) throws -> ContentPage<Comic> {
        guard let contentPage = mapToComicsPage(dataWrapper.data) else { throw DataServiceError.emptyData }
        return contentPage
    }
}

private extension ComicDataServiceResultHandler {
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
