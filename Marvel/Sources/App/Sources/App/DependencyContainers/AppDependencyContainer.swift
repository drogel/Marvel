//
//  AppDependencyContainer.swift
//  Marvel
//
//  Created by Diego Rogel on 22/1/22.
//

import Factory
import Foundation

protocol AppDependencyContainer {
    var baseApiURL: URL { get }
    var scheme: AppScheme { get }
}

struct AppDependencyAdapter: AppDependencyContainer {
    let baseApiURL: URL
    let scheme: AppScheme
}

extension SharedContainer {
    static let configuration = Factory<AppConfigurationValues>(scope: .singleton) { MarvelConfigurationValues() }
}

final class MarvelDepencyContainer: SharedContainer {
    static let appDependencyContainer = Factory<AppDependencyContainer> {
        guard let url = URL(string: "https://" + configuration().apiBaseURLString) else {
            fatalError("Expected a valid API base URL.")
        }
        return AppDependencyAdapter(baseApiURL: url, scheme: configuration().scheme)
    }
}
