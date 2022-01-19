//
//  CharacterData.swift
//  Marvel
//
//  Created by Diego Rogel on 19/1/22.
//

import Foundation

struct CharacterData: Codable, Equatable {
    let id: Int?
    let name: String?
    let description: String?
    let modified: String?
    let thumbnail: ImageData?
    let resourceURI: String?
}
