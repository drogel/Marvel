//
//  CharactersList.swift
//
//
//  Created by Diego Rogel on 16/7/22.
//

import Combine
import SwiftUI

struct CharactersList: View {
    private let viewModel: CharactersViewModelProtocol

    @State private var isLoading: Bool = false
    @State private var cellModels: [CharacterCellModel] = []

    init(viewModel: CharactersViewModelProtocol) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            ZStack {
                if isLoading {
                    ProgressView()
                }
                List {
                    ForEach($cellModels, id: \.identifier) { model in
                        CharacterCellView(model: model)
                            .frame(width: nil, height: 300, alignment: .center)
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
            }
            .onReceive(viewModel.loadingStatePublisher, perform: handle(loadingState:))
            .onReceive(viewModel.statePublisher, perform: handle(viewModelState:))
            .task {
                await viewModel.start()
            }
            .navigationBarTitle("characters".localized, displayMode: .large)
        }
    }
}

private extension CharactersList {
    func handle(loadingState: LoadingState) {
        isLoading = loadingState != .loaded
    }

    func handle(viewModelState state: CharactersViewModelState) {
        switch state {
        case let .success(models):
            cellModels = models
        case .failure:
            return
        }
    }
}
