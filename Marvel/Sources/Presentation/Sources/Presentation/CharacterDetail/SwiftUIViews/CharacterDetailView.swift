//
//  CharacterDetailView.swift
//
//
//  Created by Diego Rogel on 23/7/22.
//

import SwiftUI

struct CharacterDetailView: View {
    private let viewModel: CharacterDetailViewModelProtocol

    @State var tasks = Set<Task<Void, Never>>()
    @State private var model: CharacterDetailModel?
    @State private var shouldShowError = false
    @State private var errorMessage: String? {
        didSet {
            shouldShowError = errorMessage != nil
        }
    }

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
        .errorRetryAlert(message: errorMessage, isPresented: $shouldShowError, retryAction: restart)
        .task(start)
        .onDisappear(perform: cancelTasks)
    }
}

extension CharacterDetailView: RestartableTaskHandler {
    @Sendable func start() async {
        await viewModel.start()
    }

    func restart() {
        let task = Task {
            await start()
        }
        tasks.insert(task)
    }
}

private extension CharacterDetailView {
    func handle(state: CharacterDetailViewModelState) {
        switch state {
        case let .success(characterDetailModel):
            model = characterDetailModel
        case let .failure(error):
            errorMessage = error.localizedDescription
        }
    }
}
