//
//  RequestComponents.swift
//  Marvel
//
//  Created by Diego Rogel on 21/1/22.
//

import Foundation

struct RequestComponents: Equatable {
    let path: String
    let queryParameters: [String: String?]

    static var empty = RequestComponents(path: "")

    init(path: String, queryParameters: [String: String?] = [:]) {
        self.path = path
        self.queryParameters = queryParameters
    }
}
