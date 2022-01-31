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

    init(path: String, queryParameters: [String: String?] = [:]) {
        self.path = path
        self.queryParameters = queryParameters
    }
}
