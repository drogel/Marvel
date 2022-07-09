//
//  URLSession+NetworkSession.swift
//  Marvel
//
//  Created by Diego Rogel on 21/1/22.
//

import Foundation

extension URLSession: NetworkSession {
    public func loadData(from request: URLRequest) async throws -> (data: Data, response: URLResponse) {
        try await data(for: request, delegate: nil)
    }
}
