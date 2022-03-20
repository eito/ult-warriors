//
//  RosterViewModel.swift
//  Warriors
//
//  Created by Eric Ito on 3/13/22.
//

import Foundation
import SwiftUI

@MainActor
class RosterViewModel: ObservableObject {

    private let id = UUID()
    private let seasonID: Int
    private let teamID: Int
    let teamName: String

    @Published var status: Status = .idle
    @Published var skaters = [Skater]()

    init(seasonID: Int, teamID: Int, teamName: String) {
        self.seasonID = seasonID
        self.teamID = teamID
        self.teamName = teamName
    }
    
    // https://the-rinks-great-park-ice.kreezee-sports.com/api/v2/solutions/20151/teams/70496/players/statistics?&seasonId=10991
    //
    func refresh() async {

        status = .loading
        
        do {
            skaters = try await API.fetchRoster(teamID: teamID, seasonID: seasonID)
            status = .loaded
        } catch {
            // HACK: because this is called twice it cancels and temporarily
            // shows the cancelled message
            //
            guard (error as NSError).code != -999 else { return }
            status = .failedToLoad(error)
            print("Error fetching roster: \(error)")
        }
    }
}

extension RosterViewModel: Equatable {

    nonisolated static func ==(lhs: RosterViewModel, rhs: RosterViewModel) -> Bool {
        lhs.id == rhs.id
    }
}
