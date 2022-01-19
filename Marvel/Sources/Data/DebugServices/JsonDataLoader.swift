//
//  JsonDataLoader.swift
//  Marvel
//
//  Created by Diego Rogel on 19/1/22.
//

import Foundation

protocol JsonDataLoaderProtocol {
    func load<T: Decodable>(fromFileNamed fileName: String) -> T?
}

class JsonDataLoader: JsonDataLoaderProtocol {

    func load<T: Decodable>(fromFileNamed fileName: String) -> T? {
        guard let url = url(for: fileName), let data: T = decode(fromJsonAt: url) else { return nil }
        return data
    }
}

private extension JsonDataLoader {

    func url(for resource: String) -> URL? {
        Bundle(for: Self.self).url(forResource: resource, withExtension: "json")
    }

    func decode<T: Decodable>(fromJsonAt url: URL) -> T? {
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: Data(contentsOf: url))
    }
}
