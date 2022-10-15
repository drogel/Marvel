//
//  PageData+Stubs.swift
//  MarvelTests
//
//  Created by Diego Rogel on 19/1/22.
//

@testable import Data
import Foundation

extension PageData {
    static var empty: PageData<ContentType> {
        PageData<ContentType>.zeroWith(results: [])
    }

    static func zeroWith(results: [ContentType]) -> PageData<ContentType> {
        PageData<ContentType>(offset: 0, limit: 0, total: 0, count: 0, results: results)
    }

    static func atFirstPageOfTwoTotal(results: [ContentType]) -> PageData<ContentType> {
        PageData<ContentType>(offset: 0, limit: 1, total: 2, count: 1, results: results)
    }
}
