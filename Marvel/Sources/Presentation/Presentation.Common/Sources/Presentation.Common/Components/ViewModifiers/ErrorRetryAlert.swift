//
//  RetryAlert.swift
//
//
//  Created by Diego Rogel on 23/7/22.
//

import SwiftUI

public extension View {
    func errorRetryAlert(
        message: String?,
        isPresented: Binding<Bool>,
        retryAction: (() -> Void)? = nil
    ) -> some View {
        modifier(ErrorRetryAlert(message: message, isPresented: isPresented, retryAction: retryAction))
    }
}

private struct ErrorRetryAlert: ViewModifier {
    @Binding private var isPresented: Bool
    private let message: String?
    private let retryAction: (() -> Void)?

    init(
        message: String?,
        isPresented: Binding<Bool>,
        retryAction: (() -> Void)? = nil
    ) {
        _isPresented = isPresented
        self.retryAction = retryAction
        self.message = message
    }

    func body(content: Content) -> some View {
        content
            .alert("error".localized, isPresented: $isPresented) {
                Button("retry".localized) { retryAction?() }
            } message: {
                if let message = message {
                    Text(message)
                }
            }
    }
}
