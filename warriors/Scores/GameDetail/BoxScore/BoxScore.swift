//
//  BoxScore.swift
//  Warriors
//
//  Created by Eric Ito on 3/16/22.
//

import Foundation

struct BoxScore: CustomStringConvertible {
    let homeTeamName: String
    let homeGoalsByPeriod: [Int : Int]
    let homeScore: Int
    let awayTeamName: String
    let awayGoalsByPeriod: [Int : Int]
    let awayScore: Int

    var description: String {
"""
+=======================================================+
|                        BoxScore                       |
|=======================================================|
| Team                  | 1st |  2nd  |  3rd  |  Total  |
+=======================================================+
|  \(awayTeamName) | \(awayGoalsByPeriod[1]!) | \(awayGoalsByPeriod[2]!) | \(awayGoalsByPeriod[3]!) | \(awayScore) |
|  \(homeTeamName) | \(homeGoalsByPeriod[1]!) | \(homeGoalsByPeriod[2]!) | \(homeGoalsByPeriod[3]!) | \(homeScore) |
+=======================================================+
"""
    }
}
