//
//  ComicsCarousel.swift
//
//
//  Created by Diego Rogel on 24/7/22.
//

import SwiftUI

struct ComicsCarousel: View {
    private let cellModels: [ComicCellModel]
    private let cellDidAppear: ((IndexPath) async -> Void)?

    init(cellModels: [ComicCellModel], cellDidAppear: ((IndexPath) async -> Void)?) {
        self.cellModels = cellModels
        self.cellDidAppear = cellDidAppear
    }

    var body: some View {
        VStack(spacing: 2) {
            Text("comics".localized)
                .textStyle(.title)
            HorizontalList(cellModels, id: \.identifier, spacing: 16) { comic in
                ComicCell(model: comic)
                    .task {
                        await cellDidAppear(with: comic)
                    }
            }
        }
    }
}

private extension ComicsCarousel {
    func cellDidAppear(with model: ComicCellModel) async {
        guard let indexPath = indexPathOf(model: model) else { return }
        await cellDidAppear?(indexPath)
    }

    func indexPathOf(model: ComicCellModel) -> IndexPath? {
        guard let row = cellModels.firstIndex(of: model) else { return nil }
        return IndexPath(row: row, section: 0)
    }
}
