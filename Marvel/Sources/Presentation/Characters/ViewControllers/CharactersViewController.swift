//
//  CharactersViewController.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import UIKit

class CharactersViewController: UIViewController {

    private var viewModel: CharactersViewModelProtocol!
    private var layout: UICollectionViewCompositionalLayout!
    private var collectionView: UICollectionView!

    static func instantiate(viewModel: CharactersViewModelProtocol, layout: UICollectionViewCompositionalLayout) -> CharactersViewController {
        let viewController = CharactersViewController()
        viewController.viewModel = viewModel
        viewController.layout = layout
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationController()
        setUpCollectionView()
        viewModel.start()
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
        // TODO: Move this to a util method to avoid jumping between abstraction layers
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.identifier, for: indexPath) as! CharacterCell
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
        // TODO: Implement
    }

    func viewModelDidFinishLoading(_ viewModel: CharactersViewModelProtocol) {
        // TODO: Implement
    }

    func viewModelDidUpdateItems(_ viewModel: CharactersViewModelProtocol) {
        collectionView.reloadData()
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
