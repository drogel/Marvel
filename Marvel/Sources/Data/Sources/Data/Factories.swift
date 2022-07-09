//
//  Factories.swift
//
//
//  Created by Diego Rogel on 9/7/22.
//

import Domain
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

public enum CharactersServiceFactory {
    public static func create(with networkService: NetworkService) -> CharactersService {
        CharactersClientService(
            networkService: networkService,
            dataHandler: ClientDataHandler(parser: parser),
            networkErrorHandler: errorHandler,
            dataResultHandler: dataResultHandler
        )
    }

    public static func createDebug() -> CharactersService {
        CharactersDebugService(
            dataLoader: JsonDecoderDataLoader(parser: parser),
            dataResultHandler: dataResultHandler
        )
    }
}

private extension CharactersServiceFactory {
    static var parser: JSONParser {
        JSONDecoderParser()
    }

    static var errorHandler: NetworkErrorHandler {
        DataServicesNetworkErrorHandler()
    }

    static var dataResultHandler: CharacterDataResultHandler {
        CharacterDataResultHandlerFactory.createWithDataMappers()
    }
}

public enum CharacterDetailServiceFactory {
    public static func create(with networkService: NetworkService) -> CharacterDetailService {
        CharacterDetailClientService(
            networkService: networkService,
            dataHandler: dataHandler,
            networkErrorHandler: errorHandler,
            dataResultHandler: characterDataResultHandler
        )
    }

    public static func createDebug() -> CharacterDetailService {
        CharacterDetailDebugService(
            dataLoader: jsonDataLoader,
            dataResultHandler: characterDataResultHandler
        )
    }
}

private extension CharacterDetailServiceFactory {
    static var dataHandler: NetworkDataHandler {
        ClientDataHandler(parser: parser)
    }

    static var errorHandler: NetworkErrorHandler {
        DataServicesNetworkErrorHandler()
    }

    static var jsonDataLoader: JsonDecoderDataLoader {
        JsonDecoderDataLoader(parser: parser)
    }

    static var parser: JSONParser {
        JSONDecoderParser()
    }

    static var characterDataResultHandler: CharacterDataResultHandler {
        CharacterDataResultHandlerFactory.createWithDataMappers()
    }
}
