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
        VStack {
            AsyncImage(url: model.imageURL)
            Text(model.title)
            Text(model.issueNumber)
        }
        .cellStyle(.small)
    }
}
