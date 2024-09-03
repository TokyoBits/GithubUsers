//
//  UserSearchFormViewModel.swift
//  GithubUsers
//
//  Created by TokyoBits on 9/3/24.
//

import SwiftUI
import OSLog
import Observation

@Observable
class UserSearchFormViewModel {
    let logger = Logger(subsystem: "jp.tokyobits.githubusers", category: "UserListScreenManager")

    let networkManager = NetworkManager.shared
    var username: String = ""
    var fetchedUser: User?
    var hasSearched: Bool = false

    func resetSearch() {
        username = ""
        fetchedUser = nil
        hasSearched = false
    }

    func fetchUser(username: String) async {
        do {
            logger.debug("Searching for: \(username)")
            fetchedUser = try await networkManager.fetchUser(username: username)
        } catch {
            fetchedUser = nil
            hasSearched = true
            print(error)
        }
    }
}
