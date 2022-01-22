//
//  JSONParser.swift
//  Marvel
//
//  Created by Diego Rogel on 21/1/22.
//

import Foundation

protocol JSONParser {
    func parse<T: Decodable>(data: Data) -> T? 
}

class JSONDecoderParser: JSONParser {

    func parse<T>(data: Data) -> T? where T : Decodable {
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }
}
