//
//  NetworkServiceFactory.swift
//
//
//  Created by Diego Rogel on 9/7/22.
//

import Foundation

public enum NetworkServiceFactory {
    public static func create(baseApiURL: URL) -> NetworkService {
        AuthenticatedNetworkService(
            networkService: NetworkSessionService(
                session: URLSession.shared,
                baseURL: baseApiURL,
                urlComposer: URLComponentsBuilder()
            ),
            authenticator: MD5Authenticator(
                secrets: EnvironmentVariablesRetriever()
            )
        )
    }
}
