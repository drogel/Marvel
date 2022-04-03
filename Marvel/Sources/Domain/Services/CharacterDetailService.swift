//
//  CharacterDetailService.swift
//  Marvel
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation

typealias CharacterDetailServiceError = DataServiceError

protocol CharacterDetailService {
    func character(with identifier: Int) async throws -> ContentPage<Character>
}
