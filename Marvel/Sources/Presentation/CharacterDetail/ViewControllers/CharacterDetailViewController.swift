//
//  CharacterDetailViewController.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import UIKit

class CharacterDetailViewController: ViewController {

    typealias ViewModel = CharacterDetailViewModelProtocol

    private var viewModel: ViewModel!

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var characterImageView: UIImageView = {
        // TODO: This turns out to be exactly the same as CharacterCell. Consider extracting.
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .tertiarySystemGroupedBackground
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()

    static func instantiate(viewModel: ViewModel) -> Self {
        let viewController = CharacterDetailViewController()
        viewController.viewModel = viewModel
        return viewController as! Self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        viewModel.start()
    }
}

extension CharacterDetailViewController: Configurable {

    typealias Item = CharacterDetailData

    func configure(using item: CharacterDetailData) {
        nameLabel.text = item.name
        descriptionLabel.text = item.description
        characterImageView.loadImage(from: item.imageURL)
    }
}

extension CharacterDetailViewController: CharacterDetailViewModelViewDelegate {

    func viewModelDidStartLoading(_ viewModel: CharacterDetailViewModelProtocol) {
        startLoading()
    }

    func viewModelDidFinishLoading(_ viewModel: CharacterDetailViewModelProtocol) {
        stopLoading()
    }

    func viewModel(_ viewModel: CharacterDetailViewModelProtocol, didRetrieve characterDetail: CharacterDetailData) {
        configure(using: characterDetail)
    }
}

private extension CharacterDetailViewController {

    func setUp() {
        // TODO: Fix scroll view constraints when content is long
        setUpBackground()
        setUpSubviews()
        setUpConstraints()
    }

    func setUpBackground() {
        view.backgroundColor = .systemBackground
    }

    func setUpSubviews() {
        view.addSubview(scrollView)
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(characterImageView)
        mainStackView.addArrangedSubview(nameLabel)
        mainStackView.addArrangedSubview(descriptionLabel)
    }

    func setUpConstraints() {
        setUpScrollViewConstraints()
        setUpMainStackViewViewConstraints()
        setUpCharacterImageViewConstraints()
    }

    func setUpScrollViewConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setUpMainStackViewViewConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])
    }

    func setUpCharacterImageViewConstraints() {
        NSLayoutConstraint.activate([
            characterImageView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
}
