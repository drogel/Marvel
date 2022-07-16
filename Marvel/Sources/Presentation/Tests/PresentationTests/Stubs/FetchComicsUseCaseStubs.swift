//
//  FetchComicsUseCaseStubs.swift
//
//
//  Created by Diego Rogel on 10/7/22.
//

import Domain
import Foundation

class FetchComicsUseCaseMock: FetchComicsUseCase {
    var fetchCallCount = 0
    var mostRecentQuery: FetchComicsQuery?

    func fetch(query: FetchComicsQuery) async throws -> ContentPage<Comic> {
        fetchCallCount += 1
        mostRecentQuery = query
        return ContentPage<Comic>.empty
    }
}

class FetchComicsUseCaseSuccessfulStub: FetchComicsUseCaseMock {
    static let comicStub = Comic(
        identifier: 0,
        title: "Test #1 Title #1123",
        issueNumber: 1,
        image: Image(path: "", imageExtension: "")
    )
    static let contentPageStub = ContentPage<Comic>.atFirstPageOfTwoTotal(
        contents: [FetchComicsUseCaseSuccessfulStub.comicStub]
    )

    override func fetch(query: FetchComicsQuery) async throws -> ContentPage<Comic> {
        _ = try await super.fetch(query: query)
        return Self.contentPageStub
    }
}

class FetchComicsUseCaseFailureStub: FetchComicsUseCaseMock {
    override func fetch(query _: FetchComicsQuery) async throws -> ContentPage<Comic> {
        throw FetchComicsUseCaseError.emptyData
    }
}
