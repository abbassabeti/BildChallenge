//
//  TestHelpers.swift
//  Tests iOS
//
//  Created by Abbas Sabeti on 02/01/2022.
//

import XCTest
import ViewInspector
@testable import BildChallenge

enum MockError: Swift.Error {
    case valueNotSet
    case codeDataModel
}

extension NSError {
    static var test: NSError {
        return NSError(domain: "test", code: 0, userInfo: [NSLocalizedDescriptionKey: "Test error"])
    }
}

extension Inspection: InspectionEmissary where V: Inspectable { }

extension UsersListScene: Inspectable { }
extension ActivityIndicatorView: Inspectable { }
extension UserCell: Inspectable { }
extension ErrorView: Inspectable { }
