//
//  UserSearchForm.swift
//  GithubUsers
//
//  Created by TokyoBits on 9/3/24.
//

import SwiftUI
import OSLog

struct UserSearchForm: View {
    @State private var viewModel = UserSearchFormViewModel()
    @FocusState var searchIsFocused: Bool
    var body: some View {
        Section {
            ScrollView {
                HStack {
                    TextField("Username", text: $viewModel.username)
                        .focused($searchIsFocused)
                        .onChange(of: viewModel.username) {
                            viewModel.hasSearched = false
                        }
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .textFieldStyle(.roundedBorder)
                    Button {
                        Task {
                            searchIsFocused = false
                            await viewModel.fetchUser(username: viewModel.username)
                        }
                    } label: {
                        Text("Search")
                    }
                    .buttonStyle(.borderedProminent)
                }

                if let fetchedUser = viewModel.fetchedUser {
                    NavigationLink(value: fetchedUser) {
                        UserRowView(username: fetchedUser.username, imageURL: fetchedUser.userImage)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                if viewModel.hasSearched && viewModel.fetchedUser == nil {
                    Text("User not found: **\(viewModel.username)** \nTry again")
                        .multilineTextAlignment(.center)
                }
            }
        } header: {
            HStack {
                Text("Find User")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button {
                    searchIsFocused = false
                    viewModel.resetSearch()
                } label: {
                    Text("Clear")
                        .font(.caption)
                }
            }
        }
    }
}

#Preview {
    UserSearchForm()
}
