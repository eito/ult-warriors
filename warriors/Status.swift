//
//  Status.swift
//  warriors
//
//  Created by Eric Ito on 3/12/22.
//

import Foundation

enum Status: Equatable {
    case idle
    case loading
    case failedToLoad(Error)
    case loaded

    static func ==(lhs: Status, rhs: Status) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.loaded, .loaded):
            return true
        case (.failedToLoad, .failedToLoad):
            return true
        default:
            return false
        }
    }
}
