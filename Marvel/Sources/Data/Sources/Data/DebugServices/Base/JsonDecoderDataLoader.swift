//
//  JsonDataLoader.swift
//  Marvel
//
//  Created by Diego Rogel on 19/1/22.
//

import Foundation

protocol JsonDataLoader {
    func load<T: DataObject>(fromFileNamed fileName: String) -> T?
}

class JsonDecoderDataLoader: JsonDataLoader {
    let parser: JSONParser

    init(parser: JSONParser) {
        self.parser = parser
    }

    func load<T: DataObject>(fromFileNamed fileName: String) -> T? {
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
