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

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var infoBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = Constants.Info.spacing
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var characterImageView = CharacterImageView()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constants.Info.nameFontSize)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constants.Info.descriptionFontSize)
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()

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
        characterImageView.clear()
        viewModel.dispose()
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
    func viewModelDidStartLoading(_: CharacterDetailViewModelProtocol) {
        startLoading()
    }

    func viewModelDidFinishLoading(_: CharacterDetailViewModelProtocol) {
        stopLoading()
    }

    func viewModel(_: CharacterDetailViewModelProtocol, didRetrieve characterDetail: CharacterDetailData) {
        configure(using: characterDetail)
    }

    func viewModel(_ viewModel: CharacterDetailViewModelProtocol, didFailWithError message: String) {
        showErrorAlert(message: message, buttonAction: viewModel.start)
    }
}

private extension CharacterDetailViewController {
    func setUp() {
        setUpBackground()
        setUpSubviews()
        setUpConstraints()
    }

    func setUpBackground() {
        view.backgroundColor = .systemBackground
    }

    func setUpSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(characterImageView)
        mainStackView.addArrangedSubview(infoBackgroundView)
        infoBackgroundView.addSubview(infoStackView)
        infoStackView.addArrangedSubview(nameLabel)
        infoStackView.addArrangedSubview(descriptionLabel)
    }

    func setUpConstraints() {
        setUpScrollViewConstraints()
        setUpMainStackViewViewConstraints()
        setUpInfoStackViewConstraints()
        setUpCharacterImageViewConstraints()
    }

    func setUpScrollViewConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    func setUpMainStackViewViewConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            mainStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }

    func setUpInfoStackViewConstraints() {
        let inset = Constants.Info.inset
        NSLayoutConstraint.activate([
            infoStackView.leadingAnchor.constraint(equalTo: infoBackgroundView.leadingAnchor, constant: inset),
            infoStackView.topAnchor.constraint(equalTo: infoBackgroundView.topAnchor, constant: inset),
            infoStackView.trailingAnchor.constraint(equalTo: infoBackgroundView.trailingAnchor, constant: -inset),
            infoStackView.bottomAnchor.constraint(equalTo: infoBackgroundView.bottomAnchor, constant: -inset),
        ])
    }

    func setUpCharacterImageViewConstraints() {
        let multiplier = Constants.imageHeightMultiplier
        NSLayoutConstraint.activate([
            characterImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier),
        ])
    }
}
