//
//  Requestable.swift
//  Marvel
//
//  Created by Diego Rogel on 21/1/22.
//

import Foundation

protocol Requestable {
    var path: String { get }
    var queryParameters: [String: String?] { get }
}
