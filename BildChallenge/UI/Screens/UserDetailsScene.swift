//
//  UserDetailsScene.swift
//  BildChallenge (iOS)
//
//  Created by Abbas Sabeti on 31/12/2021.
//

import SwiftUI
import Combine

struct UserDetailsScene: View {

    let user: User
    @Environment(\.injected) private var injected: DIContainer
    @State private var details: Loadable<User.Details> = .notRequested

    init(user: User) {
        self.user = user
    }

    var body: some View {
        HStack {
            AsyncImage(url: user.avatar) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .frame(width: 80, height: 80, alignment: .center)
                    .padding(7)
            } placeholder: {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
            }
            VStack(alignment: .leading) {
                Text(fullName)
                    .font(.title)
                Text("User Name: \(userName)")
                    .font(.caption)
                Text("Repositories: \(repoCountStr)")
                    .font(.caption)
                Text("Followers: \(followerCountStr)")
                    .font(.caption)
            }
            Spacer()
        }.onAppear {
            loadUserDetails(user: user, details: $details)
        }
        Spacer()
    }

    var followerCountStr: String {
        switch details {
        case let .loaded(info):
            guard let count = info.followers else {return ""}
            return "\(count)"
        default:
            return ""
        }
    }

    var repoCountStr: String {
        switch details {
        case let .loaded(info):
            guard let count = info.publicRepos else {return ""}
            return "\(count)"
        default:
            return ""
        }
    }

    var fullName: String {
        switch details {
        case let .loaded(info):
            return info.name ?? ""
        default:
            return ""
        }
    }

    var userName: String {
        switch details {
        case let .loaded(info):
            return info.userName ?? ""
        default:
            return ""
        }
    }
}

extension UserDetailsScene {
    func loadUserDetails(user: User, details: LoadableSubject<User.Details>) {
        injected.interactors.usersInteractor
            .loadDetails(userDetails: details, user: user)
    }
}

extension UserDetailsScene {
    struct UsersSearch {
        var searchText: String = ""
        var keyboardHeight: CGFloat = 0
    }
}

extension UserDetailsScene {
    struct Routing: Equatable {
        var detailsSheet: Bool = false
    }
}

private extension UserDetailsScene {
    var routingUpdate: AnyPublisher<Routing, Never> {
        injected.appState.updates(for: \.routing.userDetails)
    }
}

struct UserDetailsScene_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailsScene(user: User.mockedData[0])
            .inject(.preview)
    }
}
