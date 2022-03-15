//
//  URLSessionDataTask+Disposable.swift
//  Marvel
//
//  Created by Diego Rogel on 21/1/22.
//

import Foundation

extension URLSessionDataTask: Disposable {
    func dispose() {
        cancel()
    }
}
