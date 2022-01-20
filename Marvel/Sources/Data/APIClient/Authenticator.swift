//
//  Authenticator.swift
//  Marvel
//
//  Created by Diego Rogel on 20/1/22.
//

import Foundation
import CryptoKit

protocol Authenticator {
    func authenticate(with timestamp: TimeInterval) -> String?
}

class MD5Authenticator: Authenticator {

    private let secrets: SecretsRetriever

    init(secrets: SecretsRetriever) {
        self.secrets = secrets
    }

    func authenticate(with timestamp: TimeInterval) -> String? {
        guard let publicKey = secrets.publicKey, let privateKey = secrets.privateKey else { return nil }
        let fullKey = String(Int(timestamp)) + privateKey + publicKey
        return md5Hash(fullKey)
    }
}

private extension MD5Authenticator {

    func md5Hash(_ source: String) -> String? {
        guard let data = source.data(using: .utf8) else { return nil }
        return Insecure.MD5.hash(data: data).map { String(format: "%02hhx", $0) }.joined()
    }
}
