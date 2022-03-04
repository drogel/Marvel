//
//  CharactersDataSource.swift
//  Marvel
//
//  Created by Diego Rogel on 4/3/22.
//

import Foundation
import UIKit

enum CharactersSection {
    case main
}

protocol CharactersDataSourceFactory {
    func create(collectionView: UICollectionView) -> UICollectionViewDataSource
}

class CharactersDiffableDataSourceFactory: CharactersDataSourceFactory {
    func create(collectionView: UICollectionView) -> UICollectionViewDataSource {
        CharactersDataSource(collectionView: collectionView)
    }
}

class CharactersDataSource: UICollectionViewDiffableDataSource<CharactersSection, CharacterCellModel> {
    init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView, cellProvider: Self.provideCell)
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
