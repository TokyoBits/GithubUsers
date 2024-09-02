//
//  UserListScreen.swift
//  GithubUsers
//
//  Created by TokyoBits on 8/29/24.
//

import SwiftUI
import OSLog

struct UserListScreen: View {
    let logger = Logger(subsystem: "jp.tokyobits.githubusers", category: "UserListScreen")

    @State private var networkManager = NetworkManager.shared
    @State private var users: [User] = []

    @State private var isLoading: Bool = true
    @State private var usersPerPage: Int = 30

    @State private var userSince: Int = 0

    var body: some View {
        Group {
            if users.isEmpty && !isLoading {
                unavailableView
            } else {
                if isLoading {
                    initialLoadingView
                } else {
                    usersListView
                        .navigationDestination(for: User.self) { user in
                            UserDetailScreen(username: user.username)
                        }
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

    private var initialLoadingView: some View {
        ContentUnavailableView {
            Image(systemName: "person.crop.circle.dashed.circle")
                .font(.system(size: 40))
                .symbolEffect(.pulse)
                .foregroundStyle(.gray)
            Text("Loading Users")
                .font(.title2)
                .fontWeight(.semibold)
        } description: {
            Text("Please wait while data is loading.")
        } actions: {
            Button("Reload") {
                Task {
                    await fetchUsers()
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var usersListView: some View {
        List {
            Section {
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
                            Text("\(user.id)")
                        }
                        .listRowSeparator(.hidden)
                    }
                }
            } footer: {
                Button {
                    Task {
                        await fetchUsers()
                    }
                } label: {
                    Text("Load More Users")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .listStyle(.plain)
    }

    private func fetchUsers() async {
        do {
            logger.debug("Fetching users since \(userSince), perPage \(usersPerPage)")
            let fetchedUsers = try await networkManager.fetchUsers(since: userSince, perPage: usersPerPage)
            users.append(contentsOf: fetchedUsers)

            guard let lastId = users.last?.id else { return }
            logger.debug("Last user id: \(lastId)")
            userSince = lastId

            isLoading = false
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
