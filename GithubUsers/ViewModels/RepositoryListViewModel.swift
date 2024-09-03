//
//  RepositoryListViewModel.swift
//  GithubUsers
//
//  Created by TokyoBits on 9/3/24.
//

import SwiftUI
import OSLog
import Observation

@Observable
class RepositoryListViewModel {
    let logger = Logger(subsystem: "jp.tokyobits.githubusers", category: "RepositoryListViewModel")

    let networkManager = NetworkManager.shared

    let username: String
    var repos: [Repository] = []
    var isLoading: Bool = true

    var alertItem: AlertItem?

    init(username: String) {
        self.username = username
    }

    func fetchRepositories() async {
        do {
            repos = try await networkManager.fetchRepositories(for: username)
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
