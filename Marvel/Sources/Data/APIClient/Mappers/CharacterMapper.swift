//
//  CharacterMapper.swift
//  Marvel
//
//  Created by Diego Rogel on 13/2/22.
//

import Foundation

protocol CharacterMapper {
    func mapToCharacter(_ data: CharacterData) -> Character?
}

class CharacterDataMapper: CharacterMapper {
    private let imageMapper: ImageMapper

    init(imageMapper: ImageMapper) {
        self.imageMapper = imageMapper
    }

    func mapToCharacter(_ data: CharacterData) -> Character? {
        guard let identifier = data.identifier,
              let name = data.name,
              let description = data.description,
              let image = imageMapper.mapToImage(data.thumbnail)
        else { return nil }
        return Character(identifier: identifier, name: name, description: description, image: image)
    }
}
