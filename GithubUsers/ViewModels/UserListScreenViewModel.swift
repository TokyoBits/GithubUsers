//
//  UserListScreenViewModel.swift
//  GithubUsers
//
//  Created by TokyoBits on 9/3/24.
//

import SwiftUI
import OSLog
import Observation
import SwiftData

@Observable
class UserListScreenViewModel {
    let logger = Logger(subsystem: "jp.tokyobits.githubusers", category: "UserListScreenViewModel")

    let modelContext: ModelContext
    let networkManager = NetworkManager.shared
    var users: [User] = []
    var isLoading: Bool = true

    private var usersPerPage: Int = 30
    private var userSince: Int = 0

    var usersFilterString: String = ""

    var alertItem: AlertItem?

    init(with container: ModelContainer) {
        self.modelContext = ModelContext(container)
        loadUsers()
    }

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

    func loadUsers() {
        do {
            let descriptor = FetchDescriptor<User>(sortBy: [SortDescriptor(\.id)])
            users = try modelContext.fetch(descriptor)

            guard users.count > 0 else {
                Task.detached {
                    await self.fetchUsers()
                }
                return
            }

            isLoading = false
        } catch {
            logger.error("Loading Users from SwiftData Failed")
        }
    }

    func fetchUsers() async {
        do {
            self.userSince = users.last?.id ?? 0
            logger.debug("Last user id: \(self.users.last?.id ?? 0)")
            logger.debug("Fetching users since \(self.userSince), perPage \(self.usersPerPage)")
            let fetchedUsers = try await networkManager.fetchUsers(since: userSince, perPage: usersPerPage)

            for user in fetchedUsers {
                modelContext.insert(user)
            }

            try? modelContext.save()
            loadUsers()
            isLoading = false
        } catch {
            switch error {
                case GithubAPIError.invalidURL:
                    alertItem = AlertContext.invalidURL
                case GithubAPIError.invalidResponse:
                    alertItem = AlertContext.invalidResponse
                case GithubAPIError.invalidData:
                    alertItem = AlertContext.invalidData
                case GithubAPIError.rateLimitExceeded:
                    alertItem = AlertContext.rateLimitExceeded
                default:
                    alertItem = AlertContext.invalidResponse
            }

            logger.error("\(error)")
        }
    }
}
