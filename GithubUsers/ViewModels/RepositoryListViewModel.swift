//
//  RepositoryListViewModel.swift
//  GithubUsers
//
//  Created by TokyoBits on 9/3/24.
//

import SwiftUI
import OSLog
import Observation
import SwiftData

@Observable
class RepositoryListViewModel {
    let logger = Logger(subsystem: "jp.tokyobits.githubusers", category: "RepositoryListViewModel")

    let networkManager = NetworkManager.shared

    let modelContext: ModelContext

    let username: String
    var repos: [Repository] = []
    var isLoading: Bool = true

    var alertItem: AlertItem?

    init(with container: ModelContainer, username: String) {
        self.modelContext = ModelContext(container)
        self.username = username
//        loadRepositories()
    }

    func loadRepositories() {
        do {
            let descriptor = FetchDescriptor<Repository>(predicate: #Predicate { repo in
                repo.owner == username
            }, sortBy: [SortDescriptor(\.lastUpdated, order: .reverse)])

            repos = try modelContext.fetch(descriptor)

            guard repos.count > 0 || !isLoading else {
                Task.detached {
                    await self.fetchRepositories()
                }
                return
            }

            isLoading = false
        } catch {
            logger.error("Loading Repositories from SwiftData Failed")
        }
    }

    func fetchRepositories() async {
        do {
            repos = try await networkManager.fetchRepositories(for: username)
            for repo in repos {
                modelContext.insert(repo)
            }

            try? modelContext.save()
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
