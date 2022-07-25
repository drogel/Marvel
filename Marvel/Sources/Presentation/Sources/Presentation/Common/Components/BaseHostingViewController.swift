//
//  BaseHostingViewController.swift
//
//
//  Created by Diego Rogel on 23/7/22.
//

import SwiftUI
import UIKit

public class BaseHostingViewController: UIViewController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    func buildView() -> AnyView {
        AnyView(EmptyView())
    }
}

private extension BaseHostingViewController {
    func setUp() {
        let hostingViewController = UIHostingController(rootView: buildView())
        addChild(hostingViewController)
        view.addSubview(hostingViewController.view)
        NSLayoutConstraint.fit(hostingViewController.view, in: view)
    }
}
