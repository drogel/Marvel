//
//  CharactersList.swift
//
//
//  Created by Diego Rogel on 23/7/22.
//

import SwiftUI

struct CharactersList: View {
    @Binding private var cellModels: [CharacterCellModel]

    init(cellModels: Binding<[CharacterCellModel]>) {
        _cellModels = cellModels
    }

    var body: some View {
        List {
            ForEach($cellModels, id: \.identifier) { model in
                CharacterCellView(model: model)
                    .listRowSeparator(.hidden)
                    .padding(.bottom)
            }
        }
        .listStyle(.plain)
    }
}
