//
//  AppState.swift
//  BildChallenge (iOS)
//
//  Created by Abbas Sabeti on 31/12/2021.
//

import SwiftUI
import Combine

struct AppState: Equatable {
    var usersData = UsersData()
    var routing = ViewRouting()
    var system = System()
}

extension AppState {
    struct UsersData: Equatable {
        /*
         Shared data of search results which is useful in the entire app.
         */
    }
}

extension AppState {
    struct ViewRouting: Equatable {
        var usersList = UsersListScene.Routing()
        var userDetails = UserDetailsScene.Routing()
    }
}

extension AppState {
    struct System: Equatable {
        var isActive: Bool = false
        var keyboardHeight: CGFloat = 0
    }
}

func == (lhs: AppState, rhs: AppState) -> Bool {
    return lhs.usersData == rhs.usersData &&
        lhs.routing == rhs.routing &&
        lhs.system == rhs.system
}

#if DEBUG
extension AppState {
    static var preview: AppState {
        var state = AppState()
        state.system.isActive = true
        return state
    }
}
#endif
