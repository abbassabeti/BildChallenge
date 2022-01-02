//
//  RootViewModifier.swift
//  BildChallenge (iOS)
//
//  Created by Abbas Sabeti on 31/12/2021.
//

import SwiftUI
import Combine

// MARK: - RootViewAppearance

struct RootViewAppearance: ViewModifier {

    @Environment(\.injected) private var injected: DIContainer
    @State private var isActive: Bool = false

    func body(content: Content) -> some View {
        content
            .onReceive(stateUpdate) { self.isActive = $0 }
    }

    private var stateUpdate: AnyPublisher<Bool, Never> {
        injected.appState.updates(for: \.system.isActive)
    }
}
