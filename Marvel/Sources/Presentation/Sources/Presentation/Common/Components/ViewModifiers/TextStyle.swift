//
//  TextStyle.swift
//
//
//  Created by Diego Rogel on 23/7/22.
//

import SwiftUI

enum TextStyle {
    case title
    case subtitle
}

extension Text {
    func textStyle(_ textStyle: TextStyle) -> some View {
        switch textStyle {
        case .title:
            return AnyView(modifier(TitleStyle()))
        case .subtitle:
            return AnyView(modifier(SubtitleStyle()))
        }
    }
}

struct TitleStyle: TextModifier {
    func body(content: Text) -> some View {
        content
            .fontWeight(.bold)
            .lineLimit(1)
            .multilineTextAlignment(.leading)
            .font(.title2)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SubtitleStyle: TextModifier {
    func body(content: Text) -> some View {
        content
            .multilineTextAlignment(.leading)
            .font(.caption)
            .foregroundColor(.gray)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
