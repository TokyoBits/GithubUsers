//
//  Repository.swift
//  GithubUsers
//
//  Created by TokyoBits on 8/29/24.
//

import SwiftData

class Repository: Identifiable, Codable {
    let id: Int
    let name: String
    let description: String?
    let language: String?
    let isFork: Bool
    let starsCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case language
        case isFork = "fork"
        case starsCount = "stargazers_count"
    }
}

extension Repository: Hashable {
    static func == (lhs: Repository, rhs: Repository) -> Bool {
        lhs === rhs
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
