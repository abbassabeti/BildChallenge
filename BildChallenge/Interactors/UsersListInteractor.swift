//
//  UsersListInteractor.swift
//  BildChallenge (iOS)
//
//  Created by Abbas Sabeti on 31/12/2021.
//

import Foundation
import Combine
import SwiftUI

protocol UsersListInteractor {
    func refreshUsersList(users: LoadableSubject<[User]>, search: String)
    func loadDetails(userDetails: LoadableSubject<User.Details>, user: User)
}

struct RealUsersListInteractor: UsersListInteractor {
    let webRepository: UsersWebRepository
    let appState: Store<AppState>
    // if our app needs a db in the future, we can consider having a dbRepository here.

    init(webRepository: UsersWebRepository, appState: Store<AppState>) {
        self.webRepository = webRepository
        self.appState = appState
    }

    func refreshUsersList(users: LoadableSubject<[User]>, search: String) {

        let cancelBag = CancelBag()
        users.wrappedValue.setIsLoading(cancelBag: cancelBag)

        webRepository
            .loadUsers(keyword: search)
            .ensureTimeSpan(requestHoldBackTimeInterval)
            .tryMap {
                return $0.items
            }
            .sinkToLoadable({
                users.wrappedValue = $0
            })
            .store(in: cancelBag)
    }

    func loadDetails(userDetails: LoadableSubject<User.Details>, user: User) {

        let cancelBag = CancelBag()
        userDetails.wrappedValue.setIsLoading(cancelBag: cancelBag)

        webRepository
            .loadUserDetails(userName: user.id)
            .ensureTimeSpan(requestHoldBackTimeInterval)
            .sinkToLoadable({
                userDetails.wrappedValue = $0
            })
            .store(in: cancelBag)
    }

    private var requestHoldBackTimeInterval: TimeInterval {
        return ProcessInfo.processInfo.isRunningTests ? 0 : 0.5
    }
}

struct StubUsersListInteractor: UsersListInteractor {

    func refreshUsersList(users: LoadableSubject<[User]>, search: String) {
        let cancelBag = CancelBag()

        Just<[User]>(
            [User(name: search, userId: 0, avatar: nil), User(name: "\(search)2", userId: 1, avatar: nil)]
        ).sinkToLoadable {
            users.wrappedValue = $0
        }.store(in: cancelBag)
    }

    func loadDetails(userDetails: LoadableSubject<User.Details>, user: User) {
        let cancelBag = CancelBag()

        Just<User.Details>(
            User.Details(name: user.name, userName: user.name, avatar: user.avatar, publicRepos: 0, followers: 0))
            .sinkToLoadable {
            userDetails.wrappedValue = $0
        }.store(in: cancelBag)
    }
}
