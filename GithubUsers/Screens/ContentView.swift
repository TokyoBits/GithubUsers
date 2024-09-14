//
//  ContentView.swift
//  GithubUsers
//
//  Created by TokyoBits on 8/29/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    var body: some View {
        NavigationStack {
            UserListScreen(container: modelContext.container)
        }
    }
}

#Preview {
    ContentView()
}
