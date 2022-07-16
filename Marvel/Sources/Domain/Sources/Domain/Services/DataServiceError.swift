//
//  DataServiceError.swift
//  Marvel
//
//  Created by Diego Rogel on 29/1/22.
//

import Foundation

public enum DataServiceError: Error {
    case emptyData
    case unauthorized
    case noConnection
}
