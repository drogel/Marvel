//
//  CharactersViewController.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import Combine
import UIKit

class CharactersViewController: ViewController {
    typealias ViewModelProtocol = CharactersViewModelProtocol

    private enum Constants {
        static let scrollNearEndThreshold: CGFloat = 300
    }

    private var viewModel: ViewModelProtocol!
    private var layout: UICollectionViewCompositionalLayout!
    private var collectionView: UICollectionView!
    private var dataSource: CollectionViewDataSource!
    private var dataSourceFactory: CollectionViewDataSourceFactory!
    private var cancellables = Set<AnyCancellable>()

    static func instantiate(
        viewModel: ViewModelProtocol,
        layout: UICollectionViewCompositionalLayout,
        dataSourceFactory: CollectionViewDataSourceFactory
    ) -> CharactersViewController {
        let viewController = instantiate(viewModel: viewModel)
        viewController.layout = layout
        viewController.dataSourceFactory = dataSourceFactory
        return viewController
    }

    static func instantiate(viewModel: ViewModelProtocol) -> Self {
        let viewController = Self()
        viewController.viewModel = viewModel
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        start()
    }
}

extension CharactersViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.select(at: indexPath)
    }

    func collectionView(_: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        Task { await viewModel.willDisplayCell(at: indexPath) }
    }
}

private extension CharactersViewController {
    func setUp() {
        setUpNavigationController()
        setUpCollectionView()
        subscribeToLoadingState()
        subscribeToViewModelState()
    }

    func subscribeToLoadingState() {
        viewModel.loadingStatePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: handleLoadingState)
            .store(in: &cancellables)
    }

    func subscribeToViewModelState() {
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: handleState)
            .store(in: &cancellables)
    }

    func handleLoadingState(_ loadingState: LoadingState) {
        switch loadingState {
        case .idle:
            return
        case .loading:
            startLoading()
        case .loaded:
            stopLoading()
        }
    }

    func handleState(_ state: CharactersViewModelState) {
        switch state {
        case let .success(models):
            dataSource.update(with: models)
        case let .failure(error):
            showErrorAlert(message: error.localizedDescription, retryButtonAction: start)
        }
    }

    func setUpNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "characters".localized
    }

    func setUpCollectionView() {
        let collectionView = createCollectionView()
        setSubview(collectionView)
        configureDataSource(of: collectionView)
        configureConstraints(of: collectionView)
    }

    func createCollectionView() -> UICollectionView {
        UICollectionView(frame: .zero, collectionViewLayout: layout)
    }

    func setSubview(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        view.addSubview(collectionView)
    }

    func configureDataSource(of collectionView: UICollectionView) {
        dataSource = dataSourceFactory.create(collectionView: collectionView)
        dataSource.setDataSource(of: collectionView)
        collectionView.delegate = self
    }

    func configureConstraints(of collectionView: UICollectionView) {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.fit(collectionView, in: view)
    }

    func start() {
        Task { await viewModel.start() }
    }
}
