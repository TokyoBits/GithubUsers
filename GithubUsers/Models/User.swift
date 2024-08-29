//
//  User.swift
//  GithubUsers
//
//  Created by TokyoBits on 8/29/24.
//

import SwiftData

class User: Identifiable, Codable {
    let id: Int
    let avatarUrl: String?
    let gravatarUrl: String?
    let name: String

    enum CodingKeys: String, CodingKey {
        case id
        case avatarUrl = "avatar_url"
        case gravatarUrl = "gravatar_url"
        case name = "login"
    }
}
