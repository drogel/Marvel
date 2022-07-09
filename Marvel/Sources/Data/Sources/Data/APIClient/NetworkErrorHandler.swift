//
//  NetworkErrorHandler.swift
//  Marvel
//
//  Created by Diego Rogel on 29/1/22.
//

import Domain
import Foundation

public protocol NetworkErrorHandler {
    func handle(_ networkError: NetworkError) -> DataServiceError
}

public class DataServicesNetworkErrorHandler: NetworkErrorHandler {
    public init() {}

    public func handle(_ networkError: NetworkError) -> DataServiceError {
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
