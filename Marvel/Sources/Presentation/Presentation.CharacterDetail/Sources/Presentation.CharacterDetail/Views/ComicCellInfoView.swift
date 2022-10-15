//
//  ComicCellInfoView.swift
//
//
//  Created by Diego Rogel on 24/7/22.
//

import SwiftUI

struct ComicCellInfoView: View {
    private enum Constants {
        static let verticalSpacing: CGFloat = 2
    }

    private let model: ComicCellModel

    init(model: ComicCellModel) {
        self.model = model
    }

    var body: some View {
        VStack(spacing: Constants.verticalSpacing) {
            Text(model.title)
                .textStyle(.footnote)
                .lineLimit(2)
            Text(model.issueNumber)
                .textStyle(.caption)
        }
    }
}
