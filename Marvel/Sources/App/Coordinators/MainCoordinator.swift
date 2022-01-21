//
//  MainCoordinator.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import UIKit

class MainCoordinator: Coordinator {
    let children: [Coordinator] = []
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showCharactersViewController()
    }
}

private extension MainCoordinator {

    func showCharactersViewController() {
        let charactersViewController = createCharactersViewController()
        navigationController.pushViewController(charactersViewController, animated: false)
    }

    func showCharacterDetailViewController() {
        let characterDetailViewController = createCharacterDetailViewController()
        navigationController.present(characterDetailViewController, animated: true)
    }

    func createCharactersViewController() -> UIViewController {
        // TODO: Move viewController instantiation and dependency wiring to some kind of factory
        let viewController = CharactersViewController()
        // TODO: Remove this temporary service injection
        // TODO: Add different characters service wiring: one for debug, other for release
        let charactersService = CharactersClientService(client: AuthenticatedNetworkService(networkService: NetworkSessionService(session: URLSession(configuration: .default), baseURL: URL(string: "https://gateway.marvel.com/v1/public/")!, urlComposer: URLComponentsBuilder()), authenticator: MD5Authenticator(secrets: EnvironmentVariablesRetriever())), parser: JSONDecoderParser())
        let fetchCharactersUseCase = FetchCharactersServiceUseCase(service: charactersService)
        let viewModel = CharactersViewModel(charactersFetcher: fetchCharactersUseCase)
        viewModel.coordinatorDelegate = self
        viewController.layout = CharactersLayout()
        viewController.viewModel = viewModel
        viewModel.viewDelegate = viewController
        return viewController
    }

    func createCharacterDetailViewController() -> UIViewController {
        // TODO: Move viewController instantiation and dependency wiring to some kind of factory
        return CharacterDetailViewController()
    }
}

extension MainCoordinator: CharactersViewModelCoordinatorDelegate {
    func viewModel(_ viewModel: CharactersViewModelProtocol, didSelectItemAt indexPath: IndexPath) {
        showCharacterDetailViewController()
    }
}
