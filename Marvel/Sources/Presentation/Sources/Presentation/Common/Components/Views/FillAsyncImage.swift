//
//  FillAsyncImage.swift
//
//
//  Created by Diego Rogel on 24/7/22.
//

import SwiftUI

struct FillAsyncImage: View {
    private enum Constants {
        static var defaultTransition: AnyTransition {
            .opacity.animation(.easeInOut(duration: 0.25))
        }

        static let placeholderColor = Color(UIColor.systemGroupedBackground)
    }

    private let url: URL?
    private let transition: AnyTransition

    init(url: URL?, transition: AnyTransition = Constants.defaultTransition) {
        self.url = url
        self.transition = transition
    }

    var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .scaledToFill()
                .transition(transition)
        } placeholder: {
            Rectangle()
                .foregroundColor(Constants.placeholderColor)
                .transition(transition)
        }
    }
}
