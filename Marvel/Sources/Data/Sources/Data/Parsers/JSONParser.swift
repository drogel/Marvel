//
//  JSONParser.swift
//  Marvel
//
//  Created by Diego Rogel on 21/1/22.
//

import Foundation

public protocol JSONParser {
    func parse<T: Decodable>(data: Data) -> T?
}

public class JSONDecoderParser: JSONParser {
    public init() {}

    public func parse<T>(data: Data) -> T? where T: Decodable {
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }
}
