//
//  CharacterDetailViewController.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import Combine
import UIKit

class CharacterDetailViewController: ViewController {
    typealias PresentationModelProtocol = CharacterDetailPresentationModelProtocol

    private enum Constants {
        static let collectionContentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }

    private var presentationModel: PresentationModelProtocol!
    private var collectionView: UICollectionView!
    private var dataSource: CollectionViewDataSource!
    private var collectionViewDelegate: UICollectionViewDelegate!
    private var layout: UICollectionViewCompositionalLayout!
    private var dataSourceFactory: CollectionViewDataSourceFactory!
    private var cancellables = Set<AnyCancellable>()

    static func instantiate(
        presentationModel: PresentationModelProtocol,
        layout: UICollectionViewCompositionalLayout,
        dataSourceFactory: CollectionViewDataSourceFactory
    ) -> Self {
        let viewController = instantiate(presentationModel: presentationModel)
        viewController.layout = layout
        viewController.dataSourceFactory = dataSourceFactory
        return viewController
    }

    static func instantiate(presentationModel: PresentationModelProtocol) -> Self {
        let viewController = Self()
        viewController.presentationModel = presentationModel
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        presentationModel.start()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presentationModel.dispose()
    }
}

extension CharacterDetailViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch CharacterDetailSection.fromSectionIndex(indexPath.section) {
        case .comics:
            return presentationModel.willDisplayComicCell(at: indexPath)
        default:
            return
        }
    }
}

extension CharacterDetailViewController: CharacterDetailPresentationModelViewDelegate {
    func modelDidStartLoading(_: CharacterDetailPresentationModelProtocol) {
        startLoading()
    }

    func modelDidFinishLoading(_: CharacterDetailPresentationModelProtocol) {
        stopLoading()
    }

    func modelDidRetrieveCharacterInfo(_: CharacterDetailPresentationModelProtocol) {}

    func modelDidRetrieveComics(_: CharacterDetailPresentationModelProtocol) {}

    func model(_ presentationModel: CharacterDetailPresentationModelProtocol, didFailWithError message: String) {
        showErrorAlert(message: message, retryButtonAction: presentationModel.start)
    }
}

private extension CharacterDetailViewController {
    func setUp() {
        setUpCollectionView()
        subscribeToDetail()
    }

    func setUpCollectionView() {
        let collectionView = createCollectionView()
        setSubview(collectionView)
        configureDataSource(of: collectionView)
        configureConstraints(of: collectionView)
    }

    func subscribeToDetail() {
        presentationModel.detailStatePublisher
            .sink(receiveValue: handleState)
            .store(in: &cancellables)
    }

    func handleState(_ state: CharacterDetailViewModelState) {
        switch state {
        case let .success(detailModel):
            dataSource.update(with: [detailModel])
        case .failure:
            // TODO: Implement
            return
        }
    }

    func createCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = Constants.collectionContentInset
        return collectionView
    }

    func setSubview(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        view.addSubview(collectionView)
    }

    func configureDataSource(of collectionView: UICollectionView) {
        dataSource = dataSourceFactory.create(collectionView: collectionView)
        collectionView.delegate = collectionViewDelegate
        dataSource.setDataSource(of: collectionView)
    }

    func configureConstraints(of collectionView: UICollectionView) {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.fit(collectionView, in: view)
    }
}
