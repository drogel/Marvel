//
//  JsonDataLoaderStubs.swift
//  MarvelTests
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation
@testable import Marvel_Debug

class JsonDataLoaderEmptyStub: JsonDataLoader {
    func load<T>(fromFileNamed _: String) -> T? {
        nil
    }
}

class JsonDataLoaderStub: JsonDataLoader {
    static let codeStub = 200

    func load<T>(fromFileNamed _: String) -> T? {
        DataWrapper<CharacterData>(code: Self.codeStub, status: nil, copyright: nil, data: nil) as? T
    }
}
