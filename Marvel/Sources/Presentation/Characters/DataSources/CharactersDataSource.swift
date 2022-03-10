//
//  CharactersDataSource.swift
//  Marvel
//
//  Created by Diego Rogel on 4/3/22.
//

import Combine
import UIKit

enum CharactersSection {
    case main
}

class CharactersDataSourceFactory: CollectionViewDataSourceFactory {
    private let viewModel: CharactersViewModelProtocol

    init(viewModel: CharactersViewModelProtocol) {
        self.viewModel = viewModel
    }

    func create(collectionView: UICollectionView) -> CollectionViewDataSource {
        CharactersDataSource(collectionView: collectionView, viewModel: viewModel)
    }
}

typealias CharactersDiffableDataSource = UICollectionViewDiffableDataSource<CharactersSection, CharacterCell.Item>

class CharactersDataSource: CollectionViewDataSource {
    private let viewModel: CharactersViewModelProtocol
    private let collectionView: UICollectionView
    private let cellRegistration = CellRegistration<CharacterCell>(handler: CharactersDataSource.configureCell)
    private var cancellables = Set<AnyCancellable>()
    private lazy var diffableDataSource = CharactersDiffableDataSource(
        collectionView: collectionView,
        cellProvider: provideCell
    )

    init(collectionView: UICollectionView, viewModel: CharactersViewModelProtocol) {
        self.viewModel = viewModel
        self.collectionView = collectionView
    }

    func setDataSource(of collectionView: UICollectionView) {
        collectionView.dataSource = diffableDataSource
        subscribeToCellModels()
    }

    func applySnapshot() {
        // TODO: Remove
    }
}

private extension CharactersDataSource {
    static func configureCell(_ cell: CharacterCell, at _: IndexPath, using model: CharacterCell.Item) {
        cell.configure(using: model)
    }

    func provideCell(
        in collectionView: UICollectionView,
        forRowAt indexPath: IndexPath,
        with model: CharacterCell.Item
    ) -> UICollectionViewCell {
        collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: model)
    }

    func subscribeToCellModels() {
        viewModel.cellModelsPublisher.sink(receiveValue: applySnapshot).store(in: &cancellables)
    }

    func applySnapshot(with models: [CharacterCell.Item]) {
        var snapshot = CharactersDiffableDataSource.Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(models, toSection: .main)
        diffableDataSource.apply(snapshot)
    }
}
