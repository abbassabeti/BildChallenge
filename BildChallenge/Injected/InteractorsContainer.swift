//
//  InteractorsContainer.swift
//  BildChallenge (iOS)
//
//  Created by Abbas Sabeti on 31/12/2021.
//

import Foundation

extension DIContainer {
    struct Interactors {
        let usersInteractor: UsersListInteractor
        
        init(usersInteractor: UsersListInteractor){
            self.usersInteractor = usersInteractor
        }
        
        static var stub: Self {
            .init(usersInteractor: StubUsersListInteractor())
        }
    }
}
