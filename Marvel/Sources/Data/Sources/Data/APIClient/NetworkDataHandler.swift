//
//  NetworkDataHandler.swift
//  Marvel
//
//  Created by Diego Rogel on 22/3/22.
//

import Domain
import Foundation

public protocol NetworkDataHandler {
    func handle<T: DataObject>(_ data: Data?) throws -> DataWrapper<T>
}

public class ClientDataHandler: NetworkDataHandler {
    private let parser: JSONParser

    public init(parser: JSONParser) {
        self.parser = parser
    }

    public func handle<T: DataObject>(_ data: Data?) throws -> DataWrapper<T> {
        guard let data = data, let dataWrapper: DataWrapper<T> = parser.parse(data: data) else {
            throw DataServiceError.emptyData
        }
        return dataWrapper
    }
}
