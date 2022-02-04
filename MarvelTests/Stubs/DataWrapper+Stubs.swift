//
//  DataWrapper<CharacterData>+Stubs.swift
//  MarvelTests
//
//  Created by Diego Rogel on 19/1/22.
//

import Foundation
@testable import Marvel_Debug

extension DataWrapper where ContentType == CharacterData {
    static let empty = DataWrapper(code: 0, status: "", copyright: "", data: PageInfo<CharacterData>.empty)

    static let withNilData = DataWrapper<CharacterData>(code: 0, status: "", copyright: "", data: nil)
}
