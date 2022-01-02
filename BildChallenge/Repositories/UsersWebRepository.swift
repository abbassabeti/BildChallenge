//
//  UsersWebRepository.swift
//  BildChallenge (iOS)
//
//  Created by Abbas Sabeti on 31/12/2021.
//

import Combine
import Foundation

protocol UsersWebRepository: WebRepository {
    func loadUsers(keyword: String) -> AnyPublisher<User.RawList, Error>
    func loadUserDetails(userName: String) -> AnyPublisher<User.Details, Error>
}

struct RealUsersWebRepository: UsersWebRepository {

    let session: URLSession
    let baseURL: String
    let bgQueue = DispatchQueue(label: "bg_parse_queue")

    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }

    func loadUsers(keyword: String) -> AnyPublisher<User.RawList, Error> {
        return call(endpoint: API.allUsers(keyword))
    }

    func loadUserDetails(userName: String) -> AnyPublisher<User.Details, Error> {
        return call(endpoint: API.details(userName))
    }
}

// MARK: - Endpoints

extension RealUsersWebRepository {
    enum API {
        case allUsers(String)
        case details(String)
    }
}

extension RealUsersWebRepository.API: APICall {
    var path: String {
        switch self {
        case let .allUsers(keyword):
            let encodedName = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            return "/search/users?q=\(encodedName ?? keyword)+in:user"
        case let .details(userName):
            return "/users/\(userName)"

        }
    }
    var method: String {
        switch self {
        case .allUsers, .details:
            return "GET"
        }
    }

    var headers: [String: String]? {
        return ["Accept": "application/vnd.github.v3+json"]
    }

    func body() throws -> Data? {
        return nil
    }
}
