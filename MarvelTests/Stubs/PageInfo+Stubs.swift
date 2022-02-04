//
//  PageInfo<CharacterData>+Stubs.swift
//  MarvelTests
//
//  Created by Diego Rogel on 19/1/22.
//

import Foundation
@testable import Marvel_Debug

extension PageInfo where ContentType == CharacterData {
    static let empty = PageInfo<CharacterData>.zeroWith(results: [])

    static func zeroWith(results: [CharacterData]) -> PageInfo<CharacterData> {
        PageInfo<CharacterData>(offset: 0, limit: 0, total: 0, count: 0, results: results)
    }
}
