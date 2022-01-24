//
//  CharacterImageView.swift
//  Marvel
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation
import UIKit

class CharacterImageView: FetchImageView {

    override init(image: UIImage? = nil) {
        super.init(image: image)
        setUp()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
}

private extension CharacterImageView {

    func setUp() {
        contentMode = .scaleAspectFill
        backgroundColor = .tertiarySystemGroupedBackground
        translatesAutoresizingMaskIntoConstraints = false
    }
}
