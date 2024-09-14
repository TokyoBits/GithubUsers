//
//  User.swift
//  GithubUsers
//
//  Created by TokyoBits on 8/29/24.
//

import Foundation
import SwiftData

@Model
class User: Identifiable, Decodable {
    var id: Int
    private var avatarUrl: String?
    private var gravatarUrl: String?
    var username: String
    var fullName: String?
    var bio: String?
    var company: String?
    var location: String?
    var followersCount: Int?
    var followingCount: Int?

    var userImage: String {
        if let avatarUrl { return avatarUrl }
        if let gravatarUrl { return gravatarUrl }

        return ""
    }

    init(
        id: Int,
        avatarUrl: String?,
        gravatarUrl: String?,
        username: String,
        fullName: String? = nil,
        bio: String? = nil,
        company: String? = nil,
        location: String? = nil,
        followersCount: Int? = nil,
        followingCount: Int? = nil
    ) {
        self.id = id
        self.avatarUrl = avatarUrl
        self.gravatarUrl = gravatarUrl
        self.username = username
        self.fullName = fullName
        self.bio = bio
        self.company = company
        self.location = location
        self.followersCount = followersCount
        self.followingCount = followingCount
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.avatarUrl = try? container.decode(String.self, forKey: .avatarUrl)
        self.gravatarUrl = try? container.decode(String.self, forKey: .gravatarUrl)
        self.username = try container.decode(String.self, forKey: .username)
        self.fullName = try? container.decode(String.self, forKey: .fullName)
        self.bio = try? container.decode(String.self, forKey: .bio)
        self.company = try? container.decode(String.self, forKey: .company)
        self.location = try? container.decode(String.self, forKey: .location)
        self.followersCount = try? container.decode(Int.self, forKey: .followersCount)
        self.followingCount = try? container.decode(Int.self, forKey: .followingCount)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case avatarUrl = "avatar_url"
        case gravatarUrl = "gravatar_url"
        case username = "login"
        case fullName = "name"
        case bio
        case company
        case location
        case followersCount = "followers"
        case followingCount = "following"
    }
}

extension User: Hashable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs === rhs
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
