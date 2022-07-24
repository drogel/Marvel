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
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    AsyncImage(url: model?.info?.image.imageURL, scale: 1.6)
                        .frame(width: geometry.size.width, alignment: .center)
                    VStack(alignment: .leading, spacing: -24) {
                        Text(model?.info?.description.name ?? "")
                            .textStyle(.header)
                        Text(model?.info?.description.description ?? "")
                            .textStyle(.subtitle)
                        if let model = model {
                            VStack(spacing: 2) {
                                Text("comics".localized)
                                    .textStyle(.title)
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack(spacing: 16) {
                                        ForEach(model.comics, id: \.identifier) { comic in
                                            ComicCellView(model: comic)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.vertical)
                        }
                    }
                }
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
