//
//  FetchCharacterDetailUseCaseStubs.swift
//
//
//  Created by Diego Rogel on 10/7/22.
//

import Domain
import Foundation

class FetchCharacterDetailUseCaseMock: FetchCharacterDetailUseCase {
    var fetchCallCount = 0
    var fetchCallCountsForID: [Int: Int] = [:]

    func fetch(query: FetchCharacterDetailQuery) async throws -> ContentPage<Character> {
        fetchCallCount += 1
        fetchCallCountsForID[query.characterID] = fetchCallCountsForID[query.characterID] ?? 0 + 1
        return ContentPage<Character>.empty
    }

    func fetchCallCount(withID identifier: Int) -> Int {
        guard let fetchCallCountForID = fetchCallCountsForID[identifier] else { return 0 }
        return fetchCallCountForID
    }
}

class FetchCharacterDetailUseCaseSuccessfulStub: FetchCharacterDetailUseCaseMock {
    static let resultsStub = [Character.aginar]
    static let pageDataStub = ContentPage<Character>.zeroWith(contents: resultsStub)

    override func fetch(query: FetchCharacterDetailQuery) async throws -> ContentPage<Character> {
        _ = try await super.fetch(query: query)
        return Self.pageDataStub
    }
}

class FetchCharacterDetailUseCaseFailingStub: FetchCharacterDetailUseCaseMock {
    override func fetch(query _: FetchCharacterDetailQuery) async throws -> ContentPage<Character> {
        throw FetchCharacterDetailUseCaseError.unauthorized
    }
}
