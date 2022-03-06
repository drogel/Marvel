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

class CharacterDetailDataSource: NSObject, CollectionViewDataSource, UICollectionViewDataSource {
    private let presentationModel: CharacterDetailPresentationModelProtocol!
    private let imageRegistration = CellRegistration<CharacterImageCell>(handler: CharacterDetailDataSource.configure)
    private let infoRegistration = CellRegistration<CharacterInfoCell>(handler: CharacterDetailDataSource.configure)
    private let comicRegistration = CellRegistration<ComicCell>(handler: CharacterDetailDataSource.configure)
    private let comicHeaderRegistration = SupplementaryRegistration<CollectionSectionHeader>.header(
        handler: CharacterDetailDataSource.configure
    )

    init(presentationModel: CharacterDetailPresentationModelProtocol) {
        self.presentationModel = presentationModel
    }

    func setDataSource(of collectionView: UICollectionView) {
        collectionView.dataSource = self
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
    static func configure(_ imageCell: CharacterImageCell, at _: IndexPath, using model: CharacterImageModel?) {
        imageCell.configure(using: model)
    }

    static func configure(_ infoCell: CharacterInfoCell, at _: IndexPath, using model: CharacterInfoCell.Item) {
        infoCell.configure(using: model)
    }

    static func configure(_ comicCell: ComicCell, at _: IndexPath, using model: ComicCell.Item) {
        comicCell.configure(using: model)
    }

    static func configure(_ comicsSectionHeader: CollectionSectionHeader, with _: String, at _: IndexPath) {
        comicsSectionHeader.configure(using: "comics".localized)
    }

    func imageCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellModel = presentationModel.imageCellData else { return UICollectionViewCell() }
        return collectionView.dequeueConfiguredReusableCell(using: imageRegistration, for: indexPath, item: cellModel)
    }

    func infoCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellModel = presentationModel.infoCellData else { return UICollectionViewCell() }
        return collectionView.dequeueConfiguredReusableCell(using: infoRegistration, for: indexPath, item: cellModel)
    }

    func comicCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellModel = presentationModel.comicCellData(at: indexPath) else { return UICollectionViewCell() }
        return collectionView.dequeueConfiguredReusableCell(using: comicRegistration, for: indexPath, item: cellModel)
    }

    func comicsHeader(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionReusableView {
        collectionView.dequeueConfiguredReusableSupplementary(using: comicHeaderRegistration, for: indexPath)
    }
}
