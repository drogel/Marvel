//
//  NetworkSession.swift
//  Marvel
//
//  Created by Diego Rogel on 21/1/22.
//

import Foundation

protocol NetworkSession {
    func loadData(from request: URLRequest) async throws -> (data: Data, response: URLResponse)
}
