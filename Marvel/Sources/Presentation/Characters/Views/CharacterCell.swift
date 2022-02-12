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
            static let height = CGFloat(maxLines) * labelFontSize
        }

        enum Info {
            static let stackViewInset: CGFloat = 12
            static let stackViewSpacing: CGFloat = 4
            static let viewAlpha = 0.93
            static var height: CGFloat {
                nameLabelFontSize + Description.height + 2 * stackViewInset + 4 * stackViewSpacing
            }
        }

        enum Shadow {
            static let opacity: Float = 0.15
            static let offset = CGSize(width: 0, height: 6)
            static let radius: CGFloat = 10
        }
    }

    private lazy var characterImageView = FillImageView()

    private lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
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
        label.font = .systemFont(ofSize: Constants.Description.labelFontSize)
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

    override func prepareForReuse() {
        characterImageView.clear()
    }

    func configure(using item: CharacterCellData) {
        nameLabel.text = item.name
        configureDescription(using: item)
        characterImageView.loadImage(from: item.imageURL)
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
        NSLayoutConstraint.fit(infoStackView, in: infoView, inset: Constants.Info.stackViewInset)
        NSLayoutConstraint.activate([
            infoView.heightAnchor.constraint(equalToConstant: Constants.Info.height),
            infoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            infoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    func setUpCharacterImageConstraints() {
        NSLayoutConstraint.fit(characterImageView, in: contentView)
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
        layer.shadowOpacity = Constants.Shadow.opacity
        layer.shadowOffset = Constants.Shadow.offset
        layer.shadowRadius = Constants.Shadow.radius
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: Constants.cellCornerRadius).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }

    func configureDescription(using configurator: CharacterCellData) {
        descriptionLabel.text = configurator.description
        descriptionLabel.isHidden = configurator.description.isEmpty
    }
}
