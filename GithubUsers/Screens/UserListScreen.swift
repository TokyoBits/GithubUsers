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
        List(users) { user in
            NavigationLink(value: user) {
                HStack {
                    AsyncImage(url: URL(string: user.userImage)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(.circle)
                    } placeholder: {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(.circle)
                    }
                    Text(user.name)
                }
            }
        }
        .task {
            do {
                users = try await networkManager.fetchUsers()
            } catch {
                print(error)
            }
        }
        .navigationDestination(for: User.self, destination: { user in
            UserDetailScreen(user: user)
        })
        .navigationBarTitle("Users")
    }
}

#Preview {
    NavigationStack {
        UserListScreen()
    }
}
