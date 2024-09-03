//
//  User.swift
//  GithubUsers
//
//  Created by TokyoBits on 8/29/24.
//

import Foundation

class User: Identifiable, Codable {
    let id: Int
    private let avatarUrl: String?
    private let gravatarUrl: String?
    let username: String
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
