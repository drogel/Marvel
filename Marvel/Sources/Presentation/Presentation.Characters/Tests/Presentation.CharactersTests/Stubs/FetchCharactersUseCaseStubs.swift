//
//  FetchCharactersUseCaseStub.swift
//
//
//  Created by Diego Rogel on 10/7/22.
//

import Domain
import DomainTestUtils
import Foundation
@testable import Presentation_Characters

class FetchCharactersUseCaseSuccessfulStub: FetchCharactersUseCaseMock {
    static let charactersStub = [Character.aginar]
    static let contentPageStub = ContentPage<Character>.atFirstPageOfTwoTotal(contents: charactersStub)

    override func fetch(query: FetchCharactersQuery) async throws -> ContentPage<Character> {
        _ = try await super.fetch(query: query)
        return Self.contentPageStub
    }
}

class FetchCharactersUseCaseEmptyStub: FetchCharactersUseCaseMock {
    override func fetch(query: FetchCharactersQuery) async throws -> ContentPage<Character> {
        _ = try await super.fetch(query: query)
        return ContentPage<Character>.empty
    }
}

class FetchCharactersUseCaseFailingStub: FetchCharactersUseCaseMock {
    override func fetch(query: FetchCharactersQuery) async throws -> ContentPage<Character> {
        _ = try await super.fetch(query: query)
        throw FetchComicsUseCaseError.unauthorized
    }
}
