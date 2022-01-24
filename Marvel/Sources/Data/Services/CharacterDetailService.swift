//
//  CharacterDetailService.swift
//  Marvel
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation

typealias CharacterDetailServiceResult = Result<DataWrapper, CharacterDetailServiceError>

enum CharacterDetailServiceError: Error {
    case noSuchCharacter
    case unauthorized
    case noConnection
}

protocol CharacterDetailService {
    func character(with id: Int, completion: @escaping (CharacterDetailServiceResult) -> Void) -> Cancellable?
}
