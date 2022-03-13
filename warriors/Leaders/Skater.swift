//
//  Skater.swift
//  warriors
//
//  Created by Eric Ito on 3/12/22.
//

import Foundation

struct Skater: Identifiable, Equatable, Hashable {
    let teamID: Int
    let playerID: Int
    let gamesPlayed: Int
    let goals: Int
    let assists: Int
    let pim: Int
    let ppg: Int
    let shg: Int
    let gwg: Int
    let pts: Int
//    let number: String
    let name: String
    let team: String

    var id: Int {
        playerID
    }

    init(result: LeadersResponse.Result) {

        // G = 6
        // A = 7
        // PIM = 8
        // GP = 14
        // PPG = 26
        // SHG = 27
        // GWG = 28
        // PTS = 29
        // points/game = 31

        teamID = result.teamID
        playerID = result.playerID
        name = result.fullName
        team = result.teamName
        goals = result.stats.first(where: { $0.statTypeId == 6 })?.value ?? -1
        assists = result.stats.first(where: { $0.statTypeId == 7 })?.value ?? -1
        pim = (result.stats.first(where: { $0.statTypeId == 8 })?.value ?? 0) / 10
        gamesPlayed = result.stats.first(where: { $0.statTypeId == 14 })?.value ?? -1
        ppg = result.stats.first(where: { $0.statTypeId == 26 })?.value ?? -1
        shg = result.stats.first(where: { $0.statTypeId == 27 })?.value ?? -1
        gwg = result.stats.first(where: { $0.statTypeId == 28 })?.value ?? -1
        pts = result.stats.first(where: { $0.statTypeId == 29 })?.value ?? -1
    }

    static func ==(lhs: Skater, rhs: Skater) -> Bool {
        lhs.playerID == rhs.playerID && lhs.gamesPlayed == rhs.gamesPlayed
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(playerID)
    }
}
