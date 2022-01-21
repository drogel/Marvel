//
//  URLSession+NetworkSession.swift
//  Marvel
//
//  Created by Diego Rogel on 21/1/22.
//

import Foundation

extension URLSession: NetworkSession {

    func loadData(from request: URLRequest, completionHandler: @escaping NetworkCompletion) -> URLSessionDataTask {
        let task = dataTask(with: request) { (data, response, error) in
            completionHandler(data, response, error)
        }
        task.resume()
        return task
    }
}
