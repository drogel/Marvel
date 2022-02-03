//
//  CharacterDetailViewController.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import UIKit

class CharacterDetailViewController: ViewController {
    typealias ViewModel = CharacterDetailViewModelProtocol

    private enum Constants {
        static let imageHeightMultiplier = 0.618

        enum Info {
            static let spacing: CGFloat = 8
            static let nameFontSize: CGFloat = 28
            static let descriptionFontSize: CGFloat = 12
            static let inset: CGFloat = 20
        }
    }

    private var viewModel: ViewModel!
    private var collectionView: UICollectionView!
    private var dataSource: CollectionViewDataSource!

    static func instantiate(viewModel: ViewModel, dataSource: CollectionViewDataSource) -> Self {
        let viewController = instantiate(viewModel: viewModel)
        viewController.dataSource = dataSource
        return viewController
    }

    static func instantiate(viewModel: ViewModel) -> Self {
        let viewController = Self()
        viewController.viewModel = viewModel
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        viewModel.start()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.dispose()
    }
}

extension CharacterDetailViewController: CharacterDetailViewModelViewDelegate {
    func viewModelDidStartLoading(_: CharacterDetailViewModelProtocol) {
        startLoading()
    }

    func viewModelDidFinishLoading(_: CharacterDetailViewModelProtocol) {
        stopLoading()
    }

    func viewModelDidRetrieveData(_: CharacterDetailViewModelProtocol) {
        collectionView.reloadData()
    }

    func viewModel(_ viewModel: CharacterDetailViewModelProtocol, didFailWithError message: String) {
        showErrorAlert(message: message, retryButtonAction: viewModel.start)
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
        // TODO: Develop an actual character detail layout
        UICollectionView(frame: .zero, collectionViewLayout: CharactersLayout())
    }

    func setSubview(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        view.addSubview(collectionView)
    }

    func configureDataSource(of collectionView: UICollectionView) {
        collectionView.dataSource = dataSource
        dataSource.registerSubviews(in: collectionView)
    }

    func configureConstraints(of collectionView: UICollectionView) {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.fit(collectionView, in: view)
    }
}
