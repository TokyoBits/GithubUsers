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
        userHeader
        RepositoryListView(username: username)
        .task {
            do {
                let userDetails = try await networkManager.fetchUserDetails(for: username)
                user = userDetails
            } catch {
                print(error)
            }
        }
    }

    private var userHeader: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                userImageView
                userNameView
            }
            userBioView
            userExtrasView
                .font(.caption)
        }
        .padding()
        .background(.background)
    }

    private var userImageView: some View {
        AsyncImage(url: URL(string: user?.userImage ?? "")) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .circularImage()
        } placeholder: {
            Image(systemName: "person.circle")
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .circularImage()
        }
    }

    private var userNameView: some View {
        VStack(alignment: .leading) {
            Text(user?.username ?? "")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(user?.fullName ?? "")
                .font(.title)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
    }

    @ViewBuilder
    private var userBioView: some View {
        if let bio = user?.bio {
            Text(bio)
                .padding(.top)
        }
    }

    @ViewBuilder
    private var userExtrasView: some View {
        HStack {
            if let company = user?.company {
                Label(company, systemImage: "building.fill")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            if let location = user?.location {
                Label(location, systemImage: "mappin.and.ellipse")
            }
        }
        .padding()

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
    }
}

#Preview {
    NavigationStack {
        UserDetailScreen(username: "twostraws")
    }
}
