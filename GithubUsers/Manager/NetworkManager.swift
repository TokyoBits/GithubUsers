//
//  NetworkManager.swift
//  GithubUsers
//
//  Created by TokyoBits on 8/29/24.
//

import SwiftUI

final class NetworkManager {
    static let shared = NetworkManager()

    private let baseURL: String = "https://api.github.com/"

    private init() {}

    func customRequest(endpoint: String) -> URLRequest {
        let url = URL(string: baseURL.appending(endpoint))!
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")

        // To prevent rate limiting generate a GitHub Personal token and add it to the Info.plist
        if let authToken = Bundle.main.object(forInfoDictionaryKey: "GITHUB_TOKEN") as? String, !authToken.isEmpty {
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }
        return request
    }

    // TODO: - Implement Paging to fetch more users
    func fetchUsers() async throws -> [User] {
        let (data, response) = try await URLSession.shared.data(for: customRequest(endpoint: "users"))

        guard let httpResponse = response as? HTTPURLResponse else { throw GithubAPIError.invalidResponse }

        if httpResponse.statusCode == 403 {
            throw GithubAPIError.rateLimitExceeded
        } else if httpResponse.statusCode != 200 {
            throw GithubAPIError.invalidResponse
        }

        do {
            let decodedUsers = try JSONDecoder().decode([User].self, from: data)
            return decodedUsers
        } catch {
            throw GithubAPIError.invalidData
        }
    }

    func fetchUserDetails(for user: String) async throws -> User {
        let (data, response) = try await URLSession.shared.data(for: customRequest(endpoint: "users/\(user)"))

        guard let httpResponse = response as? HTTPURLResponse else { throw GithubAPIError.invalidResponse }

        if httpResponse.statusCode == 403 {
            throw GithubAPIError.rateLimitExceeded
        } else if httpResponse.statusCode != 200 {
            throw GithubAPIError.invalidResponse
        }

        do {
            let user = try JSONDecoder().decode(User.self, from: data)
            return user
        } catch {
            throw GithubAPIError.invalidData
        }
    }

    // TODO: - Implement Paging to fetch more repositories
    func fetchRepositories(for user: String) async throws -> [Repository] {
        let (data, response) = try await URLSession.shared.data(for: customRequest(endpoint: "users/\(user)/repos"))

        guard let httpResponse = response as? HTTPURLResponse else { throw GithubAPIError.invalidResponse }

        if httpResponse.statusCode == 403 {
            throw GithubAPIError.rateLimitExceeded
        } else if httpResponse.statusCode != 200 {
            throw GithubAPIError.invalidResponse
        }

        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            let decodedRepos = try decoder.decode([Repository].self, from: data)
            return filterOutForkedRepositories(decodedRepos)
        } catch {
            throw GithubAPIError.invalidData
        }
    }

    private func filterOutForkedRepositories(_ repos: [Repository]) -> [Repository] {
        repos.filter { $0.isFork == false }
    }
}
