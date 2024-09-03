//
//  UserDetailViewModel.swift
//  GithubUsers
//
//  Created by TokyoBits on 9/3/24.
//

import SwiftUI
import OSLog
import Observation

@Observable
class UserDetailViewModel {
    let logger = Logger(subsystem: "jp.tokyobits.githubusers", category: "UserDetailViewModel")

    let networkManager = NetworkManager.shared
    var username: String
    var user: User?

    var alertItem: AlertItem?

    init(username: String) {
        self.username = username
    }

    func fetchUserDetails() async {
        do {
            user = try await networkManager.fetchUserDetails(for: username)
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
