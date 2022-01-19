//
//  CharactersService.swift
//  Marvel
//
//  Created by Diego Rogel on 19/1/22.
//

import Foundation

protocol CharactersService {
    func characters(from offset: Int, completion: @escaping (Result<DataWrapper, Error>) -> Void) -> Cancellable?
}
