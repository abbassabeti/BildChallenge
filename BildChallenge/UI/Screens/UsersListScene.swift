//
//  ContentView.swift
//  Shared
//
//  Created by Abbas Sabeti on 31/12/2021.
//

import SwiftUI
import Combine

struct UsersListScene: View {

    @State private var usersSearch = UsersSearch()
    @State private(set) var users: Loadable<[User]>
    @State private var routingState: Routing = .init()
    private var routingBinding: Binding<Routing> {
        $routingState.dispatched(to: injected.appState, \.routing.usersList)
    }
    @Environment(\.injected) private var injected: DIContainer

    let inspection = Inspection<Self>()

    init(users: Loadable<[User]> = .notRequested) {
        self._users = .init(initialValue: users)
    }

    var body: some View {
        GeometryReader { _ in
            NavigationView {
                self.content
                    .navigationTitle("Users")
            }
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
        }
        .onReceive(keyboardHeightUpdate) {
            self.usersSearch.keyboardHeight = $0
        }
        .onReceive(routingUpdate) {
            self.routingState = $0
        }
    }
    private var content : some View {
        VStack(alignment: .center) {
//            Text("Users")
//                .multilineTextAlignment(.center)
//                .padding()
//                .font(.title)

            SearchBarView(text: $usersSearch.searchText
                .onSet { _ in
                    self.reloadUsers()
                }
            )
            Divider()
            itemsView
            Spacer()
        }
        .frame(maxHeight: .infinity)
    }

    private var itemsView: AnyView {
        switch users {
        case .notRequested: return AnyView(notRequestedView)
        case let .isLoading(last, _): return AnyView(loadingView(last))
        case let .loaded(users): return AnyView(loadedView(users, showSearch: true, showLoading: false))
        case let .failed(error): return AnyView(failedView(error))
        }
    }

}

private extension UsersListScene {
    func reloadUsers() {
        guard usersSearch.searchText.count > 0 else {
            users = .notRequested
            return
        }
        injected.interactors.usersInteractor
            .refreshUsersList(users: $users, search: usersSearch.searchText)
    }
}

private extension UsersListScene {
    var notRequestedView: some View {
        Text("").onAppear(perform: reloadUsers)
    }

    func loadingView(_ previouslyLoaded: [User]?) -> some View {
        if let users = previouslyLoaded {
            return AnyView(loadedView(users, showSearch: true, showLoading: true))
        } else {
            return AnyView(ActivityIndicatorView().padding())
        }
    }

    func failedView(_ error: Error) -> some View {
        ErrorView(error: error, retryAction: {
            self.reloadUsers()
        })
    }
}

// MARK: - Displaying Content

private extension UsersListScene {
    func loadedView(_ users: [User], showSearch: Bool, showLoading: Bool) -> some View {
        VStack {
            if showLoading {
                ActivityIndicatorView().padding()
            }
            List(users) { user in
                NavigationLink(
                    destination: LazyView<UserDetailsScene>(detailsView(user: user)),
                    tag: user.name ?? "",
                    selection: self.routingBinding.userDetailsId) {
                        UserCell(user: user)
                    }
            }
            .id(users.count)
        }.padding(.bottom, bottomInset)
    }

    func detailsView(user: User) -> UserDetailsScene {
        print("going to fetch \(String(describing: user.name))")
        return UserDetailsScene(user: user)
    }

    var bottomInset: CGFloat {
        if #available(iOS 14, *) {
            return 0
        } else {
            return usersSearch.keyboardHeight
        }
    }
}

extension UsersListScene {
    struct UsersSearch {
        var searchText: String = ""
        var keyboardHeight: CGFloat = 0
    }
}

extension UsersListScene {
    struct Routing: Equatable {
        var userDetailsId: String?
    }
}

private extension UsersListScene {
    var routingUpdate: AnyPublisher<Routing, Never> {
        injected.appState.updates(for: \.routing.usersList)
    }

    var keyboardHeightUpdate: AnyPublisher<CGFloat, Never> {
        injected.appState.updates(for: \.system.keyboardHeight)
    }
}

#if DEBUG
struct UsersListScene_Previews: PreviewProvider {
    static var previews: some View {
        UsersListScene()
    }
}
#endif
