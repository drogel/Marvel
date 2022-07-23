//
//  ViewSwitcher.swift
//
//
//  Created by Diego Rogel on 23/7/22.
//

import SwiftUI

struct ViewSwitcher<FirstView: View, SecondView: View>: View {
    private enum Constants {
        static var defaultTransition: AnyTransition {
            .opacity.animation(.easeInOut(duration: 0.25))
        }
    }

    private let firstViewBuilder: () -> FirstView
    private let secondViewBuilder: () -> SecondView
    private let transition: AnyTransition
    @Binding private var shouldShowFirstView: Bool

    init(
        shouldShowFirstView: Binding<Bool>,
        transition: AnyTransition = Constants.defaultTransition,
        @ViewBuilder firstViewBuilder: @escaping () -> FirstView,
        @ViewBuilder secondViewBuilder: @escaping () -> SecondView
    ) {
        _shouldShowFirstView = shouldShowFirstView
        self.firstViewBuilder = firstViewBuilder
        self.secondViewBuilder = secondViewBuilder
        self.transition = transition
    }

    var body: some View {
        ZStack {
            if shouldShowFirstView {
                firstViewBuilder()
                    .transition(transition)
            } else {
                secondViewBuilder()
                    .transition(transition)
            }
        }
    }
}
