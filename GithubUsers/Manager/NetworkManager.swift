//
//  NetworkManager.swift
//  GithubUsers
//
//  Created by TokyoBits on 8/29/24.
//

import SwiftUI

final class NetworkManager {
    static let shared = NetworkManager()

    private init() {}

    private let baseURL: String = "https://api.github.com/"

    func fetchUsers() async throws -> [User] {
        guard let url = URL(string: baseURL.appending("users")) else {
            throw GithubAPIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
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
        guard let url = URL(string: baseURL.appending("users/\(user)")) else {
            throw GithubAPIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw GithubAPIError.invalidResponse
        }

        do {
            let user = try JSONDecoder().decode(User.self, from: data)
            return user
        } catch {
            throw GithubAPIError.invalidData
        }
    }

    func fetchRepositories(for user: String) async throws -> [Repository] {
        guard let url = URL(string: baseURL.appending("users/\(user)/repos")) else {
            throw GithubAPIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw GithubAPIError.invalidResponse
        }

        do {
            let decodedRepos = try JSONDecoder().decode([Repository].self, from: data)
            return filterOutForkedRepositories(decodedRepos)
        } catch {
            throw GithubAPIError.invalidData
        }
    }

    private func filterOutForkedRepositories(_ repos: [Repository]) -> [Repository] {
        repos.filter { $0.isFork == false }
    }
}
