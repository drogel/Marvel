//
//  CharacterDetailViewController.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import SwiftUI

public class CharacterDetailViewController: BaseHostingViewController {
    private let viewModel: CharacterDetailViewModelProtocol

    init(viewModel: CharacterDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("Initialization of \(String(describing: Self.self)) through coder not supported")
    }

    override func buildView() -> AnyView {
        AnyView(CharacterDetailView(viewModel: viewModel))
    }
}
