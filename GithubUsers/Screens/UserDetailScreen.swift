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
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                AsyncImage(url: URL(string: user?.userImage ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipShape(.circle)
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(.circle)
                }
            }
            .frame(maxWidth: .infinity)
            Group {
                Text(user?.username ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(user?.fullName ?? "")
                    .font(.title)
                Text(user?.bio ?? "")
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
            }
            HStack {
                if let company = user?.company {
                    Label(company, systemImage: "building.fill")
                }
                Spacer()
                if let location = user?.location {
                    Label(location, systemImage: "mappin.and.ellipse")
                }
            }
            .padding()
            .font(.caption)
            HStack(spacing: 2) {
                Image(systemName: "person.2.fill")
                Text("\(user?.followersCount ?? 0)")
                    .bold()
                Text("followers")
                Text("~")
                Text("\(user?.followingCount ?? 0)")
                    .bold()
                Text("following")
            }
            .frame(maxWidth: .infinity)
            .font(.caption)
        }
        .padding()
        .background(.gray.opacity(0.3))
        .clipShape(.rect(cornerRadius: 15))
        .padding()
        ScrollView {
            Section("Repositories") {
                RepositoryListView(username: username)
            }

        }
        .task {
            do {
                let userDetails = try await networkManager.fetchUserDetails(for: username)
                user = userDetails
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    NavigationStack {
        UserDetailScreen(username: "macournoyer")
    }
}
