//
//  CharactersService.swift
//  Marvel
//
//  Created by Diego Rogel on 19/1/22.
//

import Foundation

public typealias CharactersServiceError = DataServiceError

public protocol CharactersService {
    func characters(from offset: Int) async throws -> ContentPage<Character>
}
