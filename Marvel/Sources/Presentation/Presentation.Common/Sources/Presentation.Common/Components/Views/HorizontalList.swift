//
//  HorizontalList.swift
//
//
//  Created by Diego Rogel on 24/7/22.
//

import SwiftUI

public struct HorizontalList<Data: RandomAccessCollection, ID: Hashable, Content: View>: View {
    private let data: Data
    private let id: KeyPath<Data.Element, ID>
    private let content: (Data.Element) -> Content
    private let showsIndicators: Bool
    private let alignment: VerticalAlignment
    private let spacing: CGFloat?
    private let pinnedViews: PinnedScrollableViews

    public init(
        _ data: Data,
        id: KeyPath<Data.Element, ID>,
        showsIndicators: Bool = false,
        alignment: VerticalAlignment = .center,
        spacing: CGFloat? = nil,
        pinnedViews: PinnedScrollableViews = .init(),
        content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.id = id
        self.content = content
        self.showsIndicators = showsIndicators
        self.alignment = alignment
        self.spacing = spacing
        self.pinnedViews = pinnedViews
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: showsIndicators) {
            LazyHStack(alignment: alignment, spacing: spacing, pinnedViews: pinnedViews) {
                ForEach(data, id: id, content: content)
            }
            .padding(.horizontal)
        }
    }
}
