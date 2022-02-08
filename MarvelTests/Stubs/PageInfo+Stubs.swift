//
//  PageInfo+Stubs.swift
//  MarvelTests
//
//  Created by Diego Rogel on 19/1/22.
//

import Foundation
@testable import Marvel_Debug

extension PageInfo {
    static var empty: PageInfo<ContentType> {
        PageInfo<ContentType>.zeroWith(results: [])
    }

    static func zeroWith(results: [ContentType]) -> PageInfo<ContentType> {
        PageInfo<ContentType>(offset: 0, limit: 0, total: 0, count: 0, results: results)
    }

    static func atFirstPageOfTwoTotal(results: [ContentType]) -> PageInfo<ContentType> {
        PageInfo<ContentType>(offset: 0, limit: 1, total: 2, count: 1, results: results)
    }
}
