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

    func update<T: Hashable>(with items: [T]) {
        applySnapshot(with: items)
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
    ) -> UICollectionViewCell? {
        switch CharacterDetailSection.fromSectionIndex(indexPath.section) {
        case .image:
            return imageCell(in: collectionView, forRowAt: indexPath, with: model)
        case .info:
            return infoCell(in: collectionView, forRowAt: indexPath, with: model)
        case .comics:
            return comicCell(in: collectionView, forRowAt: indexPath, with: model)
        }
    }

    func imageCell(
        in collectionView: UICollectionView,
        forRowAt indexPath: IndexPath,
        with model: AnyHashable
    ) -> UICollectionViewCell? {
        guard let image = model as? CharacterImageCell.Item else { return nil }
        return collectionView.dequeueConfiguredReusableCell(using: imageRegistration, for: indexPath, item: image)
    }

    func infoCell(
        in collectionView: UICollectionView,
        forRowAt indexPath: IndexPath,
        with model: AnyHashable
    ) -> UICollectionViewCell? {
        guard let info = model as? CharacterInfoCell.Item else { return nil }
        return collectionView.dequeueConfiguredReusableCell(using: infoRegistration, for: indexPath, item: info)
    }

    func comicCell(
        in collectionView: UICollectionView,
        forRowAt indexPath: IndexPath,
        with model: AnyHashable
    ) -> UICollectionViewCell? {
        guard let comic = model as? ComicCell.Item else { return nil }
        return collectionView.dequeueConfiguredReusableCell(using: comicRegistration, for: indexPath, item: comic)
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

    func applySnapshot(with items: [AnyHashable]) {
        guard let snapshot = createSnapshot(with: items) else { return }
        diffableDataSource.apply(snapshot)
    }

    func createSnapshot(with items: [AnyHashable]) -> CharacterDetailDiffableDataSource.Snapshot? {
        guard let details = items as? [CharacterDetailModel] else { return nil }
        return createDetailSnapshot(with: details)
    }

    func createDetailSnapshot(with items: [CharacterDetailModel]) -> CharacterDetailDiffableDataSource.Snapshot {
        var snapshot = CharacterDetailDiffableDataSource.Snapshot()
        let images = items.compactMap(\.info?.image)
        let descriptions = items.compactMap(\.info?.description)
        let comics = items.flatMap(\.comics)
        snapshot.appendSections([.image, .info, .comics])
        snapshot.appendItems(images, toSection: .image)
        snapshot.appendItems(descriptions, toSection: .info)
        snapshot.appendItems(comics, toSection: .comics)
        return snapshot
    }
}
