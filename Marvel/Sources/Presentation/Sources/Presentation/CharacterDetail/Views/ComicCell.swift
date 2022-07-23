//
//  ComicCell.swift
//  Marvel
//
//  Created by Diego Rogel on 6/2/22.
//

import Foundation
import UIKit

class ComicCell: ConfigurableCell {
    private enum Constants {
        static let mainStackViewSpacing: CGFloat = 8
        static let infoStackViewSpacing: CGFloat = 2

        enum Title {
            static let labelFontSize: CGFloat = 14
            static let maxLines = 2
        }

        enum Subtitle {
            static let fontSize: CGFloat = 10
            static let maxLines = 1
        }

        enum Image {
            static let maxHeight: CGFloat = 210
            static let cornerRadius: CGFloat = 6
            static let aspectRatio: CGFloat = 1.544
        }
    }

    private lazy var comicImageView = FillImageView()

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = Constants.mainStackViewSpacing
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = Constants.infoStackViewSpacing
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.Title.labelFontSize)
        label.numberOfLines = Constants.Title.maxLines
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.Subtitle.fontSize)
        label.textColor = .systemGray
        label.numberOfLines = Constants.Subtitle.maxLines
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
        comicImageView.clear()
    }
}

extension ComicCell {
    typealias Item = ComicCellModel

    func configure(using item: ComicCellModel) {
        titleLabel.text = item.title
        subtitleLabel.text = String(item.issueNumber)
        comicImageView.loadImage(from: item.imageURL)
    }
}

private extension ComicCell {
    func setUp() {
        setUpSubviews()
        setUpConstraints()
        setUpImageStyle()
    }

    func setUpSubviews() {
        contentView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(comicImageView)
        mainStackView.addArrangedSubview(infoStackView)
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(subtitleLabel)
    }

    func setUpConstraints() {
        setUpMainStackViewConstraints()
        setUpComicImageConstraints()
    }

    func setUpComicImageConstraints() {
        comicImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        NSLayoutConstraint.activate([
            comicImageView.heightAnchor.constraint(lessThanOrEqualToConstant: Constants.Image.maxHeight),
        ])
    }

    func setUpMainStackViewConstraints() {
        NSLayoutConstraint.fit(mainStackView, in: contentView)
    }

    func setUpImageStyle() {
        comicImageView.layer.cornerRadius = Constants.Image.cornerRadius
        comicImageView.layer.masksToBounds = true
    }
}
