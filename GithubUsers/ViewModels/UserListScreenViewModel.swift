//
//  UserListScreenViewModel.swift
//  GithubUsers
//
//  Created by TokyoBits on 9/3/24.
//

import SwiftUI
import OSLog
import Observation

@Observable
class UserListScreenViewModel {
    let logger = Logger(subsystem: "jp.tokyobits.githubusers", category: "UserListScreenManager")

    let networkManager = NetworkManager.shared
    var users: [User] = []
    var isLoading: Bool = true

    private var usersPerPage: Int = 30
    private var userSince: Int = 0

    var usersFilterString: String = ""

    private func filteredUsers(
        users: [User],
        searchText: String
    ) -> [User] {
        guard !searchText.isEmpty else { return users }
        return users.filter { user in
            user.username.lowercased().contains(searchText.lowercased()) ||
            ((user.fullName?.lowercased().contains(searchText.lowercased())) != nil)
        }
    }

    var filteredUsers: [User] {
        filteredUsers(users: users, searchText: usersFilterString)
    }

    func fetchUsers() async {
        do {
            logger.debug("Fetching users since \(self.userSince), perPage \(self.usersPerPage)")
            let fetchedUsers = try await networkManager.fetchUsers(since: userSince, perPage: usersPerPage)
            users.append(contentsOf: fetchedUsers)

            guard let lastId = users.last?.id else { return }
            logger.debug("Last user id: \(lastId)")
            userSince = lastId

            isLoading = false
        } catch {
            print(error)
        }
    }
}
