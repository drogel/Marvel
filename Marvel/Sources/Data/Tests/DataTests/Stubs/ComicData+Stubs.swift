//
//  ComicData+Stubs.swift
//  MarvelTests
//
//  Created by Diego Rogel on 13/2/22.
//

@testable import Data
import Foundation

extension ComicData {
    static let empty = ComicData(identifier: nil, title: nil, issueNumber: nil, thumbnail: nil)

    static let theInitiative = ComicData(
        identifier: 22506,
        title: "Avengers: The Initiative (2007) #19",
        issueNumber: 19,
        thumbnail: ImageData(
            path: "http://i.annihil.us/u/prod/marvel/i/mg/d/03/58dd080719806",
            imageExtension: "jpg"
        )
    )
}
