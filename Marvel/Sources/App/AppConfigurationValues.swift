//
//  AppConfigurationValues.swift
//  Marvel
//
//  Created by Diego Rogel on 22/1/22.
//

import Foundation

protocol AppConfigurationValues {
    var apiBaseURLString: String { get }
    var scheme: AppScheme { get }
}

class MarvelConfigurationValues: AppConfigurationValues {
    lazy var scheme: AppScheme = scheme(fromConfigurationKey: "SCHEME")
    lazy var apiBaseURLString: String = apiBaseURLString(fromConfigurationKey: "API_BASE_URL")
}

private extension MarvelConfigurationValues {
    func scheme(fromConfigurationKey configurationKey: String) -> AppScheme {
        guard let scheme = AppScheme(rawValue: value(forConfigurationKey: configurationKey)) else {
            fatalError("The scheme value \(String(describing: value)) retrieved from configuration files is not a valid \(String(describing: AppScheme.self))")
        }
        return scheme
    }

    func apiBaseURLString(fromConfigurationKey configurationKey: String) -> String {
        value(forConfigurationKey: configurationKey)
    }

    func value(forConfigurationKey configurationKey: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: configurationKey) as? String else {
            fatalError("Could not retrieve configuration value for key \(configurationKey)")
        }
        return value
    }
}
