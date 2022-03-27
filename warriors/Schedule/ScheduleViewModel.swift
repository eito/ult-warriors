//
//  ScheduleViewModel.swift
//  warriors
//
//  Created by Eric Ito on 3/12/22.
//

import Foundation
import SwiftUI

@MainActor
class ScheduleViewModel: ObservableObject {

    private let id = UUID()
    private let seasonID: Int
    private let divisionID: Int
    private let teamID: Int

    @Published var status: Status = .idle
    @Published var games = [ScheduleResponse.Game]()

    init(seasonID: Int, divisionID: Int, teamID: Int) {
        self.seasonID = seasonID
        self.divisionID = divisionID
        self.teamID = teamID
    }

    func refresh() async {

        status = .loading

        do {
            games = try await API.fetchSchedule(forTeamID: teamID, seasonID: seasonID)
            status = .loaded
        } catch {
            // HACK: because this is called twice it cancels and temporarily
            // shows the cancelled message
            //
            guard (error as NSError).code != -999 else { return }
            status = .failedToLoad(error)
            print("Error fetching standings: \(error)")
        }
    }
}

extension ScheduleViewModel: Equatable {

    nonisolated static func ==(lhs: ScheduleViewModel, rhs: ScheduleViewModel) -> Bool {
        lhs.teamID == rhs.teamID //&& lhs.refreshDate == rhs.refreshDate
    }
}
