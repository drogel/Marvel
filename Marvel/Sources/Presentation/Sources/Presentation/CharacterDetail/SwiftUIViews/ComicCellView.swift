//
//  ComicCellView.swift
//
//
//  Created by Diego Rogel on 23/7/22.
//

import SwiftUI

struct ComicCellView: View {
    private let model: ComicCellModel

    init(model: ComicCellModel) {
        self.model = model
    }

    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(url: model.imageURL, scale: 2)
                .fixedSize()
                .frame(width: 210 / 1.544, height: 210, alignment: .center)
                .cellStyle(.small)
            VStack(spacing: 2) {
                Text(model.title)
                    .textStyle(.footnote)
                    .lineLimit(2)
                Text(model.issueNumber)
                    .textStyle(.caption)
            }
        }
        .frame(width: 210 / 1.544, alignment: .center)
    }
}
