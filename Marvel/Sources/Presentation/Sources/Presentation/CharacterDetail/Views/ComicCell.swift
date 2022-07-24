//
//  ComicCellView.swift
//
//
//  Created by Diego Rogel on 23/7/22.
//

import SwiftUI

struct ComicCell: View {
    private enum Constants {
        static let paperA4AspectRatio: CGFloat = 1.544
        static let comicImageHeight: CGFloat = 210
        static let cellWidth: CGFloat = comicImageHeight / paperA4AspectRatio
    }

    private let model: ComicCellModel

    init(model: ComicCellModel) {
        self.model = model
    }

    var body: some View {
        VStack(spacing: 8) {
            FillAsyncImage(url: model.imageURL)
                .frame(width: Constants.cellWidth, height: Constants.comicImageHeight, alignment: .center)
                .cellStyle(.small)
            VStack(spacing: 2) {
                Text(model.title)
                    .textStyle(.footnote)
                    .lineLimit(2)
                Text(model.issueNumber)
                    .textStyle(.caption)
            }
        }
        .frame(width: Constants.cellWidth, alignment: .center)
    }
}
