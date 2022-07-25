//
//  ComicCellView.swift
//
//
//  Created by Diego Rogel on 23/7/22.
//

import SwiftUI

struct ComicCell: View {
    private enum Constants {
        static let verticalSpacing: CGFloat = 8
        static let paperA4AspectRatio: CGFloat = 1.544
        static let comicImageHeight: CGFloat = 210
        static let cellWidth: CGFloat = comicImageHeight / paperA4AspectRatio
    }

    private let model: ComicCellModel

    init(model: ComicCellModel) {
        self.model = model
    }

    var body: some View {
        VStack(spacing: Constants.verticalSpacing) {
            FillAsyncImage(url: model.imageURL)
                .frame(width: Constants.cellWidth, height: Constants.comicImageHeight, alignment: .center)
                .cellStyle(.small)
            ComicCellInfoView(model: model)
        }
        .frame(width: Constants.cellWidth, alignment: .center)
    }
}
