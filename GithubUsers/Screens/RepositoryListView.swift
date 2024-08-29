//
//  RepositoryListScreen.swift
//  GithubUsers
//
//  Created by TokyoBits on 8/29/24.
//

import SwiftUI
import SwiftData

struct RepositoryListView: View {
    let username: String
    @State private var networkManager = NetworkManager.shared
    @State private var repos: [Repository] = []

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(repos) { repository in
                    Text(repository.name)
                }
            }
        }
        .task {
            do {
                repos = try await networkManager.fetchRepositories(for: username)
            } catch {
                print(error)
            }
        }
    }
}
