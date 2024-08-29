//
//  RepositoryListScreen.swift
//  GithubUsers
//
//  Created by TokyoBits on 8/29/24.
//

import SwiftUI
import SwiftData

struct RepositoryListScreen: View {
    let user: User
    var body: some View {
        VStack {
            Image(user.userImage)
                .resizable()
                .scaledToFit()
            Text(user.name)
        }
        .navigationTitle("\(user.name) Repositories")
    }
}
