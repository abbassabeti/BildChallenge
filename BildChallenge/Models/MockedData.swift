//
//  MockedData.swift
//  BildChallenge (iOS)
//
//  Created by Abbas Sabeti on 31/12/2021.
//

import Foundation

#if DEBUG

extension User {
    static let mockedData: [User] = [
        User(name: "User 1", userId: 1, avatar: URL(string: "https://avatars.githubusercontent.com/u/39451059?v=4"))
    ]
}

extension User.Details {
    static var mockedData: [User.Details] = {
        let neighbors = User.mockedData
        return [
            User.Details(name: "", userName: "", avatar: nil, publicRepos: 1, followers: 1)
        ]
    }()
}

#endif
