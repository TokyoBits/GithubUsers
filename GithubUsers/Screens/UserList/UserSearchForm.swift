//
//  UserSearchForm.swift
//  GithubUsers
//
//  Created by TokyoBits on 9/3/24.
//

import SwiftUI
import OSLog

struct UserSearchForm: View {
    let logger = Logger(subsystem: "jp.tokyobits.githubusers", category: "UserSearchForm")

    @State private var networkManager = NetworkManager.shared
    @State private var username: String = ""
    @State private var fetchedUser: User?

    @State private var hasSearched: Bool = false

    var body: some View {
        ScrollView {
            HStack {
                TextField("Username", text: $username)
                    .onChange(of: username) {
                        hasSearched = false
                    }
                    .onSubmit {
                        Task {
                            await fetchUser(username: username)
                        }
                    }
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)
                Button {
                    Task {
                        await fetchUser(username: username)
                    }
                } label: {
                    Text("Search")
                }
                .buttonStyle(.borderedProminent)
            }

            if let fetchedUser {
                NavigationLink(value: fetchedUser) {
                    UserRowView(username: fetchedUser.username, imageURL: fetchedUser.userImage)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            if hasSearched && fetchedUser == nil {
                Text("User not found: **\(username)** \nTry again")
                    .multilineTextAlignment(.center)
            }
        }
    }

    private func fetchUser(username: String) async {
        do {
            logger.debug("Searching for: \(username)")
            fetchedUser = try await networkManager.fetchUser(username: username)
        } catch {
            fetchedUser = nil
            hasSearched = true
            print(error)
        }
    }
}

#Preview {
    UserSearchForm()
}
