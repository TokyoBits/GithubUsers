//
//  NetworkManager.swift
//  GithubUsers
//
//  Created by TokyoBits on 8/29/24.
//

import SwiftUI
import OSLog

final class NetworkManager {
    let logger: Logger = .init(subsystem: "jp.tokyobits.githubusers", category: "NetworkManager")

    static let shared = NetworkManager()

    private let baseURL: String = "https://api.github.com/"

    private init() {}

    func customRequest(endpoint: String, params: [String: String] = [:]) -> URLRequest {
        var url = URLComponents(string: baseURL.appending(endpoint))

        if !params.isEmpty {
            url?.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        }

        let queryString = url?.string ?? baseURL.appending(endpoint)
        logger.debug("Request: \(queryString)")

        var request = URLRequest(url: URL(string: queryString)!)
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")

        // To prevent rate limiting generate a GitHub Personal token and add it to the Info.plist
        if let authToken = Bundle.main.object(forInfoDictionaryKey: "GITHUB_TOKEN") as? String, !authToken.isEmpty {
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }
        return request
    }

    func fetchUsers(since: Int = 0, perPage: Int = 30) async throws -> [User] {
        let params: [String: String] = [
            "per_page": "\(perPage)",
            "since": "\(since)"
        ]

        let (data, response) = try await URLSession.shared.data(for: customRequest(endpoint: "users", params: params))

        guard let httpResponse = response as? HTTPURLResponse else { throw GithubAPIError.invalidResponse }

        if httpResponse.statusCode == 403 {
            logger.error("403: Rate limit exceeded - fetchUsers")
            throw GithubAPIError.rateLimitExceeded
        } else if httpResponse.statusCode != 200 {
            logger.error("Non-200 response: \(httpResponse.statusCode) - fetchUsers")
            throw GithubAPIError.invalidResponse
        }

        do {
            let decodedUsers = try JSONDecoder().decode([User].self, from: data)
            return decodedUsers
        } catch {
            logger.error("Unable to decode JSON - fetchUsers")
            throw GithubAPIError.invalidData
        }
    }

    func fetchUser(username: String) async throws -> User? {
        let (data, response) = try await URLSession.shared.data(for: customRequest(endpoint: "users/\(username)"))

        guard let httpResponse = response as? HTTPURLResponse else { throw GithubAPIError.invalidResponse }

        if httpResponse.statusCode == 403 {
            logger.error("403: Rate limit exceeded - fetchUser")
            throw GithubAPIError.rateLimitExceeded
        } else if httpResponse.statusCode != 200 {
            // Only log this response do not throw. We want to display no user message if a user does not exist
            logger.error("Non-200 response: \(httpResponse.statusCode) - fetchUser")
        }

        do {
            let decodedUser = try JSONDecoder().decode(User.self, from: data)
            return decodedUser
        } catch {
            // Only log this response do not throw. We want to display no user message if a user does not exist
            logger.error("Unable to decode JSON - fetchUser")
        }

        return nil
    }

    func fetchUserDetails(for user: String) async throws -> User {
        let (data, response) = try await URLSession.shared.data(for: customRequest(endpoint: "users/\(user)"))

        guard let httpResponse = response as? HTTPURLResponse else { throw GithubAPIError.invalidResponse }

        if httpResponse.statusCode == 403 {
            logger.error("403: Rate limit exceeded - fetchUserDetails")
            throw GithubAPIError.rateLimitExceeded
        } else if httpResponse.statusCode != 200 {
            logger.error("Non-200 response: \(httpResponse.statusCode) - fetchUserDetails")
            throw GithubAPIError.invalidResponse
        }

        do {
            let user = try JSONDecoder().decode(User.self, from: data)
            return user
        } catch {
            logger.error("Unable to decode JSON - fetchUserDetails")
            throw GithubAPIError.invalidData
        }
    }

    // TODO: - Implement Paging to fetch all repositories for users who have many repositories
    func fetchRepositories(for user: String, perPage: Int = 100) async throws -> [Repository] {
        let params: [String: String] = ["per_page": "\(perPage)"]

        let (data, response) = try await URLSession.shared.data(
            for: customRequest(endpoint: "users/\(user)/repos", params: params)
        )

        guard let httpResponse = response as? HTTPURLResponse else { throw GithubAPIError.invalidResponse }

        if httpResponse.statusCode == 403 {
            logger.error("403: Rate limit exceeded - fetchRepositories")
            throw GithubAPIError.rateLimitExceeded
        } else if httpResponse.statusCode != 200 {
            logger.error("Non-200 response: \(httpResponse.statusCode) - fetchRepositories")
            throw GithubAPIError.invalidResponse
        }

        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            let decodedRepos = try decoder.decode([Repository].self, from: data)
            return filterOutForkedRepositories(decodedRepos)
        } catch {
            logger.error("Unable to decode JSON - fetchRepositories")
            throw GithubAPIError.invalidData
        }
    }

    private func filterOutForkedRepositories(_ repos: [Repository]) -> [Repository] {
        repos.filter { $0.isFork == false }
    }
}
