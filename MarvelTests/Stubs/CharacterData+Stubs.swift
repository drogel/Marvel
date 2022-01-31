//
//  CharacterData+Stubs.swift
//  MarvelTests
//
//  Created by Diego Rogel on 20/1/22.
//

import Foundation
@testable import Marvel_Debug

extension CharacterData {
    static let empty = CharacterData(
        identifier: nil,
        name: nil,
        description: nil,
        modified: nil,
        thumbnail: nil,
        resourceURI: nil
    )

    static let aginar = CharacterData(
        identifier: 1_011_175,
        name: "Aginar",
        description: "",
        modified: "1969-12-31T19:00:00-0500",
        thumbnail: ImageData(
            path: "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available",
            imageExtension: "jpg"
        ),
        resourceURI: "http://gateway.marvel.com/v1/public/characters/1011175"
    )
}
