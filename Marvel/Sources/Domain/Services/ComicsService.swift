//
//  ComicsService.swift
//  Marvel
//
//  Created by Diego Rogel on 4/2/22.
//

import Foundation

typealias ComicsServiceError = DataServiceError

protocol ComicsService {
    func comics(for characterID: Int, from offset: Int) async throws -> ContentPage<Comic>
}
