//
//  CharactersDataSource.swift
//  Marvel
//
//  Created by Diego Rogel on 4/3/22.
//

import UIKit

enum CharactersSection {
    case main
}

class CharactersDataSourceFactory: CollectionViewDataSourceFactory {
    private let presentationModel: CharactersPresentationModelProtocol

    init(presentationModel: CharactersPresentationModelProtocol) {
        self.presentationModel = presentationModel
    }

    func create(collectionView: UICollectionView) -> CollectionViewDataSource {
        CharactersDataSource(collectionView: collectionView, presentationModel: presentationModel)
    }
}

typealias CharactersDiffableDataSource = UICollectionViewDiffableDataSource<CharactersSection, CharacterCell.Item>

class CharactersDataSource: CollectionViewDataSource {
    private let presentationModel: CharactersPresentationModelProtocol
    private let collectionView: UICollectionView
    private let cellRegistration = CellRegistration<CharacterCell>(handler: CharactersDataSource.configureCell)
    private lazy var diffableDataSource = CharactersDiffableDataSource(
        collectionView: collectionView,
        cellProvider: provideCell
    )

    init(collectionView: UICollectionView, presentationModel: CharactersPresentationModelProtocol) {
        self.presentationModel = presentationModel
        self.collectionView = collectionView
    }

    func setDataSource(of collectionView: UICollectionView) {
        collectionView.dataSource = diffableDataSource
    }

    func applySnapshot() {
        var snapshot = CharactersDiffableDataSource.Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(presentationModel.cellModels, toSection: .main)
        diffableDataSource.apply(snapshot)
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
}
