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

    @Environment(\.dismiss) var dismiss

    @State private var networkManager = NetworkManager.shared
    @State private var username: String = ""
    @State private var fetchedUser: User?

    @State private var hasSearched: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                HStack {
                    TextField("Username", text: $username)
                        .onChange(of: username) { newValue in
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
                .padding()
                .navigationBarTitle("Search for GitHub User")
                .navigationBarTitleDisplayMode(.inline)

                if let fetchedUser {
                    NavigationLink(value: fetchedUser) {
                        HStack {
                            AsyncImage(url: URL(string: fetchedUser.userImage)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .circularImage()
                            } placeholder: {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .circularImage()
                            }
                            Text(fetchedUser.username)
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                    }
                }
                if hasSearched && fetchedUser == nil {
                    Text("User not found: **\(username)** \nTry again")
                        .multilineTextAlignment(.center)
                }
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
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
