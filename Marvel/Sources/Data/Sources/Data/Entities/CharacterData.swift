//
//  CharacterData.swift
//  Marvel
//
//  Created by Diego Rogel on 19/1/22.
//

import Foundation

public struct CharacterData: DataObject {
    let identifier: Int?
    let name: String?
    let description: String?
    let modified: String?
    let thumbnail: ImageData?
    let resourceURI: String?

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case description
        case modified
        case thumbnail
        case resourceURI
    }
}
