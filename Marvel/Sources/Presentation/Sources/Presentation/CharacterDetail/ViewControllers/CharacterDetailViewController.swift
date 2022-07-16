//
//  CharacterDetailViewController.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import Combine
import UIKit

public class CharacterDetailViewController: ViewController, AlertPresenter {
    typealias ViewModelProtocol = CharacterDetailViewModelProtocol

    private enum Constants {
        static let collectionContentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }

    private var viewModel: ViewModelProtocol!
    private var collectionView: UICollectionView!
    private var dataSource: CollectionViewDataSource!
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

    override public func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        start()
    }
}

extension CharacterDetailViewController: ViewModelInstantiable {
    static func instantiate(viewModel: ViewModelProtocol) -> Self {
        let viewController = Self()
        viewController.viewModel = viewModel
        return viewController
    }
}

extension CharacterDetailViewController: UICollectionViewDelegate {
    public func collectionView(
        _: UICollectionView,
        willDisplay _: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        switch CharacterDetailSection.fromSectionIndex(indexPath.section) {
        case .comics:
            let task = Task { await viewModel.willDisplayComicCell(at: indexPath) }
            tasks.insert(task)
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
        viewModel.detailStatePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: handleState)
            .store(in: &cancellables)
    }

    func handleState(_ state: CharacterDetailViewModelState) {
        switch state {
        case let .success(detailModel):
            dataSource.update(with: [detailModel])
        case let .failure(error):
            showErrorAlert(message: error.localizedDescription, retryButtonAction: start)
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
        dataSource.setDataSource(of: collectionView)
        collectionView.delegate = self
    }

    func configureConstraints(of collectionView: UICollectionView) {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.fit(collectionView, in: view)
    }

    func start() {
        let task = Task { await viewModel.start() }
        tasks.insert(task)
    }
}