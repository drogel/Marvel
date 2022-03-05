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
    private let presentationModel: CharacterDetailPresentationModelProtocol!

    init(presentationModel: CharacterDetailPresentationModelProtocol) {
        self.presentationModel = presentationModel
    }

    func numberOfSections(in _: UICollectionView) -> Int {
        CharacterDetailSection.allCases.count
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch CharacterDetailSection.fromSectionIndex(section) {
        case .comics:
            return presentationModel.numberOfComics
        default:
            return 1
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind _: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch CharacterDetailSection.fromSectionIndex(indexPath.section) {
        case .comics:
            return comicsHeader(in: collectionView, at: indexPath)
        default:
            return UICollectionReusableView()
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
        collectionView.register(headerOfType: CollectionSectionHeader.self)
    }

    func applySnapshot() {
        // TODO: Implement when we migrate this data source to UICollectionViewDiffableDataSource
    }
}

extension CharacterDetailDataSource: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch CharacterDetailSection.fromSectionIndex(indexPath.section) {
        case .comics:
            return presentationModel.willDisplayComicCell(at: indexPath)
        default:
            return
        }
    }
}

private extension CharacterDetailDataSource {
    func imageCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cellOfType: CharacterImageCell.self, at: indexPath)
        cell.configure(using: presentationModel.imageCellData)
        return cell
    }

    func infoCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cellOfType: CharacterInfoCell.self, at: indexPath)
        cell.configure(using: presentationModel.infoCellData)
        return cell
    }

    func comicCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        guard let comicCellData = presentationModel.comicCellData(at: indexPath) else { return UICollectionViewCell() }
        let cell = collectionView.dequeue(cellOfType: ComicCell.self, at: indexPath)
        cell.configure(using: comicCellData)
        return cell
    }

    func comicsHeader(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeue(headerOfType: CollectionSectionHeader.self, at: indexPath)
        header.configure(using: presentationModel.comicsSectionTitle)
        return header
    }
}
