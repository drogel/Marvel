//
//  CharacterDetailView.swift
//
//
//  Created by Diego Rogel on 23/7/22.
//

import Presentation_Common
import SwiftUI

struct CharacterDetailView: View {
    private enum Constants {
        static let characterImageHeight: CGFloat = 450
    }

    private let viewModel: CharacterDetailViewModelProtocol

    @State var tasks = Set<Task<Void, Never>>()
    @State private var shouldShowError = false
    @State private var model: CharacterDetailModel?
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
                    FillAsyncImage(url: model?.info?.image.imageURL)
                        .frame(width: geometry.size.width, height: Constants.characterImageHeight, alignment: .bottom)
                    if let descriptionModel = model?.info?.description {
                        CharacterInfoView(model: descriptionModel)
                    }
                    if let model = model {
                        ComicsCarousel(cellModels: model.comics, cellDidAppear: comicDidAppear)
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

    func comicDidAppear(at indexPath: IndexPath) async {
        await viewModel.willDisplayComicCell(at: indexPath)
    }
}
