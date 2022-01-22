//
//  CharacterCell.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import UIKit

class CharacterCell: UICollectionViewCell, Configurable {

    typealias Item = CharacterCellData

    private enum Constants {

        static let nameLabelFontSize: CGFloat = 20
        static let cellCornerRadius: CGFloat = 16

        enum Description {
            static let labelFontSize: CGFloat = 12
            static let maxLines = 2
            static let height = CGFloat(maxLines)*labelFontSize
        }

        enum Info {
            static let stackViewInset: CGFloat = 12
            static let stackViewSpacing: CGFloat = 4
            static let viewAlpha = 0.93
            static let height: CGFloat = nameLabelFontSize + Description.height + 2*stackViewInset + 4*stackViewSpacing
        }
    }

    private lazy var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .tertiarySystemGroupedBackground
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = Constants.Info.viewAlpha
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = Constants.Info.stackViewSpacing
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constants.nameLabelFontSize)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constants.Description.labelFontSize)
        label.textColor = .systemGray
        label.numberOfLines = Constants.Description.maxLines
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }

    func configure(using configurator: CharacterCellData) {
        nameLabel.text = configurator.name
        configureDescription(using: configurator)
        characterImageView.loadImage(from: configurator.imageURL)
    }
}

private extension CharacterCell {

    func setUp() {
        setUpSubviews()
        setUpConstraints()
        setUpCellStyle()
    }

    func setUpSubviews() {
        contentView.addSubview(characterImageView)
        contentView.addSubview(infoView)
        contentView.addSubview(infoStackView)
        infoStackView.addArrangedSubview(nameLabel)
        infoStackView.addArrangedSubview(descriptionLabel)
    }

    func setUpConstraints() {
        setUpInfoConstraints()
        setUpCharacterImageConstraints()
    }

    func setUpInfoConstraints() {
        NSLayoutConstraint.activate([
            infoView.heightAnchor.constraint(equalToConstant: Constants.Info.height),
            infoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            infoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            infoStackView.topAnchor.constraint(equalTo: infoView.topAnchor, constant: Constants.Info.stackViewInset),
            infoStackView.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: Constants.Info.stackViewInset),
            infoStackView.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -Constants.Info.stackViewInset),
            infoStackView.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -Constants.Info.stackViewInset)
        ])
    }

    func setUpCharacterImageConstraints() {
        NSLayoutConstraint.activate([
            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            characterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            characterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func setUpCellStyle() {
        setUpCellShadow()
        setUpCellCornerRadius()
    }

    func setUpCellCornerRadius() {
        contentView.layer.cornerRadius = Constants.cellCornerRadius
        contentView.layer.masksToBounds = true
    }

    func setUpCellShadow() {
        // TODO: When the device rotates, bounds are not being updated, and shadows don't match cell bounds. Fix this.
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 6)
        layer.shadowRadius = 8
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: Constants.cellCornerRadius).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }

    func configureDescription(using configurator: CharacterCellData) {
        descriptionLabel.text = configurator.description
        descriptionLabel.isHidden = configurator.description.isEmpty
    }
}
