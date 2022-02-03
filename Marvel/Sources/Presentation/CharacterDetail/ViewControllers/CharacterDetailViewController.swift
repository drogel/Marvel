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

    private enum Section: Int {
        case image
        case info
    }

    private var viewModel: ViewModel!
    private var collectionView: UICollectionView!

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

extension CharacterDetailViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }

    func collectionView(_: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Section(rawValue: indexPath.section) else { fatalError() }
        switch section {
        case .image:
            return imageCell(in: collectionView, at: indexPath)
        case .info:
            return infoCell(in: collectionView, at: indexPath)
        }
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
        registerSubviews(in: collectionView)
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
        collectionView.dataSource = self
    }

    func configureConstraints(of collectionView: UICollectionView) {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.fit(collectionView, in: view)
    }

    func registerSubviews(in collectionView: UICollectionView) {
        collectionView.register(CharacterImageCell.self, forCellWithReuseIdentifier: CharacterImageCell.identifier)
        collectionView.register(CharacterInfoCell.self, forCellWithReuseIdentifier: CharacterInfoCell.identifier)
    }

    func imageCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cellOfType: CharacterImageCell.self, at: indexPath)
        cell.configure(using: viewModel.imageCellData)
        return cell
    }

    func infoCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cellOfType: CharacterInfoCell.self, at: indexPath)
        cell.configure(using: viewModel.infoCellData)
        return cell
    }
}
