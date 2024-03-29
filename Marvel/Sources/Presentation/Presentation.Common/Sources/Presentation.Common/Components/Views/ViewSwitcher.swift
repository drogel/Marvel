//
//  ViewSwitcher.swift
//
//
//  Created by Diego Rogel on 23/7/22.
//

import SwiftUI

public struct ViewSwitcher<FirstView: View, SecondView: View>: View {
    public enum Constants {
        public static var defaultTransition: AnyTransition {
            .opacity.animation(.easeInOut(duration: 0.35))
        }
    }

    private let firstViewBuilder: () -> FirstView
    private let secondViewBuilder: () -> SecondView
    private let transition: AnyTransition
    @Binding private var shouldShowFirstView: Bool

    public init(
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

    public var body: some View {
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
