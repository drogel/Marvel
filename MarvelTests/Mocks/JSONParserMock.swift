//
//  JSONParserMock.swift
//  MarvelTests
//
//  Created by Diego Rogel on 29/1/22.
//

import Foundation
@testable import Marvel_Debug

class JSONParserMock: JSONParser {

    var parseCallCount = 0

    func parse<T>(data: Data) -> T? where T : Decodable {
        parseCallCount += 1
        return nil
    }
}

class JSONParserSuccessfulStub<Stub: Decodable>: JSONParserMock {

    private let dataStub: Stub?

    init(dataStub: Stub) {
        self.dataStub = dataStub
    }

    override func parse<T>(data: Data) -> T? where T: Decodable {
        let _: T? = super.parse(data: data)
        return dataStub as? T
    }
}

class JSONParserFailingStub: JSONParserMock {

    override func parse<T>(data: Data) -> T? where T : Decodable {
        return super.parse(data: data)
    }
}
