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
    @State private var tasks = Set<Task<Void, Never>>()
    @State private var shouldShowAlert: Bool = false
    @State private var errorMessage: String? {
        didSet {
            shouldShowAlert = errorMessage != nil
        }
    }

    init(viewModel: CharactersViewModelProtocol) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            ViewSwitcher(shouldShowFirstView: $isLoading) {
                ProgressView()
            } secondViewBuilder: {
                CharactersList(cellModels: $cellModels, didTapCell: didTapCell, cellDidAppear: cellDidAppear)
            }
            .navigationBarTitle("characters".localized, displayMode: .large)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onReceive(viewModel.loadingStatePublisher, perform: handle(loadingState:))
        .onReceive(viewModel.statePublisher, perform: handle(viewModelState:))
        .errorRetryAlert(message: errorMessage, isPresented: $shouldShowAlert, retryAction: restart)
        .task(start)
        .onDisappear(perform: cancelTasks)
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
        case let .failure(error):
            errorMessage = error.localizedDescription
        }
    }

    func didTapCell(at indexPath: IndexPath) {
        viewModel.select(at: indexPath)
    }

    func cellDidAppear(at indexPath: IndexPath) async {
        await viewModel.willDisplayCell(at: indexPath)
    }

    func restart() {
        let task = Task {
            await start()
        }
        tasks.insert(task)
    }

    func cancelTasks() {
        tasks.forEach { $0.cancel() }
    }

    @Sendable func start() async {
        await viewModel.start()
    }
}
