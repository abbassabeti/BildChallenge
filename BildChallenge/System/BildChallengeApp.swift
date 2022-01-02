//
//  BildChallengeApp.swift
//  Shared
//
//  Created by Abbas Sabeti on 31/12/2021.
//

import SwiftUI

@main
struct BildChallengeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(container: AppEnvironment.bootstrap().container)
        }
    }
}
