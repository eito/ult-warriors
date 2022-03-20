//
//  TeamViewModel.swift
//  Warriors
//
//  Created by Eric Ito on 3/19/22.
//

import Foundation
import SwiftUI

@MainActor
class TeamViewModel: ObservableObject {
    let skaters: [Skater]
    let teamName: String

    init(teamName: String, skaters: [Skater]) {
        self.teamName = teamName
        self.skaters = skaters
    }
}

