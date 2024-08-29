//
//  RepositoryListScreen.swift
//  GithubUsers
//
//  Created by TokyoBits on 8/29/24.
//

import SwiftUI
import SwiftData

struct RepositoryListScreen: View {
    let user: User

    @State private var networkManager = NetworkManager.shared
    @State private var repos: [Repository] = []

    var body: some View {
        VStack {
            Image(user.userImage)
                .resizable()
                .scaledToFit()
            Text(user.name)

            ScrollView(.horizontal) {
                HStack {
                    ForEach(repos) { repository in
                        Text(repository.name)
                    }
                }
            }
        }
        .navigationTitle("\(user.name) Repositories")
        .task {
            do {
                repos = try await networkManager.fetchRepositories(for: user.name)
            } catch {
                print(error)
            }
        }
    }
}
