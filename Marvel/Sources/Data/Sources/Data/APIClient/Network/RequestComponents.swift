//
//  RequestComponents.swift
//  Marvel
//
//  Created by Diego Rogel on 21/1/22.
//

import Foundation

public struct RequestComponents: Equatable {
    let path: String
    let queryParameters: [String: String?]

    static var empty = RequestComponents()

    init(path: String = "", queryParameters: [String: String?] = [:]) {
        self.path = path
        self.queryParameters = queryParameters
    }

    @discardableResult func appendingPathComponents(_ pathComponents: [String]) -> Self {
        let newPathComponents = appendPathComponents(pathComponents)
        let newPath = path(from: newPathComponents)
        return RequestComponents(path: newPath, queryParameters: queryParameters)
    }

    @discardableResult func withOffsetQuery(_ offset: Int) -> Self {
        let newOffsetDictionaryEntry = ["offset": String(offset)]
        let newParameters = queryParameters.merging(newOffsetDictionaryEntry) { _, new in new }
        return RequestComponents(path: path, queryParameters: newParameters)
    }
}

private extension RequestComponents {
    func appendPathComponents(_ pathComponents: [String]) -> [String] {
        path.isEmpty ? pathComponents : [path] + pathComponents
    }

    func path(from pathComponents: [String]) -> String {
        pathComponents.joined(separator: "/")
    }
}
