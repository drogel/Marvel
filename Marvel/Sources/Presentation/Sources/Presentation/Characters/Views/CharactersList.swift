//
//  CharactersList.swift
//
//
//  Created by Diego Rogel on 23/7/22.
//

import SwiftUI

struct CharactersList: View {
    @Binding private var cellModels: [CharacterCellModel]
    private let didTapCell: ((IndexPath) -> Void)?
    private let cellDidAppear: ((IndexPath) async -> Void)?

    init(
        cellModels: Binding<[CharacterCellModel]>,
        didTapCell: ((IndexPath) -> Void)? = nil,
        cellDidAppear: ((IndexPath) async -> Void)? = nil
    ) {
        _cellModels = cellModels
        self.didTapCell = didTapCell
        self.cellDidAppear = cellDidAppear
    }

    var body: some View {
        List($cellModels, id: \.identifier) { modelBinding in
            let model = modelBinding.wrappedValue
            CharacterCell(model: model)
                .listRowSeparator(.hidden)
                .padding(.bottom)
                .onTapGesture {
                    didTapCell(with: model)
                }
                .task {
                    await cellDidAppear(with: model)
                }
        }
        .listStyle(.plain)
    }
}

private extension CharactersList {
    func didTapCell(with model: CharacterCellModel) {
        guard let indexPath = indexPathOf(model: model) else { return }
        didTapCell?(indexPath)
    }

    func cellDidAppear(with model: CharacterCellModel) async {
        guard let indexPath = indexPathOf(model: model) else { return }
        await cellDidAppear?(indexPath)
    }

    func indexPathOf(model: CharacterCellModel) -> IndexPath? {
        guard let row = cellModels.firstIndex(of: model) else { return nil }
        return IndexPath(row: row, section: 0)
    }
}
