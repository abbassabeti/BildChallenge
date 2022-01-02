//
//  ContentView.swift
//  BildChallenge (iOS)
//
//  Created by Abbas Sabeti on 01/01/2022.
//

import SwiftUI
import Combine
import EnvironmentOverrides

struct ContentView: View {

    private let container: DIContainer
    private let isRunningTests: Bool

    init(container: DIContainer, isRunningTests: Bool = ProcessInfo.processInfo.isRunningTests) {
        self.container = container
        self.isRunningTests = isRunningTests
    }

    var body: some View {
        Group {
            if isRunningTests {
                Text("Running unit tests")
            } else {
                UsersListScene()
                    .attachEnvironmentOverrides(onChange: onChangeHandler)
                    .inject(container)
            }
        }
    }

    var onChangeHandler: (EnvironmentValues.Diff) -> Void {
        return { diff in
            if !diff.isDisjoint(with: [.locale, .sizeCategory]) {
                self.container.appState[\.routing] = AppState.ViewRouting()
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(container: .preview)
    }
}
#endif
