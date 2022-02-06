//
//  CollectionSectionHeader.swift
//  Marvel
//
//  Created by Diego Rogel on 6/2/22.
//

import Foundation
import UIKit

class CollectionSectionHeader: UICollectionReusableView {
    private enum Constants {
        enum Title {
            static let fontSize: CGFloat = 18
            static let inset: CGFloat = 7
            static let maxLines = 0
        }
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constants.Title.fontSize)
        label.numberOfLines = Constants.Title.maxLines
        label.translatesAutoresizingMaskIntoConstraints = false
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

extension CollectionSectionHeader: Configurable {
    typealias Item = String

    func configure(using item: String) {
        titleLabel.text = item
    }
}

private extension CollectionSectionHeader {
    func setUp() {
        setUpSubviews()
        setUpConstraints()
    }

    func setUpSubviews() {
        addSubview(titleLabel)
    }

    func setUpConstraints() {
        NSLayoutConstraint.fit(titleLabel, in: self, inset: Constants.Title.inset)
    }
}
