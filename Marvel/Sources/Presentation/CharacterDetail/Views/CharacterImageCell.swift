//
//  CharacterImageCell.swift
//  Marvel
//
//  Created by Diego Rogel on 2/2/22.
//

import Foundation
import UIKit

class CharacterImageCell: UICollectionViewCell {
    private lazy var characterImageView = FillImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        characterImageView.clear()
    }
}

extension CharacterImageCell: Configurable {
    typealias Item = CharacterImageModel?

    func configure(using item: CharacterImageModel?) {
        characterImageView.loadImage(from: item?.imageURL)
    }
}

private extension CharacterImageCell {
    func setUp() {
        setUpSubviews()
        setUpConstraints()
        setUpContentView()
    }

    func setUpSubviews() {
        contentView.addSubview(characterImageView)
    }

    func setUpConstraints() {
        NSLayoutConstraint.fit(characterImageView, in: contentView)
    }

    func setUpContentView() {
        contentView.clipsToBounds = true
    }
}
