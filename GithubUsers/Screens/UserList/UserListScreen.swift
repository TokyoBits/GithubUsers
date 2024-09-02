//
//  UserListScreen.swift
//  GithubUsers
//
//  Created by TokyoBits on 8/29/24.
//

import SwiftUI

struct UserListScreen: View {
    @State private var networkManager = NetworkManager.shared
    @State private var users: [User] = []

    var body: some View {
        Group {
            if users.isEmpty {
                unavailableView
            } else {
                usersListView
                    .navigationDestination(for: User.self) { user in
                        UserDetailScreen(username: user.username)
                    }
                    .refreshable {
                        await fetchUsers()
                    }
            }
        }
        .task {
            await fetchUsers()
        }
        .navigationBarTitle("Users")
    }

    private var unavailableView: some View {
        ContentUnavailableView {
            Label("No Users", systemImage: "person.crop.circle.dashed")
        } description: {
            Text("Unable to display users list. Please try again later.")
        } actions: {
            Button("Try Again") {
                Task {
                    await fetchUsers()
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var usersListView: some View {
        List {
            ForEach(users) { user in
                NavigationLink(value: user) {
                    HStack {
                        AsyncImage(url: URL(string: user.userImage)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .circularImage()
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .circularImage()
                        }
                        Text(user.username)
                    }
                    .listRowSeparator(.hidden)
                }
            }
        }
        .listStyle(.plain)
    }

    private func fetchUsers() async {
        do {
            users = try await networkManager.fetchUsers()
        } catch {
            print(error)
        }
    }
}

#Preview {
    NavigationStack {
        UserListScreen()
    }
}
