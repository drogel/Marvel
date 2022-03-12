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
    func create(collectionView: UICollectionView) -> CollectionViewDataSource {
        CharactersDataSource(collectionView: collectionView)
    }
}

typealias CharactersDiffableDataSource = UICollectionViewDiffableDataSource<CharactersSection, AnyHashable>

class CharactersDataSource: CollectionViewDataSource {
    private let collectionView: UICollectionView
    private let cellRegistration = CellRegistration<CharacterCell>(handler: CharactersDataSource.configureCell)
    private var cancellables = Set<AnyCancellable>()
    private lazy var diffableDataSource = CharactersDiffableDataSource(
        collectionView: collectionView,
        cellProvider: provideCell
    )

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }

    func setDataSource(of collectionView: UICollectionView) {
        collectionView.dataSource = diffableDataSource
    }

    func update<T: Hashable>(with items: [T]) {
        applySnapshot(with: items)
    }
}

private extension CharactersDataSource {
    static func configureCell(_ cell: CharacterCell, at _: IndexPath, using model: CharacterCell.Item) {
        cell.configure(using: model)
    }

    func provideCell(
        in collectionView: UICollectionView,
        forRowAt indexPath: IndexPath,
        with model: AnyHashable
    ) -> UICollectionViewCell? {
        guard let model = model as? CharacterCell.Item else { return nil }
        return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: model)
    }

    func applySnapshot(with models: [AnyHashable]) {
        var snapshot = CharactersDiffableDataSource.Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(models, toSection: .main)
        diffableDataSource.apply(snapshot)
    }
}
