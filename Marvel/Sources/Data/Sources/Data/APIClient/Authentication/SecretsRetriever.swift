//
//  SecretsRetriever.swift
//  Marvel
//
//  Created by Diego Rogel on 20/1/22.
//

import Foundation

public protocol SecretsRetriever {
    var publicKey: String? { get }
    var privateKey: String? { get }
}

public class EnvironmentVariablesRetriever: SecretsRetriever {
    public init() {}

    public var publicKey: String? {
        ProcessInfo.processInfo.environment["PUBLIC_KEY"]
    }

    public var privateKey: String? {
        ProcessInfo.processInfo.environment["PRIVATE_KEY"]
    }
}
