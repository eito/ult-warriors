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

            let url = URL(string: "https://the-rinks-great-park-ice.kreezee-sports.com/api/v2/solutions/20151/teams/\(teamID)/players/statistics?&seasonId=\(seasonID)")!

            let request = URLRequest(url: url)

            let response = try await API.fetchResponse(for: request, decodable: RosterResponse.self)

            guard let first = response.playerCategories.first else {
                status = .failedToLoad(NSError(domain: "unknown", code: 1, userInfo: nil))
                return
            }

            var allSkaters = [Skater]()
            for player in first.players {

                guard let goals = player.stats.first(where: { $0.statTypeId == 6 })?.value else { return }
                guard let assists = player.stats.first(where: { $0.statTypeId == 7 })?.value else { return }
                guard let pim = player.stats.first(where: { $0.statTypeId == 8 })?.value else { return }
                guard let gp = player.stats.first(where: { $0.statTypeId == 14 })?.value else { return }
                guard let ppg = player.stats.first(where: { $0.statTypeId == 26 })?.value else { return }
                guard let shg = player.stats.first(where: { $0.statTypeId == 27 })?.value else { return }
                guard let gwg = player.stats.first(where: { $0.statTypeId == 28 })?.value else { return }
                guard let pts = player.stats.first(where: { $0.statTypeId == 29 })?.value else { return }

                let skater = Skater(
                    teamID: teamID,
                    playerID: player.id,
                    name: player.name,
                    team: player.teamName,
                    goals: goals,
                    assists: assists,
                    pim: pim / 10,
                    gamesPlayed: gp,
                    ppg: ppg,
                    shg: shg,
                    gwg: gwg,
                    pts: pts,
                    number: player.number)
                allSkaters.append(skater)
            }

            skaters = allSkaters.sorted { s1, s2 in
                if s1.pts == s2.pts {
                    return s1.goals > s2.goals
                } else {
                    return s1.pts > s2.pts
                }
            }

            /*
             sid 6  ------- 5   GOALS
             sid 7  ------- 4   ASSISTS
             sid 8  ------- 20 2 -- PIM
             sid 9
             sid 10 --- 17 SAVES
             sid 11
             sid 12
             sid 13
             sid 14 -------- 5  GP
             sid 15 --- 2 WINS
             sid 16
             sid 17
             sid 18
             sid 19
             sid 20
             sid 21
             sid 22 --- 8 GA
             sid 23 --- 23 SHOTS
             sid 24 --- 72 MIN
             sid 25
             sid 26 ----------- PP
             sid 27 ------------ SHG
             sid 28 ----------- 1 GWG
             sid 29 ----------- 9 PTS
             sid 62 --- 2 WINS?
             sid 29
             sid 30 --- 652 0.652 SV %
             sid 31 ---- 0 0.00  Points Per Game
             sid 32 ---  0 0.00
             sid 33

             */
            
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
