//
//  UserDetailScreen.swift
//  GithubUsers
//
//  Created by TokyoBits on 8/29/24.
//

import SwiftUI

struct UserDetailScreen: View {
    @State private var viewModel: UserDetailViewModel
    @State private var selectedLink: WebViewLink?

    init(username: String  = "") {
        self.viewModel = UserDetailViewModel(username: username)
    }

    var body: some View {
        userHeader
        RepositoryListView(username: viewModel.username)
        .task {
            await viewModel.fetchUserDetails()
        }
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
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
        AsyncImage(url: URL(string: viewModel.user?.userImage ?? "")) { image in
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
            Text(viewModel.user?.username ?? "")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(viewModel.user?.fullName ?? "")
                .font(.title)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
    }

    @ViewBuilder
    private var userBioView: some View {
        if let bio = viewModel.user?.bio {
            Text(bio)
                .padding(.top)
        }
    }

    @ViewBuilder
    private var userExtrasView: some View {
        HStack {
            if let company = viewModel.user?.company {
                Label(company, systemImage: "building.fill")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            if let location = viewModel.user?.location {
                Label(location, systemImage: "mappin.and.ellipse")
            }
        }
        .padding()

        HStack(spacing: 2) {
            Image(systemName: "person.2.fill")
            Text("\(viewModel.user?.followersCount ?? 0)")
                .bold()
            Text("followers")
            Text("~")
            Text("\(viewModel.user?.followingCount ?? 0)")
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
