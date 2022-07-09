//
//  NetworkSession.swift
//  Marvel
//
//  Created by Diego Rogel on 21/1/22.
//

import Foundation

public protocol NetworkSession {
    func loadData(from request: URLRequest) async throws -> (data: Data, response: URLResponse)
}
