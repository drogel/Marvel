//
//  Authenticator.swift
//  Marvel
//
//  Created by Diego Rogel on 20/1/22.
//

import Foundation
import CryptoKit

protocol Authenticator {
    func authenticate(with timestamp: TimeInterval) -> [String: String]?
}

class MD5Authenticator: Authenticator {

    private let secrets: SecretsRetriever

    init(secrets: SecretsRetriever) {
        self.secrets = secrets
    }

    func authenticate(with timestamp: TimeInterval) -> [String: String]? {
        guard let authenticationValues = authentication(from: timestamp) else { return nil }
        return ["hash": authenticationValues.hash, "apikey": authenticationValues.publicKey, "ts": format(timestamp)]
    }
}

private extension MD5Authenticator {

    func authentication(from timestamp: TimeInterval) -> (hash: String, publicKey: String)? {
        guard let fullKey = retrieveFullAuthenticationKey(using: timestamp), let hash = md5Hash(fullKey), let publicKey = secrets.publicKey else { return nil }
        return (hash: hash, publicKey: publicKey)
    }

    func retrieveFullAuthenticationKey(using timestamp: TimeInterval) -> String? {
        guard let publicKey = secrets.publicKey, let privateKey = secrets.privateKey else { return nil }
        return String(Int(timestamp)) + privateKey + publicKey
    }

    func md5Hash(_ source: String) -> String? {
        guard let data = source.data(using: .utf8) else { return nil }
        return Insecure.MD5.hash(data: data).map { String(format: "%02hhx", $0) }.joined()
    }

    func format(_ timestamp: TimeInterval) -> String {
        String(Int(timestamp))
    }
}
