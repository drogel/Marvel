//
//  CharacterDetailDataSource.swift
//  Marvel
//
//  Created by Diego Rogel on 3/2/22.
//

import Foundation
import UIKit

enum CharacterDetailSection: Int {
    case image
    case info

    static func fromSectionIndex(_ sectionIndex: Int) -> CharacterDetailSection {
        guard let section = CharacterDetailSection(rawValue: sectionIndex) else { fatalError() }
        return section
    }
}

class CharacterDetailDataSource: NSObject, CollectionViewDataSource {
    private let viewModel: CharacterDetailViewModelProtocol!

    init(viewModel: CharacterDetailViewModelProtocol) {
        self.viewModel = viewModel
    }

    func numberOfSections(in _: UICollectionView) -> Int {
        2
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch CharacterDetailSection.fromSectionIndex(indexPath.section) {
        case .image:
            return imageCell(in: collectionView, at: indexPath)
        case .info:
            return infoCell(in: collectionView, at: indexPath)
        }
    }

    func registerSubviews(in collectionView: UICollectionView) {
        collectionView.register(CharacterImageCell.self, forCellWithReuseIdentifier: CharacterImageCell.identifier)
        collectionView.register(CharacterInfoCell.self, forCellWithReuseIdentifier: CharacterInfoCell.identifier)
    }
}

private extension CharacterDetailDataSource {
    func imageCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cellOfType: CharacterImageCell.self, at: indexPath)
        cell.configure(using: viewModel.imageCellData)
        return cell
    }

    func infoCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cellOfType: CharacterInfoCell.self, at: indexPath)
        cell.configure(using: viewModel.infoCellData)
        return cell
    }
}
