//
//  UserDetailScreen.swift
//  GithubUsers
//
//  Created by TokyoBits on 8/29/24.
//

import SwiftUI

struct UserDetailScreen: View {
    @State private var networkManager = NetworkManager.shared
    var username: String
    @State private var user: User?

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: user?.userImage ?? "")) { image in
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
            Text(user?.fullName ?? "full")
            Text(user?.bio ?? "bio")
            Text("Company: \(user?.company ?? "company") ")
            Text(user?.location ?? "location")
            Text("\(user?.followersCount ?? 0) followers")
            Text("\(user?.followingCount ?? 0) following")

            RepositoryListView(username: username)
        }
        .task {
            do {
                let userDetails = try await networkManager.fetchUserDetails(for: username)
                user = userDetails
            } catch {
                print(error)
            }
        }
        .navigationTitle(username)
    }
}

#Preview {
    NavigationStack {
        UserDetailScreen(username: "macournoyer")
    }
}
