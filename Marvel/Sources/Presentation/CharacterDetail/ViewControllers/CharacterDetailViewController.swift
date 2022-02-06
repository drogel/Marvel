//
//  CharacterDetailViewController.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import UIKit

class CharacterDetailViewController: ViewController {
    typealias ViewModelProtocol = ViewModel

    private enum Constants {
        static let collectionContentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }

    private var viewModel: ViewModelProtocol!
    private var collectionView: UICollectionView!
    private var dataSource: CollectionViewDataSource!
    private var collectionViewDelegate: UICollectionViewDelegate!
    private var layout: UICollectionViewCompositionalLayout!

    static func instantiate(
        viewModel: ViewModelProtocol,
        dataSource: CollectionViewDataSource,
        collectionViewDelegate: UICollectionViewDelegate,
        layout: UICollectionViewCompositionalLayout
    ) -> Self {
        let viewController = instantiate(viewModel: viewModel)
        viewController.dataSource = dataSource
        viewController.collectionViewDelegate = collectionViewDelegate
        viewController.layout = layout
        return viewController
    }

    static func instantiate(viewModel: ViewModelProtocol) -> Self {
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

    func viewModelDidRetrieveCharacterInfo(_: CharacterDetailViewModelProtocol) {
        reload()
    }

    func viewModelDidRetrieveComics(_: CharacterDetailViewModelProtocol) {
        reload()
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
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = Constants.collectionContentInset
        return collectionView
    }

    func setSubview(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        view.addSubview(collectionView)
    }

    func configureDataSource(of collectionView: UICollectionView) {
        collectionView.dataSource = dataSource
        collectionView.delegate = collectionViewDelegate
        dataSource.registerSubviews(in: collectionView)
    }

    func configureConstraints(of collectionView: UICollectionView) {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.fit(collectionView, in: view)
    }

    func reload() {
        collectionView.reloadData()
    }
}
