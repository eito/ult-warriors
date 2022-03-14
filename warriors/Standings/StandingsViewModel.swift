//
//  StandingsViewModel.swift
//  warriors
//
//  Created by Eric Ito on 3/12/22.
//

import Foundation
import SwiftUI

@MainActor
class StandingsViewModel: ObservableObject {

    private let id = UUID()
    private let seasonID: Int
    private let divisionID: Int

    @Published var status: Status = .idle
    @Published var teams = [StandingsResponse.Team]()

    init(seasonID: Int, divisionID: Int) {
        self.seasonID = seasonID
        self.divisionID = divisionID
    }

    func refresh() async {

        status = .loading

        //https://the-rinks-great-park-ice.kreezee-sports.com/api/v2/solutions/20151/players/statistics?page=1&pageSize=12&sortOrder=desc&sortStatId=29&positionType=2&seasonId=10991&divisionId=11194

        let url = URL(string: "https://kreezeerestapi.trafficmanager.net/api/solution/20151/team/statistics?page=1&pageSize=1000&sortOrder=desc&sortStatId=15&seasonId=\(seasonID)&divisionId=\(divisionID)")!
//        let url = URL(string: "https://the-rinks-great-park-ice.kreezee-sports.com/api/v2/solutions/20151/players/statistics?page=1&pageSize=12&sortOrder=desc&sortStatId=29&positionType=2&seasonId=\(seasonID)&divisionId=\(divisionID)")!

        let request = URLRequest(url: url)

        /*
         GF - statID: 1 - 33
         GA - statID: 2 - 14
         PP - statID: 3 - 4
         SH - statID: 4 - 0
         GP - statID: 5 - 5
         W - statID: 6 - 3
         L - statID: 7 - 2
         T - statID: 8 - 0
         OTL - statID: 9 - 0
         SOL - statID: 10 - 0
         statID: 11 - 0
         statID: 12 - 0
         PIM - statID: 13 - 140
         statID: 14 - 0
         PTS - statID: 15 - 6
         DIFF - statID: 16 - 19
         */

        do {
            var updatedTeams = [StandingsResponse.Team]()
            let response = try await API.fetchResponse(for: request, decodable: StandingsResponse.self)
            for result in response.results {

                var gf, ga, pp, sh, gp, w, l, t, otl, sol, pim, pts, diff: String?

                for stat in result.stats {
                    switch stat.statTypeId {
                    case 1:
                        gf = stat.displayValue
                    case 2:
                        ga = stat.displayValue
                    case 3:
                        pp = stat.displayValue
                    case 4:
                        sh = stat.displayValue
                    case 5:
                        gp = stat.displayValue
                    case 6:
                        w = stat.displayValue
                    case 7:
                        l = stat.displayValue
                    case 8:
                        t = stat.displayValue
                    case 9:
                        otl = stat.displayValue
                    case 12:
                        sol = stat.displayValue
                    case 13:
                        pim = stat.displayValue
                    case 15:
                        pts = stat.displayValue
                    case 16:
                        diff = stat.displayValue
                    default:
                        continue
                    }
                }

                guard
                    let gp = gp,
                    let w = w, let l = l, let t = t, let otl = otl, let sol = sol,
                    let pts = pts, let gf = gf, let ga = ga, let ppg = pp, let sh = sh,
                    let diff = diff, let pim = pim else {
                        return
                    }
                let team = StandingsResponse.Team(
                    id: result.id,
                    name: result.name,
                    gp: gp, w: w, l: l, t: t, otl: otl, sol: sol, pts: pts, gf: gf, ga: ga, ppg: ppg, shg: sh, diff: diff, pim: pim)
                updatedTeams.append(team)
            }


            teams = updatedTeams
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

extension StandingsViewModel: Equatable {
    nonisolated static func ==(lhs: StandingsViewModel, rhs: StandingsViewModel) -> Bool {
        lhs.id == rhs.id
    }
}
