//
//  CharacterInfoCell.swift
//  Marvel
//
//  Created by Diego Rogel on 2/2/22.
//

import Foundation
import UIKit

class CharacterInfoCell: UICollectionViewCell {
    private enum Constants {
        static let spacing: CGFloat = 8
        static let nameFontSize: CGFloat = 28
        static let descriptionFontSize: CGFloat = 12
        static let inset: CGFloat = 20
    }

    private lazy var infoBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = Constants.spacing
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constants.nameFontSize)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constants.descriptionFontSize)
        label.textColor = .systemGray
        label.numberOfLines = 0
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
}

extension CharacterInfoCell: Configurable {
    typealias Item = CharacterInfoData?

    func configure(using item: CharacterInfoData?) {
        nameLabel.text = item?.name
        configure(description: item?.description)
    }
}

private extension CharacterInfoCell {
    func setUp() {
        setUpSubviews()
        setUpConstraints()
    }

    func setUpConstraints() {
        setUpInfoBackgroundViewConstraints()
        setUpInfoStackViewConstraints()
    }

    func setUpSubviews() {
        contentView.addSubview(infoBackgroundView)
        infoBackgroundView.addSubview(infoStackView)
        infoStackView.addArrangedSubview(nameLabel)
        infoStackView.addArrangedSubview(descriptionLabel)
    }

    func setUpInfoBackgroundViewConstraints() {
        NSLayoutConstraint.fit(infoBackgroundView, in: contentView)
    }

    func setUpInfoStackViewConstraints() {
        let inset = Constants.inset
        NSLayoutConstraint.fit(infoStackView, in: infoBackgroundView, inset: inset)
    }

    func configure(description: String?) {
        descriptionLabel.text = description
        descriptionLabel.isHidden = description.isNilOrEmpty
    }
}
