//
//  FetchCharactersUseCaseMock.swift
//
//
//  Created by Diego Rogel on 10/7/22.
//

import Domain
import Foundation
@testable import Presentation_Characters

class FetchCharactersUseCaseMock: FetchCharactersUseCase {
    var fetchCallCount = 0
    var mostRecentQuery: FetchCharactersQuery?

    func fetch(query: FetchCharactersQuery) async throws -> ContentPage<Character> {
        fetchCallCount += 1
        mostRecentQuery = query
        return ContentPage<Character>.empty
    }
}
