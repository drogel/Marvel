//
//  Text+Modifier.swift
//
//
//  Created by Diego Rogel on 23/7/22.
//

import SwiftUI

protocol TextModifier {
    associatedtype Body: View

    func body(content: Text) -> Self.Body
}

extension Text {
    func modifier<M>(_ modifier: M) -> some View where M: TextModifier {
        modifier.body(content: self)
    }
}
