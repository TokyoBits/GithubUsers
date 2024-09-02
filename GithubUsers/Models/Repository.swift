//
//  Repository.swift
//  GithubUsers
//
//  Created by TokyoBits on 8/29/24.
//

import Foundation
import SwiftData

class Repository: Identifiable, Codable {
    let id: Int
    let name: String
    let description: String?
    let language: String?
    let isFork: Bool
    let starsCount: Int
    let url: String
    let lastUpdated: Date

    init(
        id: Int,
        name: String,
        description: String?,
        language: String?,
        isFork: Bool,
        starsCount: Int,
        url: String,
        lastUpdated: Date
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.language = language
        self.isFork = isFork
        self.starsCount = starsCount
        self.url = url
        self.lastUpdated = lastUpdated
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case language
        case isFork = "fork"
        case starsCount = "stargazers_count"
        case url = "html_url"
        case lastUpdated = "updated_at"
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
