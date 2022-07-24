//
//  CharacterInfoView.swift
//
//
//  Created by Diego Rogel on 24/7/22.
//

import SwiftUI

struct CharacterInfoView: View {
    private var model: CharacterDescriptionModel

    init(model: CharacterDescriptionModel) {
        self.model = model
    }

    var body: some View {
        VStack(alignment: .leading, spacing: -24) {
            Text(model.name)
                .textStyle(.header)
            if !model.description.isEmpty {
                Text(model.description)
                    .textStyle(.subtitle)
            }
        }
    }
}
