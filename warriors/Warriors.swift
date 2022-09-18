//
//  Warriors.swift
//  warriors
//
//  Created by Eric Ito on 3/11/22.
//

import Foundation
import SwiftUI

struct WarriorsTeamIDKey: EnvironmentKey {
    static let defaultValue = 70496
}

struct BronzeCentralDivisionIDKey: EnvironmentKey {
    static let defaultValue = 10627 //13587
}

struct CurrentSeasonIDKey: EnvironmentKey {
    // Spring 2022 = 10991
    // Summer 2022 = 11288
    // Fall 2022 = 11650
    static let defaultValue = 11650
}

extension EnvironmentValues {
    var warriorsTeamID: Int {
        get { self[WarriorsTeamIDKey.self] }
        set { self[WarriorsTeamIDKey.self] = newValue }
    }

    var bronzeCentralDivisionID: Int {
        get { self[BronzeCentralDivisionIDKey.self] }
        set { self[BronzeCentralDivisionIDKey.self] = newValue }
    }

    var currentSeasonID: Int {
        get { self[CurrentSeasonIDKey.self] }
        set { self[CurrentSeasonIDKey.self] = newValue }
    }
}
