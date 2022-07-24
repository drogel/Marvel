//
//  CharacterCell.swift
//
//
//  Created by Diego Rogel on 16/7/22.
//

import SwiftUI

struct CharacterCell: View {
    private let model: CharacterCellModel

    init(model: CharacterCellModel) {
        self.model = model
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: model.imageURL, scale: 1.2)
                .frame(width: 0, height: 310, alignment: .center)
            Tile(shouldHideSubtitle: model.description.isEmpty) {
                Text(model.name)
            } subtitleViewBuilder: {
                Text(model.description)
            }
            .fixedSize(horizontal: false, vertical: true)
        }
        .cellStyle(.big)
    }
}
