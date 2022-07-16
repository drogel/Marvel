//
//  CharacterImageView.swift
//  Marvel
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation
import UIKit

class FillImageView: FetchImageView {
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

private extension FillImageView {
    func setUp() {
        contentMode = .scaleAspectFill
        backgroundColor = .tertiarySystemGroupedBackground
        translatesAutoresizingMaskIntoConstraints = false
    }
}
