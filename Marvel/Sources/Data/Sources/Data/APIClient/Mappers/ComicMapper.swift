//
//  ComicMapper.swift
//  Marvel
//
//  Created by Diego Rogel on 13/2/22.
//

import Domain
import Foundation

public protocol ComicMapper {
    func mapToComic(_ data: ComicData) -> Comic?
}

public class ComicDataMapper: ComicMapper {
    private let imageMapper: ImageMapper

    public init(imageMapper: ImageMapper) {
        self.imageMapper = imageMapper
    }

    public func mapToComic(_ data: ComicData) -> Comic? {
        guard let identifier = data.identifier,
              let title = data.title,
              let issueNumber = data.issueNumber,
              let image = imageMapper.mapToImage(data.thumbnail)
        else { return nil }
        return Comic(identifier: identifier, title: title, issueNumber: issueNumber, image: image)
    }
}
