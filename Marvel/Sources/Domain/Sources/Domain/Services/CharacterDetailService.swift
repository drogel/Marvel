//
//  CharacterDetailService.swift
//  Marvel
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation

public typealias CharacterDetailServiceError = DataServiceError

public protocol CharacterDetailService {
    func character(with identifier: Int) async throws -> ContentPage<Character>
}
