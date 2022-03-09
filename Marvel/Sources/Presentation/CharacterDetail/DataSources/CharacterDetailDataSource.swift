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

class CharacterDetailDataSourceFactory: CollectionViewDataSourceFactory {
    private let presentationModel: CharacterDetailPresentationModelProtocol

    init(presentationModel: CharacterDetailPresentationModelProtocol) {
        self.presentationModel = presentationModel
    }

    func create(collectionView: UICollectionView) -> CollectionViewDataSource {
        CharacterDetailDataSource(collectionView: collectionView, presentationModel: presentationModel)
    }
}

typealias CharacterDetailDiffableDataSource = UICollectionViewDiffableDataSource<CharacterDetailSection, AnyHashable>

class CharacterDetailDataSource: CollectionViewDataSource {
    private let presentationModel: CharacterDetailPresentationModelProtocol
    private let collectionView: UICollectionView

    private let imageRegistration = CellRegistration<CharacterImageCell>(handler: CharacterDetailDataSource.configure)
    private let infoRegistration = CellRegistration<CharacterInfoCell>(handler: CharacterDetailDataSource.configure)
    private let comicRegistration = CellRegistration<ComicCell>(handler: CharacterDetailDataSource.configure)
    private let comicHeaderRegistration = SupplementaryRegistration<CollectionSectionHeader>.header(
        handler: CharacterDetailDataSource.configure
    )

    private lazy var diffableDataSource: CharacterDetailDiffableDataSource = {
        let dataSource = CharacterDetailDiffableDataSource(collectionView: collectionView, cellProvider: provideCell)
        dataSource.supplementaryViewProvider = provideSupplementaryView
        return dataSource
    }()

    init(collectionView: UICollectionView, presentationModel: CharacterDetailPresentationModelProtocol) {
        self.presentationModel = presentationModel
        self.collectionView = collectionView
    }

    func setDataSource(of collectionView: UICollectionView) {
        collectionView.dataSource = diffableDataSource
    }

    func applySnapshot() {
        var snapshot = CharacterDetailDiffableDataSource.Snapshot()
        snapshot.appendSections([.image, .info, .comics])
        snapshot.appendItems([presentationModel.imageCellData], toSection: .image)
        snapshot.appendItems([presentationModel.infoCellData], toSection: .info)
        snapshot.appendItems(presentationModel.comicCellModels, toSection: .comics)
        diffableDataSource.apply(snapshot)
    }
}

private extension CharacterDetailDataSource {
    static func configure(_ imageCell: CharacterImageCell, at _: IndexPath, using model: CharacterImageCell.Item) {
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

    func provideCell(
        in collectionView: UICollectionView,
        forRowAt indexPath: IndexPath,
        with model: AnyHashable
    ) -> UICollectionViewCell {
        switch model {
        case let model as CharacterImageCell.Item:
            return collectionView.dequeueConfiguredReusableCell(using: imageRegistration, for: indexPath, item: model)
        case let model as CharacterInfoCell.Item:
            return collectionView.dequeueConfiguredReusableCell(using: infoRegistration, for: indexPath, item: model)
        case let model as ComicCell.Item:
            return collectionView.dequeueConfiguredReusableCell(using: comicRegistration, for: indexPath, item: model)
        default:
            fatalError()
        }
    }

    func provideSupplementaryView(
        in collectionView: UICollectionView,
        of _: String,
        forRowAt indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch CharacterDetailSection.fromSectionIndex(indexPath.section) {
        case .comics:
            return collectionView.dequeueConfiguredReusableSupplementary(using: comicHeaderRegistration, for: indexPath)
        default:
            return UICollectionReusableView()
        }
    }
}
