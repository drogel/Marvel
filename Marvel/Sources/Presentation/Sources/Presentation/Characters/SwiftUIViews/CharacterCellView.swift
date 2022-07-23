//
//  CharacterCellView.swift
//
//
//  Created by Diego Rogel on 16/7/22.
//

import SwiftUI

struct CharacterCellView: View {
    @Binding private var model: CharacterCellModel

    init(model: Binding<CharacterCellModel>) {
        _model = model
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: model.imageURL)
                .frame(width: 0, height: 300, alignment: .center)
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
