//
//  Users.swift
//  BildChallenge (iOS)
//
//  Created by Abbas Sabeti on 31/12/2021.
//

import Foundation

struct User: Codable, Equatable {
    let name: String?
    let userId: Int?
    let avatar: URL?

    enum CodingKeys: String, CodingKey {
            case name = "login"
            case avatar = "avatar_url"
            case userId = "id"
    }
}

extension User {
    struct Details: Codable, Equatable, Hashable {
        let name: String?
        let userName: String?
        let avatar: URL?
        let publicRepos: Int?
        let followers: Int?

        enum CodingKeys: String, CodingKey {
            case name = "name"
            case userName = "login"
            case avatar = "avatar_url"
            case publicRepos = "public_repos"
            case followers = "followers"
        }
    }
}

extension User {

    struct RawList: Codable, Equatable {
        let totalCount: Int
        let items: [User]
        enum CodingKeys: String, CodingKey {
            case totalCount = "total_count"
            case items = "items"
        }
    }
}

extension User: Identifiable {
    var id: String { name ?? "" }
}
