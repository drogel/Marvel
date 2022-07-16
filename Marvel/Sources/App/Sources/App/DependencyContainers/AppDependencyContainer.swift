//
//  AppDependencyContainer.swift
//  Marvel
//
//  Created by Diego Rogel on 22/1/22.
//

import Foundation

protocol AppDependencyContainer {
    var baseApiURL: URL { get }
    var scheme: AppScheme { get }
}

class MarvelDependencyContainer: AppDependencyContainer {
    private let configuration: AppConfigurationValues

    init(configuration: AppConfigurationValues) {
        self.configuration = configuration
    }

    lazy var baseApiURL: URL = baseURL

    lazy var scheme: AppScheme = configuration.scheme
}

private extension MarvelDependencyContainer {
    var baseURL: URL {
        guard let url = URL(string: "https://" + configuration.apiBaseURLString) else {
            fatalError("Expected a valid API base URL.")
        }
        return url
    }
}
