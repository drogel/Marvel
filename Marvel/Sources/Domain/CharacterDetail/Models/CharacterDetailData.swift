//
//  CharacterDetailData.swift
//  Marvel
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation

struct CharacterDetailData: Hashable {
    let name: String
    let description: String
    let imageURL: URL?

    init(name: String, description: String, imageURL: URL? = nil) {
        self.name = name
        self.description = description
        self.imageURL = imageURL
    }
}
