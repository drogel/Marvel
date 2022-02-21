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

    static func instantiate(
        presentationModel: PresentationModelProtocol,
        layout: UICollectionViewCompositionalLayout
    ) -> CharactersViewController {
        let viewController = instantiate(presentationModel: presentationModel)
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
        setUpNavigationController()
        setUpCollectionView()
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

extension CharactersViewController: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        1
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        presentationModel.numberOfItems
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cellData = presentationModel.cellData(at: indexPath) else { return UICollectionViewCell() }
        let cell = collectionView.dequeue(cellOfType: CharacterCell.self, at: indexPath)
        cell.configure(using: cellData)
        return cell
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
        collectionView.reloadData()
    }

    func model(_ presentationModel: CharactersPresentationModelProtocol, didFailWithError message: String) {
        showErrorAlert(message: message, retryButtonAction: presentationModel.start)
    }
}

private extension CharactersViewController {
    func setUpNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "characters".localized
    }

    func setUpCollectionView() {
        let collectionView = createCollectionView()
        setSubview(collectionView)
        configureDataSource(of: collectionView)
        configureConstraints(of: collectionView)
        registerSubviews(in: collectionView)
    }

    func createCollectionView() -> UICollectionView {
        UICollectionView(frame: .zero, collectionViewLayout: layout)
    }

    func setSubview(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        view.addSubview(collectionView)
    }

    func configureDataSource(of collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    func configureConstraints(of collectionView: UICollectionView) {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.fit(collectionView, in: view)
    }

    func registerSubviews(in collectionView: UICollectionView) {
        collectionView.register(cellOfType: CharacterCell.self)
    }
}
