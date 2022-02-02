//
//  CharacterImageCell.swift
//  Marvel
//
//  Created by Diego Rogel on 2/2/22.
//

import Foundation
import UIKit

class CharacterImageCell: UICollectionViewCell {
    private lazy var characterImageView = CharacterImageView()

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

private extension CharacterImageCell {
    func setUp() {
        setUpSubviews()
        setUpConstraints()
    }

    func setUpSubviews() {
        contentView.addSubview(characterImageView)
    }

    func setUpConstraints() {
        NSLayoutConstraint.activate([
            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            characterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            characterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
