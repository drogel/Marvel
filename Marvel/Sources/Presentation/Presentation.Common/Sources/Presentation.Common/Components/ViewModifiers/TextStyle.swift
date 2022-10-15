//
//  TextStyle.swift
//
//
//  Created by Diego Rogel on 23/7/22.
//

import SwiftUI

public enum TextStyle {
    case header
    case title
    case subtitle
    case footnote
    case caption
}

public extension Text {
    func textStyle(_ textStyle: TextStyle) -> some View {
        switch textStyle {
        case .header:
            return AnyView(modifier(HeaderStyle()))
        case .title:
            return AnyView(modifier(TitleStyle()))
        case .subtitle:
            return AnyView(modifier(SubtitleStyle()))
        case .footnote:
            return AnyView(modifier(FootnoteStyle()))
        case .caption:
            return AnyView(modifier(CaptionStyle()))
        }
    }
}

private struct HeaderStyle: TextModifier {
    func body(content: Text) -> some View {
        content
            .font(.system(size: 28, weight: .bold, design: .rounded))
            .lineLimit(1)
            .multilineTextAlignment(.leading)
            .font(.title)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct TitleStyle: TextModifier {
    func body(content: Text) -> some View {
        content
            .fontWeight(.semibold)
            .lineLimit(1)
            .multilineTextAlignment(.leading)
            .font(.system(size: 20, weight: .bold, design: .rounded))
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct SubtitleStyle: TextModifier {
    func body(content: Text) -> some View {
        content
            .multilineTextAlignment(.leading)
            .font(.system(size: 14, design: .rounded))
            .foregroundColor(Color(UIColor.systemGray))
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct FootnoteStyle: TextModifier {
    func body(content: Text) -> some View {
        content
            .multilineTextAlignment(.leading)
            .font(.system(size: 14, design: .rounded))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct CaptionStyle: TextModifier {
    func body(content: Text) -> some View {
        content
            .multilineTextAlignment(.leading)
            .font(.system(size: 10, design: .rounded))
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
