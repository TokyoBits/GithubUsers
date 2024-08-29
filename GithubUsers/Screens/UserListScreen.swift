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
            Text(user.name)
        }
        .task {
            do {
                users = try await networkManager.fetchUsers()
            } catch {
                print(error)
            }
        }
        .navigationBarTitle("Users")
    }
}

#Preview {
    NavigationStack {
        UserListScreen()
    }
}
