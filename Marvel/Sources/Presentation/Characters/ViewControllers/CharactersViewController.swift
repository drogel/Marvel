//
//  CharactersViewController.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import UIKit

class CharactersViewController: ViewController {
    typealias ViewModelProtocol = CharactersViewModelProtocol

    private enum Constants {
        static let scrollNearEndThreshold: CGFloat = 300
    }

    private var viewModel: ViewModelProtocol!
    private var layout: UICollectionViewCompositionalLayout!
    private var collectionView: UICollectionView!

    static func instantiate(
        viewModel: ViewModelProtocol,
        layout: UICollectionViewCompositionalLayout
    ) -> CharactersViewController {
        let viewController = instantiate(viewModel: viewModel)
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
    func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel.numberOfItems
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cellData = viewModel.cellData(at: indexPath) else { return UICollectionViewCell() }
        let cell = collectionView.dequeue(cellOfType: CharacterCell.self, at: indexPath)
        cell.configure(using: cellData)
        return cell
    }
}

extension CharactersViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.select(at: indexPath)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isScrollView(scrollView, scrollingNearEndWithThreshold: Constants.scrollNearEndThreshold) {
            willDisplayCell(at: collectionView.contentOffset)
        }
    }
}

extension CharactersViewController: CharactersViewModelViewDelegate {
    func viewModelDidStartLoading(_: CharactersViewModelProtocol) {
        startLoading()
    }

    func viewModelDidFinishLoading(_: CharactersViewModelProtocol) {
        stopLoading()
    }

    func viewModelDidUpdateItems(_: CharactersViewModelProtocol) {
        collectionView.reloadData()
    }

    func viewModel(_ viewModel: CharactersViewModelProtocol, didFailWithError message: String) {
        showErrorAlert(message: message, retryButtonAction: viewModel.start)
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

    func willDisplayCell(at contentOffset: CGPoint) {
        guard let indexPath = collectionView.indexPathForCellAtBoundsEdge(of: contentOffset) else { return }
        viewModel.willDisplayCell(at: indexPath)
    }

    func isScrollView(_ scrollView: UIScrollView, scrollingNearEndWithThreshold nearEndThreshold: CGFloat) -> Bool {
        let scrollViewFrameHeight = scrollView.frame.size.height
        let offsetDistanceToBottom = scrollView.offsetDistanceToBottom
        return offsetDistanceToBottom < scrollViewFrameHeight + nearEndThreshold
    }
}
