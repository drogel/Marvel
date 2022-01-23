//
//  SecretsRetriever.swift
//  Marvel
//
//  Created by Diego Rogel on 20/1/22.
//

import Foundation

protocol SecretsRetriever {
    var publicKey: String? { get }
    var privateKey: String? { get }
}

class EnvironmentVariablesRetriever: SecretsRetriever {

    // TODO: Handle error if no API keys are present
    var publicKey: String? {
        ProcessInfo.processInfo.environment["PUBLIC_KEY"]
    }

    var privateKey: String? {
        ProcessInfo.processInfo.environment["PRIVATE_KEY"]
    }
}
