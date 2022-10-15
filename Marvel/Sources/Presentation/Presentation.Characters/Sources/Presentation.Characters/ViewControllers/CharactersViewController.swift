//
//  CharactersViewController.swift
//
//
//  Created by Diego Rogel on 23/7/22.
//

import Presentation_Common
import SwiftUI

public final class CharactersViewController: BaseHostingViewController {
    private let viewModel: CharactersViewModelProtocol

    init(viewModel: CharactersViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("Initialization of \(String(describing: Self.self)) through coder not supported")
    }

    override public func buildView() -> AnyView {
        AnyView(CharactersView(viewModel: viewModel))
    }
}
