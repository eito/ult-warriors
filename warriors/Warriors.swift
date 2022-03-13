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
    static let defaultValue = 11194
}

struct CurrentSeasonIDKey: EnvironmentKey {
    static let defaultValue = 10991
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
