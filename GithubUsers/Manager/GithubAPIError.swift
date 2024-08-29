//
//  GithubAPIError.swift
//  GithubUsers
//
//  Created by TokyoBits on 8/29/24.
//

import Foundation

enum GithubAPIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case rateLimitExceeded
}
