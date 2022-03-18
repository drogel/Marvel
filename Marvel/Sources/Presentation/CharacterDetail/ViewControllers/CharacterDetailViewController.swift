//
//  CharacterDetailViewController.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import Combine
import UIKit

class CharacterDetailViewController: ViewController {
    typealias ViewModelProtocol = CharacterDetailViewModelProtocol

    private enum Constants {
        static let collectionContentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }

    private var viewModel: ViewModelProtocol!
    private var collectionView: UICollectionView!
    private var dataSource: CollectionViewDataSource!
    private var collectionViewDelegate: UICollectionViewDelegate!
    private var layout: UICollectionViewCompositionalLayout!
    private var dataSourceFactory: CollectionViewDataSourceFactory!
    private var cancellables = Set<AnyCancellable>()

    static func instantiate(
        viewModel: ViewModelProtocol,
        layout: UICollectionViewCompositionalLayout,
        dataSourceFactory: CollectionViewDataSourceFactory
    ) -> Self {
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
        viewModel.start()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.dispose()
    }
}

extension CharacterDetailViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch CharacterDetailSection.fromSectionIndex(indexPath.section) {
        case .comics:
            return viewModel.willDisplayComicCell(at: indexPath)
        default:
            return
        }
    }
}

private extension CharacterDetailViewController {
    func setUp() {
        setUpCollectionView()
        subscribeToDetail()
    }

    func setUpCollectionView() {
        let collectionView = createCollectionView()
        setSubview(collectionView)
        configureDataSource(of: collectionView)
        configureConstraints(of: collectionView)
    }

    func subscribeToDetail() {
        // TODO: Fix comics section title weird animations
        viewModel.detailStatePublisher
            .sink(receiveValue: handleState)
            .store(in: &cancellables)
    }

    func handleState(_ state: CharacterDetailViewModelState) {
        switch state {
        case let .success(detailModel):
            dataSource.update(with: [detailModel])
        case let .failure(error):
            showErrorAlert(message: error.localizedDescription, retryButtonAction: viewModel.start)
        }
    }

    func createCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = Constants.collectionContentInset
        return collectionView
    }

    func setSubview(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        view.addSubview(collectionView)
    }

    func configureDataSource(of collectionView: UICollectionView) {
        dataSource = dataSourceFactory.create(collectionView: collectionView)
        collectionView.delegate = collectionViewDelegate
        dataSource.setDataSource(of: collectionView)
    }

    func configureConstraints(of collectionView: UICollectionView) {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.fit(collectionView, in: view)
    }
}
