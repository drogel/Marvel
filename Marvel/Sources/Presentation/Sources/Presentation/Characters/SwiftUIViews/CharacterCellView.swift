//
//  SwiftUIView.swift
//
//
//  Created by Diego Rogel on 16/7/22.
//

import SwiftUI

struct CharacterCellView: UIViewRepresentable {
    typealias UIViewType = CharacterCell

    @Binding private var model: CharacterCellModel

    init(model: Binding<CharacterCellModel>) {
        _model = model
    }

    func makeUIView(context _: Context) -> CharacterCell {
        CharacterCell(frame: .zero)
    }

    func updateUIView(_ uiView: CharacterCell, context _: Context) {
        uiView.configure(using: model)
    }
}
