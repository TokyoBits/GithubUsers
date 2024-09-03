//
//  UserListScreen.swift
//  GithubUsers
//
//  Created by TokyoBits on 8/29/24.
//

import SwiftUI

struct UserListScreen: View {
    @State private var viewModel = UserListScreenViewModel()

    var body: some View {
        Group {
            if viewModel.users.isEmpty && !viewModel.isLoading {
                unavailableView
            } else {
                if viewModel.isLoading {
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
            if viewModel.isLoading {
                await viewModel.fetchUsers()
            }
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
                    await viewModel.fetchUsers()
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
                    await viewModel.fetchUsers()
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var usersListView: some View {
        List {
            Section {
                ForEach(viewModel.filteredUsers) { user in
                    NavigationLink(value: user) {
                        UserRowView(username: user.username, imageURL: user.userImage)
                    }
                    .listRowSeparator(.hidden)
                }
            } header: {
                HStack {
                    Text("Fetched Users (\(viewModel.users.count))")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button {
                        Task {
                            await viewModel.fetchUsers()
                        }
                    } label: {
                        Text("Load More")
                            .font(.caption)
                    }
                }
            } footer: {
                UserSearchForm()
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .searchable(text: $viewModel.usersFilterString, prompt: "Filter Users")
    }
}

#Preview {
    NavigationStack {
        UserListScreen()
    }
}
