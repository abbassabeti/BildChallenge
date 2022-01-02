//
//  Helpers.swift
//  BildChallenge (iOS)
//
//  Created by Abbas Sabeti on 31/12/2021.
//

import SwiftUI
import Combine

// MARK: - General

extension ProcessInfo {
    var isRunningTests: Bool {
        environment["XCTestConfigurationFilePath"] != nil
    }
}

extension Result {
    var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }
}
