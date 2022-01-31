//
//  AppDependencyContainer.swift
//  Marvel
//
//  Created by Diego Rogel on 22/1/22.
//

import Foundation

protocol AppDependencyContainer {
    var networkService: NetworkService { get }
    var scheme: AppScheme { get }
}

class MarvelDependencyContainer: AppDependencyContainer {
    private let configuration: AppConfigurationValues

    init(configuration: AppConfigurationValues) {
        self.configuration = configuration
    }

    lazy var networkService: NetworkService = {
        AuthenticatedNetworkService(
            networkService: baseNetworkService,
            authenticator: authenticator
        )
    }()

    lazy var scheme: AppScheme = {
        configuration.scheme
    }()
}

private extension MarvelDependencyContainer {
    var baseURL: URL {
        guard let url = URL(string: "https://" + configuration.apiBaseURLString) else {
            fatalError("Expected a valid API base URL. Review the app configuration files and ensure it is properly formatted.")
        }
        return url
    }

    var baseNetworkService: NetworkService {
        NetworkSessionService(
            session: URLSession.shared,
            baseURL: baseURL,
            urlComposer: URLComponentsBuilder()
        )
    }

    var authenticator: MD5Authenticator {
        MD5Authenticator(secrets: EnvironmentVariablesRetriever())
    }
}
