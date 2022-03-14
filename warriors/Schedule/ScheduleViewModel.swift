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

            let url = URL(string: "https://the-rinks-great-park-ice.kreezee-sports.com/api/v2/solutions/20151/seasons/\(seasonID)/schedule")!
            let request = URLRequest(url: url)

            let allGames = try await API.fetchResponse(for: request, decodable: [ScheduleResponse.Game].self)

            var warriorGames = [ScheduleResponse.Game]()
            for game in allGames.filter({ ($0.homeTeamID == teamID || $0.awayTeamID == teamID) && !$0.isFinal }) {
//                print("\(game.id)  --- \(game.awayTeamName) @ \(game.homeTeamName)")

                warriorGames.append(game)
            }
            status = .loaded
            games = warriorGames
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
