//
//  User.swift
//  GithubUsers
//
//  Created by TokyoBits on 8/29/24.
//

import SwiftData

class User: Identifiable, Codable {
    let id: Int
    private let avatarUrl: String?
    private let gravatarUrl: String?
    let name: String

    var userImage: String {
        if let avatarUrl { return avatarUrl }
        if let gravatarUrl { return gravatarUrl }

        return ""
    }

    enum CodingKeys: String, CodingKey {
        case id
        case avatarUrl = "avatar_url"
        case gravatarUrl = "gravatar_url"
        case name = "login"
    }
}
