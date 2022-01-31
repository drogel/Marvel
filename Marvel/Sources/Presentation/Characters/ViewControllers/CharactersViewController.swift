//
//  CharactersViewController.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import UIKit

class CharactersViewController: ViewController {

    typealias ViewModel = CharactersViewModelProtocol

    private var viewModel: ViewModel!
    private var layout: UICollectionViewCompositionalLayout!
    private var collectionView: UICollectionView!

    static func instantiate(viewModel: ViewModel, layout: UICollectionViewCompositionalLayout) -> CharactersViewController {
        let viewController = instantiate(viewModel: viewModel)
        viewController.layout = layout
        return viewController
    }

    static func instantiate(viewModel: ViewModel) -> Self {
        let viewController = Self()
        viewController.viewModel = viewModel
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationController()
        setUpCollectionView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.start()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.dispose()
    }
}

extension CharactersViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellData = viewModel.cellData(at: indexPath) else { return UICollectionViewCell() }
        let cell = collectionView.dequeue(cellOfType: CharacterCell.self, at: indexPath)
        cell.configure(using: cellData)
        return cell
    }
}

extension CharactersViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.select(at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.willDisplayCell(at: indexPath)
    }
}

extension CharactersViewController: CharactersViewModelViewDelegate {

    func viewModelDidStartLoading(_ viewModel: CharactersViewModelProtocol) {
        startLoading()
    }

    func viewModelDidFinishLoading(_ viewModel: CharactersViewModelProtocol) {
        stopLoading()
    }

    func viewModelDidUpdateItems(_ viewModel: CharactersViewModelProtocol) {
        collectionView.reloadData()
    }

    func viewModel(_ viewModel: CharactersViewModelProtocol, didFailWithError message: String) {
        showErrorAlert(message: message, buttonAction: viewModel.start)
    }
}

private extension CharactersViewController {

    func setUpNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Characters"
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
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func registerSubviews(in collectionView: UICollectionView) {
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.identifier)
    }
}
