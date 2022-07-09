//
//  JsonDataLoader.swift
//  Marvel
//
//  Created by Diego Rogel on 19/1/22.
//

import Foundation

public protocol JsonDataLoader {
    func load<T: DataObject>(fromFileNamed fileName: String) -> T?
}

public class JsonDecoderDataLoader: JsonDataLoader {
    let parser: JSONParser

    public init(parser: JSONParser) {
        self.parser = parser
    }

    public func load<T: DataObject>(fromFileNamed fileName: String) -> T? {
        guard let url = url(for: fileName), let data: T = decode(fromJsonAt: url) else { return nil }
        return data
    }
}

private extension JsonDecoderDataLoader {
    func url(for resource: String) -> URL? {
        Bundle.module.url(forResource: resource, withExtension: "json")
    }

    func decode<T: DataObject>(fromJsonAt url: URL) -> T? {
        try? parser.parse(data: Data(contentsOf: url))
    }
}
