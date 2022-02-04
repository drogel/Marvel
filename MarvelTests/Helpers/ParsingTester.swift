//
//  ParsingTester.swift
//  MarvelTests
//
//  Created by Diego Rogel on 18/1/22.
//

import Foundation

/// Helper protocol to easily parse JSONs into subjects under test.
protocol ParsingTester {
    associatedtype ParseableObjectType: Decodable, Equatable

    /// The name of the file that contains the JSON data that will be used in ``givenParsedObjectFromJson()``.
    /// If not implemented, the ``ParsingTester`` will try to find a JSON file named after the name of
    /// the ``ParseableObjectType``.
    var parseableObjectJSONFileName: String { get }

    /// Parse a JSON named after the type of the object specified in the associated type of ``ParsingTester``.
    /// - Returns: An instance of the object specified in the associated type of ``ParsingTester`` that contains
    /// the parsed data from a JSON named after the runtime type of ``ParseableObjectType``.
    func givenParsedObjectFromJson() -> ParseableObjectType
}

extension ParsingTester where Self: AnyObject {
    var parseableObjectJSONFileName: String {
        String(describing: ParseableObjectType.self)
    }

    func givenParsedObjectFromJson() -> ParseableObjectType {
        try! parseObjectFromJson()
    }

    private func parseObjectFromJson() throws -> ParseableObjectType {
        guard let url = urlForJsonFile() else { throw ParsingTesterError.jsonUrlNotFound }
        guard let model = decodeObject(fromJsonAt: url) else { throw ParsingTesterError.dataParsingFailed }
        return model
    }

    private func urlForJsonFile() -> URL? {
        Bundle(for: Self.self).url(forResource: parseableObjectJSONFileName, withExtension: "json")
    }

    private func decodeObject(fromJsonAt url: URL) -> ParseableObjectType? {
        let decoder = JSONDecoder()
        return try? decoder.decode(ParseableObjectType.self, from: Data(contentsOf: url))
    }
}

private enum ParsingTesterError: LocalizedError {
    case jsonUrlNotFound
    case dataParsingFailed
}
