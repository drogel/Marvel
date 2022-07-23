//
//  CharactersView.swift
//
//
//  Created by Diego Rogel on 16/7/22.
//

import Combine
import SwiftUI

struct CharactersView: View {
    private let viewModel: CharactersViewModelProtocol

    @State private var isLoading: Bool = false
    @State private var cellModels: [CharacterCellModel] = []

    init(viewModel: CharactersViewModelProtocol) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            ViewSwitcher(shouldShowFirstView: $isLoading) {
                ProgressView()
            } secondViewBuilder: {
                CharactersList(cellModels: $cellModels)
            }
            .navigationBarTitle("characters".localized, displayMode: .large)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onReceive(viewModel.loadingStatePublisher, perform: handle(loadingState:))
        .onReceive(viewModel.statePublisher, perform: handle(viewModelState:))
        .task {
            await viewModel.start()
        }
    }
}

private extension CharactersView {
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
