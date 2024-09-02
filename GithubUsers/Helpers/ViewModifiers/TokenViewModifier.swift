//
//  TokenViewModifier.swift
//  GithubUsers
//
//  Created by TokyoBits on 9/2/24.
//

import SwiftUI

struct TokenViewModifier: ViewModifier {
    let backgroundColor: Color
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .font(.caption)
            .foregroundStyle(.white)
            .background(backgroundColor)
            .clipShape(.capsule)
    }
}

extension View {
    public func tokenized(backgroundColor: Color = Color.blue.opacity(0.8)) -> some View {
        modifier(TokenViewModifier(backgroundColor: backgroundColor))
    }
}
