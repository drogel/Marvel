//
//  CharacterDetailDataSource.swift
//  Marvel
//
//  Created by Diego Rogel on 3/2/22.
//

import Foundation
import UIKit

enum CharacterDetailSection: Int, CaseIterable {
    case image
    case info
    case comics

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
        CharacterDetailSection.allCases.count
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch CharacterDetailSection.fromSectionIndex(section) {
        case .comics:
            return viewModel.numberOfComics
        default:
            return 1
        }
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
        case .comics:
            return comicCell(in: collectionView, at: indexPath)
        }
    }

    func registerSubviews(in collectionView: UICollectionView) {
        collectionView.register(cellOfType: CharacterImageCell.self)
        collectionView.register(cellOfType: CharacterInfoCell.self)
        collectionView.register(cellOfType: ComicCell.self)
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

    func comicCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        guard let comicCellData = viewModel.comicCellData(at: indexPath) else { return UICollectionViewCell() }
        let cell = collectionView.dequeue(cellOfType: ComicCell.self, at: indexPath)
        cell.configure(using: comicCellData)
        return cell
    }
}
