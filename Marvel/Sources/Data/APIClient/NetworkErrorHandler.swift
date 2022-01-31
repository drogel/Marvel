//
//  NetworkErrorHandler.swift
//  Marvel
//
//  Created by Diego Rogel on 29/1/22.
//

import Foundation

protocol NetworkErrorHandler {
    func handle(_ networkError: NetworkError) -> DataServiceError
}

class DataServicesNetworkErrorHandler: NetworkErrorHandler {

    func handle(_ networkError: NetworkError) -> DataServiceError {
        switch networkError {
        case .notConnected:
            return .noConnection
        case .unauthorized:
            return .unauthorized
        default:
            return .emptyData
        }
    }
}
