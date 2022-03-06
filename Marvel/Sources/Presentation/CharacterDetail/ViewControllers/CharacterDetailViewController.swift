//
//  CharacterDetailViewController.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import UIKit

class CharacterDetailViewController: ViewController {
    typealias PresentationModelProtocol = PresentationModel

    private enum Constants {
        static let collectionContentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }

    private var presentationModel: PresentationModelProtocol!
    private var collectionView: UICollectionView!
    private var dataSource: CollectionViewDataSource!
    private var collectionViewDelegate: UICollectionViewDelegate!
    private var layout: UICollectionViewCompositionalLayout!

    static func instantiate(
        presentationModel: PresentationModelProtocol,
        dataSource: CollectionViewDataSource,
        collectionViewDelegate: UICollectionViewDelegate,
        layout: UICollectionViewCompositionalLayout
    ) -> Self {
        let viewController = instantiate(presentationModel: presentationModel)
        viewController.dataSource = dataSource
        viewController.collectionViewDelegate = collectionViewDelegate
        viewController.layout = layout
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

extension CharacterDetailViewController: CharacterDetailPresentationModelViewDelegate {
    func modelDidStartLoading(_: CharacterDetailPresentationModelProtocol) {
        startLoading()
    }

    func modelDidFinishLoading(_: CharacterDetailPresentationModelProtocol) {
        stopLoading()
    }

    func modelDidRetrieveCharacterInfo(_: CharacterDetailPresentationModelProtocol) {
        reload()
    }

    func modelDidRetrieveComics(_: CharacterDetailPresentationModelProtocol) {
        reload()
    }

    func model(_ presentationModel: CharacterDetailPresentationModelProtocol, didFailWithError message: String) {
        showErrorAlert(message: message, retryButtonAction: presentationModel.start)
    }
}

private extension CharacterDetailViewController {
    func setUp() {
        setUpCollectionView()
    }

    func setUpCollectionView() {
        let collectionView = createCollectionView()
        setSubview(collectionView)
        configureDataSource(of: collectionView)
        configureConstraints(of: collectionView)
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
        collectionView.delegate = collectionViewDelegate
        dataSource.setDataSource(of: collectionView)
    }

    func configureConstraints(of collectionView: UICollectionView) {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.fit(collectionView, in: view)
    }

    func reload() {
        collectionView.reloadData()
    }
}
