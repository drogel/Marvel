//
//  CharacterCellData.swift
//  Marvel
//
//  Created by Diego Rogel on 20/1/22.
//

import Foundation

struct CharacterCellData: Hashable {
    let identifier: Int
    let name: String
    let description: String
    let imageURL: URL?

    init(identifier: Int, name: String, description: String, imageURL: URL? = nil) {
        self.identifier = identifier
        self.name = name
        self.description = description
        self.imageURL = imageURL
    }
}
