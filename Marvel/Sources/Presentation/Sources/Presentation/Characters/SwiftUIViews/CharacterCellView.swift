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
            ZStack {
                Rectangle()
                    .foregroundColor(.white)
                    .opacity(0.93)
                VStack(alignment: .leading, spacing: -24) {
                    Text(model.name)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if !model.description.isEmpty {
                        Text(model.description)
                            .multilineTextAlignment(.leading)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .lineLimit(2)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
        }
        .cellStyle(.big)
    }
}
