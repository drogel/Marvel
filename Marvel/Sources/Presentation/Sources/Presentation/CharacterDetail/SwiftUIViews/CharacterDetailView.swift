//
//  CharacterDetailView.swift
//
//
//  Created by Diego Rogel on 23/7/22.
//

import SwiftUI

struct CharacterDetailView: View {
    private let viewModel: CharacterDetailViewModelProtocol

    @State private var model: CharacterDetailModel?

    init(viewModel: CharacterDetailViewModelProtocol) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: model?.info?.image.imageURL, scale: 1.6)
                    .frame(height: 450, alignment: .center)
            }
        }
        .onReceive(viewModel.detailStatePublisher.receive(on: RunLoop.main), perform: handle(state:))
        .task(start)
    }
}

private extension CharacterDetailView {
    @Sendable func start() async {
        await viewModel.start()
    }

    func handle(state: CharacterDetailViewModelState) {
        switch state {
        case let .success(characterDetailModel):
            model = characterDetailModel
        case .failure:
            // TODO: Handle failure
            return
        }
    }
}
