//
//  UserDetailScreen.swift
//  GithubUsers
//
//  Created by TokyoBits on 8/29/24.
//

import SwiftUI

struct UserDetailScreen: View {
    let user: User

    var body: some View {
        VStack {
            Image(user.userImage)
                .resizable()
                .scaledToFit()
            Text(user.name)

            RepositoryListView(username: user.name)
        }
        .navigationTitle(user.name)
    }
}
