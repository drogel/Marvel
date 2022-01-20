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
        static let infoStackViewInset: CGFloat = 12
        static let infoStackViewSpacing: CGFloat = 4
        static let nameLabelFontSize: CGFloat = 20
        static let descriptionLabelFontSize: CGFloat = 12
        static let descriptionMaxLines = 2
        static let cellCornerRadius: CGFloat = 16
        static let infoViewHeight: CGFloat = nameLabelFontSize + CGFloat(descriptionMaxLines)*descriptionLabelFontSize + 2*infoStackViewInset + 4*infoStackViewSpacing
    }

    private lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = Constants.infoStackViewSpacing
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
        label.font = .boldSystemFont(ofSize: Constants.descriptionLabelFontSize)
        label.textColor = .systemGray
        label.numberOfLines = Constants.descriptionMaxLines
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
        descriptionLabel.text = configurator.description
        descriptionLabel.isHidden = configurator.description.isEmpty
    }
}

private extension CharacterCell {

    func setUp() {
        // TODO: Remove contentView backgroundColor assignment. This is just for testing purposes.
        contentView.backgroundColor = .systemRed
        setUpSubviews()
        setUpConstraints()
        setUpCellStyle()
    }

    func setUpSubviews() {
        contentView.addSubview(infoView)
        contentView.addSubview(infoStackView)
        infoStackView.addArrangedSubview(nameLabel)
        infoStackView.addArrangedSubview(descriptionLabel)
    }

    func setUpConstraints() {
        NSLayoutConstraint.activate([
            infoView.heightAnchor.constraint(equalToConstant: Constants.infoViewHeight),
            infoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            infoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            infoStackView.topAnchor.constraint(equalTo: infoView.topAnchor, constant: Constants.infoStackViewInset),
            infoStackView.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: Constants.infoStackViewInset),
            infoStackView.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -Constants.infoStackViewInset),
            infoStackView.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -Constants.infoStackViewInset)
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
}
