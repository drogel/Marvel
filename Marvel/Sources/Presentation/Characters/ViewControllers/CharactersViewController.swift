//
//  CharactersViewController.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import UIKit

class CharactersViewController: ViewController {
    typealias PresentationModelProtocol = CharactersPresentationModelProtocol

    private enum Constants {
        static let scrollNearEndThreshold: CGFloat = 300
    }

    private var presentationModel: PresentationModelProtocol!
    private var layout: UICollectionViewCompositionalLayout!
    private var collectionView: UICollectionView!
    private var dataSource: CollectionViewDataSource!
    private var dataSourceFactory: CharactersDataSourceFactory!

    static func instantiate(
        presentationModel: PresentationModelProtocol,
        layout: UICollectionViewCompositionalLayout,
        dataSourceFactory: CharactersDataSourceFactory
    ) -> CharactersViewController {
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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentationModel.start()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presentationModel.dispose()
    }
}

extension CharactersViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentationModel.select(at: indexPath)
    }

    func collectionView(_: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presentationModel.willDisplayCell(at: indexPath)
    }
}

extension CharactersViewController: CharactersPresentationModelViewDelegate {
    func modelDidStartLoading(_: CharactersPresentationModelProtocol) {
        startLoading()
    }

    func modelDidFinishLoading(_: CharactersPresentationModelProtocol) {
        stopLoading()
    }

    func modelDidUpdateItems(_: CharactersPresentationModelProtocol) {
        dataSource.applySnapshot()
    }

    func model(_ presentationModel: CharactersPresentationModelProtocol, didFailWithError message: String) {
        showErrorAlert(message: message, retryButtonAction: presentationModel.start)
    }
}

private extension CharactersViewController {
    func setUp() {
        setUpNavigationController()
        setUpCollectionView()
    }

    func setUpNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "characters".localized
    }

    func setUpCollectionView() {
        let collectionView = createCollectionView()
        setSubview(collectionView)
        configureDataSource(of: collectionView)
        configureConstraints(of: collectionView)
    }

    func createCollectionView() -> UICollectionView {
        UICollectionView(frame: .zero, collectionViewLayout: layout)
    }

    func setSubview(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        view.addSubview(collectionView)
    }

    func configureDataSource(of collectionView: UICollectionView) {
        dataSource = dataSourceFactory.create(collectionView: collectionView, presentationModel: presentationModel)
        dataSource.setDataSource(of: collectionView)
        collectionView.delegate = self
    }

    func configureConstraints(of collectionView: UICollectionView) {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.fit(collectionView, in: view)
    }
}
