//
//  CellStyle.swift
//
//
//  Created by Diego Rogel on 23/7/22.
//

import SwiftUI

public enum CellStyle {
    case small
    case big
}

public extension View {
    func cellStyle(_ cellStyle: CellStyle) -> some View {
        switch cellStyle {
        case .small:
            return AnyView(modifier(SmallCellStyle()))
        case .big:
            return AnyView(modifier(BigCellStyle()))
        }
    }
}

private struct SmallCellStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

private struct BigCellStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 6)
    }
}
