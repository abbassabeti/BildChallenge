//
//  MocksInteractors.swift
//  BildChallenge (iOS)
//
//  Created by Abbas Sabeti on 02/01/2022.
//

import XCTest
import SwiftUI
import Combine
import ViewInspector
@testable import BildChallenge

extension DIContainer.Interactors {
    static func mocked(
        usersInteractor: [MockedUsersInteractor.Action] = []
    ) -> DIContainer.Interactors {
        .init(usersInteractor: MockedUsersInteractor(expected: usersInteractor))
    }

    func verify(file: StaticString = #file, line: UInt = #line) {
        (usersInteractor as? MockedUsersInteractor)?
            .verify(file: file, line: line)
    }
}

// MARK: - MockedUsersInteractor

struct MockedUsersInteractor: Mock, UsersListInteractor {
    func refreshUsersList(users: LoadableSubject<[User]>, search: String) {
        register(.refreshUsersList)
    }

    func loadDetails(userDetails: LoadableSubject<User.Details>, user: User) {
        register(.loadUserDetails(user))
    }

    enum Action: Equatable {
        case refreshUsersList
        case loadUserDetails(User)
    }

    let actions: MockActions<Action>

    init(expected: [Action]) {
        self.actions = .init(expected: expected)
    }
}
