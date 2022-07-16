//
//  Factories.swift
//
//
//  Created by Diego Rogel on 9/7/22.
//

import Domain
import Foundation

public enum CharactersServiceFactory: ServiceFactory {
    public typealias Service = CharactersService

    public static func create(with baseApiURL: URL) -> Service {
        CharactersClientService(
            networkService: networkService(baseApiURL: baseApiURL),
            dataHandler: ClientDataHandler(parser: parser),
            networkErrorHandler: errorHandler,
            dataResultHandler: characterDataResultHandler
        )
    }

    public static func createDebug() -> Service {
        CharactersDebugService(
            dataLoader: JsonDecoderDataLoader(parser: parser),
            dataResultHandler: characterDataResultHandler
        )
    }
}

public enum CharacterDetailServiceFactory: ServiceFactory {
    public typealias Service = CharacterDetailService

    public static func create(with baseApiURL: URL) -> Service {
        CharacterDetailClientService(
            networkService: networkService(baseApiURL: baseApiURL),
            dataHandler: dataHandler,
            networkErrorHandler: errorHandler,
            dataResultHandler: characterDataResultHandler
        )
    }

    public static func createDebug() -> Service {
        CharacterDetailDebugService(
            dataLoader: jsonDataLoader,
            dataResultHandler: characterDataResultHandler
        )
    }
}

public enum ComicsServiceFactory: ServiceFactory {
    public typealias Service = ComicsService

    public static func create(with baseApiURL: URL) -> Service {
        ComicsClientService(
            networkService: networkService(baseApiURL: baseApiURL),
            dataHandler: dataHandler,
            dataResultHandler: comicDataResultHandler
        )
    }

    public static func createDebug() -> Service {
        ComicsDebugService(dataLoader: jsonDataLoader, dataResultHandler: comicDataResultHandler)
    }
}

private protocol ServiceFactory {
    associatedtype Service
    static func create(with baseApiURL: URL) -> Service
    static func createDebug() -> Service
}

extension ServiceFactory {
    static func networkService(baseApiURL: URL) -> NetworkService {
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

    static var dataHandler: NetworkDataHandler {
        ClientDataHandler(parser: parser)
    }

    static var jsonDataLoader: JsonDecoderDataLoader {
        JsonDecoderDataLoader(parser: parser)
    }

    static var parser: JSONParser {
        JSONDecoderParser()
    }

    static var errorHandler: NetworkErrorHandler {
        DataServicesNetworkErrorHandler()
    }

    static var characterDataResultHandler: CharacterDataResultHandler {
        CharacterDataResultHandlerFactory.createWithDataMappers()
    }

    static var comicDataResultHandler: ComicDataResultHandler {
        ComicDataResultHandlerFactory.createWithDataMappers()
    }
}
