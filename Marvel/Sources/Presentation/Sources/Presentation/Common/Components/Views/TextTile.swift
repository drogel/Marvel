//
//  TextTile.swift
//
//
//  Created by Diego Rogel on 23/7/22.
//

import SwiftUI

struct TextTile: View {
    private let shouldHideSubtitle: Bool
    private let titleViewBuilder: () -> Text
    private let subtitleViewBuilder: () -> Text

    init(
        shouldHideSubtitle: Bool = false,
        @ViewBuilder titleViewBuilder: @escaping () -> Text,
        @ViewBuilder subtitleViewBuilder: @escaping () -> Text
    ) {
        self.shouldHideSubtitle = shouldHideSubtitle
        self.titleViewBuilder = titleViewBuilder
        self.subtitleViewBuilder = subtitleViewBuilder
    }

    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .foregroundColor(Color(UIColor.systemBackground))
                .opacity(0.93)
            VStack(alignment: .leading, spacing: -24) {
                titleViewBuilder()
                    .textStyle(.title)
                if !shouldHideSubtitle {
                    subtitleViewBuilder()
                        .textStyle(.subtitle)
                        .lineLimit(2)
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}
