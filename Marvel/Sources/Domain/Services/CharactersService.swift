//
//  CharactersService.swift
//  Marvel
//
//  Created by Diego Rogel on 19/1/22.
//

import Foundation

typealias CharactersServiceError = DataServiceError

typealias CharactersServiceResult = Result<ContentPage<Character>, CharactersServiceError>

protocol CharactersService {
    func characters(from offset: Int) async throws -> ContentPage<Character>
}
