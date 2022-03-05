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

protocol CharactersDataSourceFactory {
    func create(
        collectionView: UICollectionView,
        presentationModel: CharactersPresentationModelProtocol
    ) -> CollectionViewDataSource
}

class CharactersDiffableDataSourceFactory: CharactersDataSourceFactory {
    func create(
        collectionView: UICollectionView,
        presentationModel: CharactersPresentationModelProtocol
    ) -> CollectionViewDataSource {
        CharactersDataSource(collectionView: collectionView, presentationModel: presentationModel)
    }
}

typealias CharactersDiffableDataSource = UICollectionViewDiffableDataSource<CharactersSection, CharacterCellModel>

class CharactersDataSource: CharactersDiffableDataSource, CollectionViewDataSource {
    private let presentationModel: CharactersPresentationModelProtocol

    init(collectionView: UICollectionView, presentationModel: CharactersPresentationModelProtocol) {
        self.presentationModel = presentationModel
        super.init(collectionView: collectionView, cellProvider: Self.provideCell)
    }

    func registerSubviews(in collectionView: UICollectionView) {
        // TODO: Use the new iOS 14+ API to configure and register cells
        collectionView.register(cellOfType: CharacterCell.self)
    }

    func applySnapshot() {
        // TODO: Add tests for this kind of operations
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(presentationModel.cellModels, toSection: .main)
        apply(snapshot)
    }
}

private extension CharactersDataSource {
    static func provideCell(
        in collectionView: UICollectionView,
        forRowAt indexPath: IndexPath,
        with model: CharacterCellModel
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cellOfType: CharacterCell.self, at: indexPath)
        cell.configure(using: model)
        return cell
    }
}
