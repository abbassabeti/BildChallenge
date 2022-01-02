//
//  AppEnvironment.swift
//  BildChallenge (iOS)
//
//  Created by Abbas Sabeti on 31/12/2021.
//

import UIKit
import Combine

struct AppEnvironment {
    let container: DIContainer
}

extension AppEnvironment {
    static func bootstrap() -> AppEnvironment {
        let appState = Store<AppState>(AppState())
        
        let session = configuredURLSession()
        let webRepositories = configuredWebRepositories(session: session)
        let interactors = configuredInteractors(appState: appState, webRepositories: webRepositories)
        let diContainer = DIContainer(appState: appState, interactors: interactors)
        
        return AppEnvironment(container: diContainer)
    }
    
    private static func configuredURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }
    
    private static func configuredWebRepositories(session: URLSession) -> DIContainer.WebRepositories {
        let usersWebRepository = RealUsersWebRepository(
            session: session,
            baseURL: "https://api.github.com")
        return .init(usersRepository: usersWebRepository)
    }
    
    private static func configuredInteractors(appState: Store<AppState>,
        webRepositories: DIContainer.WebRepositories
    ) -> DIContainer.Interactors {
        
        let usersInteractor = RealUsersListInteractor(
            webRepository: webRepositories.usersRepository,
            appState: appState)
        
        return .init(usersInteractor: usersInteractor)
    }
}

extension DIContainer {
    struct WebRepositories {
        let usersRepository: UsersWebRepository
    }
}
