//
//  CircularImageModifier.swift
//  GithubUsers
//
//  Created by TokyoBits on 9/2/24.
//

import SwiftUI

struct CircularImageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(Circle().stroke(.white.gradient, lineWidth: 4))
            .clipShape(.circle)
            .shadow(color: .gray.opacity(0.8), radius: 5, x: 0, y: 5)
    }
}

extension View {
    public func circularImage() -> some View {
        modifier(CircularImageModifier())
    }
}
