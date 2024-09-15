//
//  Repository.swift
//  GithubUsers
//
//  Created by TokyoBits on 8/29/24.
//

import Foundation
import SwiftData

@Model
class Repository: Identifiable, Decodable {
    @Attribute(.unique) var id: Int
    var name: String
    var summary: String?
    var language: String?
    var isFork: Bool
    var starsCount: Int
    var url: String
    var lastUpdated: Date
    var owner: String

    init(
        id: Int,
        name: String,
        summary: String?,
        language: String?,
        isFork: Bool,
        starsCount: Int,
        url: String,
        lastUpdated: Date,
        owner: String
    ) {
        self.id = id
        self.name = name
        self.summary = summary
        self.language = language
        self.isFork = isFork
        self.starsCount = starsCount
        self.url = url
        self.lastUpdated = lastUpdated
        self.owner = owner
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.summary = try? container.decode(String.self, forKey: .summary)
        self.language = try? container.decode(String.self, forKey: .language)
        self.isFork = try container.decode(Bool.self, forKey: .isFork)
        self.starsCount = try container.decode(Int.self, forKey: .starsCount)
        self.url = try container.decode(String.self, forKey: .url)
        self.lastUpdated = try container.decode(Date.self, forKey: .lastUpdated)

        let ownerContainer = try container.nestedContainer(keyedBy: OwnerCodingKeys.self, forKey: .owner)
        self.owner = try ownerContainer.decode(String.self, forKey: .login)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case summary = "description"
        case language
        case isFork = "fork"
        case starsCount = "stargazers_count"
        case url = "html_url"
        case lastUpdated = "updated_at"
        case owner
    }

    enum OwnerCodingKeys: CodingKey {
        case login
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
