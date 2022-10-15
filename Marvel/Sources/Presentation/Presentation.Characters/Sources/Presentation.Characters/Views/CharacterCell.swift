//
//  CharacterCell.swift
//
//
//  Created by Diego Rogel on 16/7/22.
//

import Presentation_Common
import SwiftUI

struct CharacterCell: View {
    private enum Constants {
        static let cellHeight: CGFloat = 310
    }

    private let model: CharacterCellModel

    init(model: CharacterCellModel) {
        self.model = model
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            FillAsyncImage(url: model.imageURL)
                .frame(height: Constants.cellHeight, alignment: .center)
            TextTile(shouldHideSubtitle: model.description.isEmpty) {
                Text(model.name)
            } subtitleViewBuilder: {
                Text(model.description)
            }
        }
        .cellStyle(.big)
        .listRowSeparator(.hidden)
        .padding(.vertical)
    }
}
