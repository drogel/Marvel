//
//  CharactersViewController.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import UIKit

class CharactersViewController: UIViewController {

    var viewModel: CharactersViewModelProtocol!
    var layout: UICollectionViewCompositionalLayout?

    private var collectionView: UICollectionView!

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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.identifier, for: indexPath) as! CharacterCell
        // TODO: Make cells configurable from view models
        cell.backgroundColor = .red
        return cell
    }
}

extension CharactersViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.select(itemAt: indexPath)
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
        guard let collectionView = createCollectionView() else { return }
        setSubview(collectionView)
        configureDataSource(of: collectionView)
        configureConstraints(of: collectionView)
        registerSubviews(in: collectionView)
    }

    func createCollectionView() -> UICollectionView? {
        guard let layout = layout else { return nil }
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
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
