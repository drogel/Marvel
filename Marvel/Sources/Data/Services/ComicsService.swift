//
//  ComicsService.swift
//  Marvel
//
//  Created by Diego Rogel on 4/2/22.
//

import Foundation

typealias ComicsServiceError = DataServiceError

typealias ComicsServiceResult = Result<DataWrapper<ComicData>, ComicsServiceError>

protocol ComicsService {
    func comics(
        for characterID: Int,
        from offset: Int,
        completion: @escaping (ComicsServiceResult) -> Void
    ) -> Cancellable?
}