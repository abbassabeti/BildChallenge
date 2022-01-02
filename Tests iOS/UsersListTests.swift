//
//  UsersListTests.swift
//  Tests iOS
//
//  Created by Abbas Sabeti on 02/01/2022.
//

import XCTest
import ViewInspector
import SwiftUI
@testable import BildChallenge

extension UsersListScene: Inspectable { }
extension ActivityIndicatorView: Inspectable { }
extension UserCell: Inspectable { }
extension ErrorView: Inspectable { }

final class CountriesListTests: XCTestCase {

    func test_countries_notRequested() {
        let container = DIContainer(appState: AppState(), interactors:
                                            .stub)
        let sut = UsersListScene(users: .notRequested)
        let exp = sut.inspection.inspect { view in
            XCTAssertNoThrow(try view.content().text())
            XCTAssertEqual(container.appState.value, AppState())
            container.interactors.verify()
        }
        ViewHosting.host(view: sut.inject(container))
        wait(for: [exp], timeout: 2)
    }

    func test_countries_isLoading_initial() {
        let container = DIContainer(appState: AppState(), interactors: .mocked())
        let sut = UsersListScene(users: .isLoading(last: nil, cancelBag: CancelBag()))
        let exp = sut.inspection.inspect { view in
            let content = try view.content()
            XCTAssertNoThrow(try content.view(ActivityIndicatorView.self))
            XCTAssertEqual(container.appState.value, AppState())
            container.interactors.verify()
        }
        ViewHosting.host(view: sut.inject(container))
        wait(for: [exp], timeout: 2)
    }

    func test_countries_isLoading_refresh() {
        let container = DIContainer(appState: AppState(), interactors: .mocked())
        let sut = UsersListScene(users: .isLoading(
            last: User.mockedData, cancelBag: CancelBag()))
        let exp = sut.inspection.inspect { view in
            let content = try view.content()
            XCTAssertNoThrow(try content.find(ActivityIndicatorView.self))
            let cell = try content.find(UserCell.self).actualView()
            XCTAssertEqual(cell.user, User.mockedData[0])
            XCTAssertEqual(container.appState.value, AppState())
            container.interactors.verify()
        }
        ViewHosting.host(view: sut.inject(container))
        wait(for: [exp], timeout: 2)
    }

    func test_countries_loaded() {
        let container = DIContainer(appState: AppState(), interactors: .mocked())
        let sut = UsersListScene(users: .loaded(User.mockedData))
        let exp = sut.inspection.inspect { view in
            let content = try view.content()
            XCTAssertThrowsError(try content.find(ActivityIndicatorView.self))
            let cell = try content.find(UserCell.self).actualView()
            XCTAssertEqual(cell.user, User.mockedData[0])
            XCTAssertEqual(container.appState.value, AppState())
            container.interactors.verify()
        }
        ViewHosting.host(view: sut.inject(container))
        wait(for: [exp], timeout: 2)
    }

    func test_countries_failed() {
        let container = DIContainer(appState: AppState(), interactors: .mocked())
        let sut = UsersListScene(users: .failed(NSError.test))
        let exp = sut.inspection.inspect { view in
            XCTAssertNoThrow(try view.content().view(ErrorView.self))
            XCTAssertEqual(container.appState.value, AppState())
            container.interactors.verify()
        }
        ViewHosting.host(view: sut.inject(container))
        wait(for: [exp], timeout: 2)
    }

    func test_countries_failed_retry() {
        let container = DIContainer(appState: AppState(), interactors: .mocked())
        let sut = UsersListScene(users: .failed(NSError.test))
        let exp = sut.inspection.inspect { view in
            let errorView = try view.content().view(ErrorView.self)
            try errorView.vStack().button(2).tap()
            XCTAssertEqual(container.appState.value, AppState())
            container.interactors.verify()
        }
        ViewHosting.host(view: sut.inject(container))
        wait(for: [exp], timeout: 2)
    }

    func test_countries_navigation_to_details() {
        let users = User.mockedData
        let container = DIContainer(appState: AppState(), interactors: .mocked())
        XCTAssertNil(container.appState.value.routing.userDetails)
        let sut = UsersListScene(users: .loaded(users))
        let exp = sut.inspection.inspect { view in
            let firstCountryRow = try view.content().find(ViewType.NavigationLink.self)
            try firstCountryRow.activate()
            let selected = container.appState.value.routing.usersList.userDetailsId
            XCTAssertEqual(selected, users[0].id)
            _ = try firstCountryRow.find(where: { try $0.callOnAppear(); return true })
            container.interactors.verify()
        }
        ViewHosting.host(view: sut.inject(container))
        wait(for: [exp], timeout: 2)
    }
}

// MARK: - UsersList inspection helper

extension InspectableView where View == ViewType.View<UsersListScene> {
    func content() throws -> InspectableView<ViewType.AnyView> {
        return try find(ViewType.AnyView.self)
    }
}
