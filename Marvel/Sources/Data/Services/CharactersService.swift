//
//  CharactersService.swift
//  Marvel
//
//  Created by Diego Rogel on 19/1/22.
//

import Foundation

typealias CharactersServiceResult = Result<DataWrapper, CharactersServiceError>

enum CharactersServiceError: Error {
    case emptyData
    case unauthorized
}

protocol CharactersService {
    func characters(from offset: Int, completion: @escaping (CharactersServiceResult) -> Void) -> Cancellable?
}
