//
//  GameDetailViewModel.swift
//  Warriors
//
//  Created by Eric Ito on 3/14/22.
//

import Foundation
import SwiftUI

@MainActor
class GameDetailViewModel: ObservableObject {

    let id: Int
    private let game: ScheduleResponse.Game

    var boxScore: BoxScore?

    var homeTeamName: String {
        game.homeTeamName
    }

    var awayTeamName: String {
        game.awayTeamName
    }

    @Published var selectedSegmentIndex = 0
    @Published var summaryViewModel: SummaryViewModel? = nil
    @Published var homeTeamViewModel: TeamViewModel? = nil
    @Published var awayTeamViewModel: TeamViewModel? = nil
    @Published var status: Status = .idle

    init(game: ScheduleResponse.Game) {
        id = game.id
        self.game = game
    }

    func refresh() async {

        status = .loading
        
        // fetch homeTeam roster
        // fetch awayTeam roster
        // fetch gameDetails
        //
        do {
            let url = URL(string: "https://the-rinks-great-park-ice.kreezee-sports.com/scores/game-\(game.id)")!

            let request = URLRequest(url: url)

            let response = try await API.fetchResponse(for: request, in: "var __gameDetails__", decodable: GameDetailResponse.self)
//            let response = try await API.fetchResponse(for: request, decodable: GameDetailResponse.self)

            parseBoxScore(from: response)
            parseSummaryViewModel(from: response)
            parseHomeTeam(from: response)
            parseAwayTeam(from: response)
            
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

    private func parseHomeTeam(from response: GameDetailResponse) {
        parseTeamViewModel(from: response, for: game.homeTeamID, isHome: true)
    }

    private func parseAwayTeam(from response: GameDetailResponse) {
        parseTeamViewModel(from: response, for: game.awayTeamID, isHome: false)
    }

    private func parseTeamViewModel(from response: GameDetailResponse, for teamID: Int, isHome: Bool) {

        guard let team = response.teams.first(where: { $0.id == teamID }) else {
            return
        }

        var skaters = [Skater]()

        for player in team.players {

            if player.stats.isEmpty {
                continue
            }

            let goals = player.stats.first(where: { $0.statTypeID == 6 })?.value ?? -1
            let assists = player.stats.first(where: { $0.statTypeID == 7 })?.value ?? -1
            let pim = player.stats.first(where: { $0.statTypeID == 8 })?.value ?? -1
            let ppg = player.stats.first(where: { $0.statTypeID == 26 })?.value ?? -1
            let shg = player.stats.first(where: { $0.statTypeID == 27 })?.value ?? -1
            let gwg = player.stats.first(where: { $0.statTypeID == 28 })?.value ?? -1
            let pts = player.stats.first(where: { $0.statTypeID == 29 })?.value ?? -1

            if goals == -1 || assists == -1 || pim == -1 || ppg == -1 || shg == -1 ||
                gwg == -1 || pts == -1 {
                continue
            }

            let skater = Skater(
                teamID: player.teamID,
                playerID: player.id,
                name: player.name,
                team: team.name,
                goals: goals,
                assists: assists,
                pim: pim / 10,
                gamesPlayed: 0,
                ppg: ppg,
                shg: shg,
                gwg: gwg,
                pts: pts,
                number: player.number
            )
            skaters.append(skater)
        }

        skaters = skaters.sorted { s1, s2 in
            if s1.pts == s2.pts {
                return s1.goals > s2.goals
            } else {
                return s1.pts > s2.pts
            }
        }

        if isHome {
            homeTeamViewModel = TeamViewModel(teamName: team.name, skaters: skaters)
        } else {
            awayTeamViewModel = TeamViewModel(teamName: team.name, skaters: skaters)
        }
    }

    private func parseSummaryViewModel(from response: GameDetailResponse) {

        let rawGoals: [GameDetailResponse.Event] = response.events.compactMap {
            if $0.qualifier == 161 || $0.qualifier == 163 {
                return $0
            } else {
                return nil
            }
        }

        var allGoals = [SummaryViewModel.Goal]()
        for rawGoal in rawGoals {

            guard let periodID = rawGoal.periodID else { return }
            let teamName = rawGoal.teamID == response.homeTeamID ? response.homeTeamName : response.awayTeamName

            var scorerName: String = ""
            var goalTime: String = "--"
            var assist1Name: String?
            var assist2Name: String?

            let hasAssist1 = rawGoal.stats.count >= 2
            let hasAssist2 = rawGoal.stats.count == 3

            if rawGoal.stats.isEmpty {
                scorerName = "Unknown"
            } else {
                let goalScorerID = rawGoal.stats[0].playerID
                if let player = response.teams[0].players.first(where: { $0.id == goalScorerID }) {
                    scorerName = player.name
                    goalTime = rawGoal.time // TODO split
                } else if let player = response.teams[1].players.first(where: { $0.id == goalScorerID }) {
                    scorerName = player.name
                    goalTime = rawGoal.time // TODO split
                }

                if hasAssist1 {
                    let assist1ID = rawGoal.stats[1].playerID
                    if let player = response.teams[0].players.first(where: { $0.id == assist1ID }) {
                        assist1Name = player.name
                    } else if let player = response.teams[1].players.first(where: { $0.id == assist1ID }) {
                        assist1Name = player.name
                    }
                }

                if hasAssist2 {
                    let assist2ID = rawGoal.stats[2].playerID
                    if let player = response.teams[0].players.first(where: { $0.id == assist2ID }) {
                        assist2Name = player.name
                    } else if let player = response.teams[1].players.first(where: { $0.id == assist2ID }) {
                        assist2Name = player.name
                    }
                }
            }

            let goal = SummaryViewModel.Goal(
                id: rawGoal.id,
                scorerName: scorerName,
                teamName: teamName,
                number: "--",
                timeElapsed: goalTime,
                period: periodID,
                assist1Name: assist1Name,
                assist2Name: assist2Name,
                isSHG: false,
                isPPG: false
            )

            allGoals.append(goal)
        }

        summaryViewModel = SummaryViewModel(goals: allGoals, penalties: [])
    }

    private func parseBoxScore(from response: GameDetailResponse) {
        let homeTeamID = response.homeTeamID
        let homeTeamName = response.homeTeamName
        let homeTeamScore = response.homeScore

//        let awayTeamID = response.awayTeamID
        let awayTeamName = response.awayTeamName
        let awayTeamScore = response.awayScore

        var homeGoalsByPerioud = [
            1 : 0,
            2 : 0,
            3 : 0
        ]
        var awayGoalsByPerioud = [
            1 : 0,
            2 : 0,
            3 : 0
        ]

        let goals: [GameDetailResponse.Event] = response.events.compactMap {
            if $0.qualifier == 161 || $0.qualifier == 163 {
                return $0
            } else {
                return nil
            }
        }

        for goal in goals {
            if let period = goal.periodID {
                if goal.teamID == homeTeamID {
                    homeGoalsByPerioud[period]! += 1
                } else {
                    awayGoalsByPerioud[period]! += 1
                }
            }
        }

        boxScore = BoxScore(
            homeTeamName: homeTeamName,
            homeGoalsByPeriod: homeGoalsByPerioud,
            homeScore: homeTeamScore,
            awayTeamName: awayTeamName,
            awayGoalsByPeriod: awayGoalsByPerioud,
            awayScore: awayTeamScore)
    }
}
