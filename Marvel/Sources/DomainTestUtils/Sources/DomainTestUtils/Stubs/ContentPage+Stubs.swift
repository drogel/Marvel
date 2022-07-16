//
//  ContentPage+Stubs.swift
//  MarvelTests
//
//  Created by Diego Rogel on 13/2/22.
//

import Domain
import Foundation

public extension ContentPage {
    static var empty: ContentPage<Content> {
        ContentPage<Content>.zeroWith(contents: [])
    }

    static func zeroWith(contents: [Content]) -> ContentPage<Content> {
        ContentPage<Content>(offset: 0, limit: 0, total: 0, contents: contents)
    }

    static func atFirstPageOfTwoTotal(contents: [Content]) -> ContentPage<Content> {
        ContentPage<Content>(offset: 0, limit: 1, total: 2, contents: contents)
    }
}
