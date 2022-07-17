//
//  SwiftUIView.swift
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
            ZStack(alignment: .bottom) {
                Rectangle()
                    .foregroundColor(.white)
                    .opacity(0.93)
                VStack(alignment: .leading) {
                    Text(model.name)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                        .font(.title2)
                        .padding(.top)
                        .padding(.leading)
                        .padding(.bottom, model.description.isEmpty ? nil : 1)
                        .padding(.trailing)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if !model.description.isEmpty {
                        Text(model.description)
                            .multilineTextAlignment(.leading)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .lineLimit(2)
                            .padding(.leading)
                            .padding(.bottom)
                            .padding(.trailing)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 6)
    }
}
