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
    let logger = Logger(subsystem: "jp.tokyobits.githubusers", category: "UserSearchFormViewModel")

    let networkManager = NetworkManager.shared
    var username: String = ""
    var fetchedUser: User?
    var hasSearched: Bool = false

    var alertItem: AlertItem?

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
            resetSearch()
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
