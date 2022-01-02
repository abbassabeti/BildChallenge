//
//  HelpersTests.swift
//  BildChallengeTests
//
//  Created by Abbas Sabeti on 03/01/2022.
//

import XCTest
@testable import BildChallenge

class HelpersTests: XCTestCase {

    func test_result_isSuccess() {
        let sut1 = Result<Void, Error>.success(())
        let sut2 = Result<Void, Error>.failure(NSError.test)
        XCTAssertTrue(sut1.isSuccess)
        XCTAssertFalse(sut2.isSuccess)
    }
}
