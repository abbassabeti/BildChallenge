//
//  ContentViewTests.swift
//  BildChallengeTests
//
//  Created by Abbas Sabeti on 03/01/2022.
//

import XCTest
import ViewInspector
@testable import BildChallenge

extension ContentView: Inspectable { }

final class ContentViewTests: XCTestCase {

    func test_content_for_tests() throws {
        let sut = ContentView(container: .defaultValue, isRunningTests: true)
        XCTAssertNoThrow(try sut.inspect().group().text(0))
    }

    func test_content_for_build() throws {
        let sut = ContentView(container: .defaultValue, isRunningTests: false)
        XCTAssertNoThrow(try sut.inspect().group().view(UsersListScene.self, 0))
    }

    func test_change_handler_for_colorScheme() throws {
        var appState = AppState()
        appState.routing.usersList = .init(userDetailsId: "")
        let container = DIContainer(appState: .init(appState), interactors: .mocked())
        let sut = ContentView(container: container)
        sut.onChangeHandler(.colorScheme)
        XCTAssertEqual(container.appState.value, appState)
        container.interactors.verify()
    }

    func test_change_handler_for_sizeCategory() throws {
        var appState = AppState()
        appState.routing.usersList = .init(userDetailsId: "")
        let container = DIContainer(appState: .init(appState), interactors: .mocked())
        let sut = ContentView(container: container)
        XCTAssertEqual(container.appState.value, appState)
        sut.onChangeHandler(.sizeCategory)
        XCTAssertEqual(container.appState.value, AppState())
        container.interactors.verify()
    }
}
