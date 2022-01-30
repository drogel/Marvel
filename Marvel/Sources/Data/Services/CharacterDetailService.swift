//
//  CharacterDetailService.swift
//  Marvel
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation

typealias CharacterDetailServiceResult = Result<DataWrapper, CharacterDetailServiceError>

typealias CharacterDetailServiceError = DataServiceError

protocol CharacterDetailService {
    func character(with id: Int, completion: @escaping (CharacterDetailServiceResult) -> Void) -> Cancellable?
}
