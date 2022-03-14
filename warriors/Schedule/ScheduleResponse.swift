//
//  ScheduleResponse.swift
//  warriors
//
//  Created by Eric Ito on 3/12/22.
//

import Foundation

struct ScheduleResponse: Decodable {

    let games: [Game]

    struct Game: Decodable {

        private static var dateFormatter: DateFormatter = {
            let df = DateFormatter()

            // schedule API returns date separate from time, in GMT
            // need to set this so we don't show one day prior
            //
            df.timeZone = TimeZone(secondsFromGMT: 0)
            df.dateFormat = "EEE M/d"
            return df
        }()

        private static var timeFormatter: DateFormatter = {
            let df = DateFormatter()
            df.dateFormat = "h:mm a"
            return df
        }()

        private static var startTimeFormatter: DateFormatter = {
            let df = DateFormatter()
            df.dateFormat = "HH:mm:ss"
            return df
        }()

        var dateString: String {
            Self.dateFormatter.string(from: date)
        }

        var timeString: String {
            guard let date = Self.startTimeFormatter.date(from: startTime) else { return "" }

            return Self.timeFormatter.string(from: date)
        }

        var rinkNumber: String {
            rinkName.components(separatedBy: " ").last ?? "--"
        }

        var status: String {
            if isFinal {
                if periodID == 9 {
                    return "F/SO"
                } else {
                    return "Final"
                }
            } else {
                return ""
            }
        }

        var isAwayTeamWinner: Bool {
            awayScore > homeScore
        }

        var isHomeTeamWinner: Bool {
            homeScore > awayScore
        }

        let homeTeamID: Int
        let homeTeamName: String
        let homeDivisionID: Int
        let homeScore: Int
        let awayTeamID: Int
        let awayTeamName: String
        let awayDivisionID: Int
        let awayScore: Int

        let isFinal: Bool
        let id: Int
        let seasonID: Int
        let rinkName: String
        let statusID: Int
        let date: Date
        let startTime: String
        let periodID: Int?

        private enum CodingKeys: String, CodingKey {
            case homeTeamID = "LocalTeamId"
            case homeTeamName = "LocalTeamName"
            case homeScore = "LocalResult"
            case homeDivisionID = "LocalDivisionId"
            case awayTeamID = "VisitorTeamId"
            case awayTeamName = "VisitorTeamName"
            case awayScore = "VisitorResult"
            case awayDivisionID = "VisitorDivisionId"

            case isFinal = "Final"
            case id = "Id"
            case seasonID = "SeasonId"
            case rinkName = "SportCenterName"
            case statusID = "StatusId"
            case date = "Date"
            case startTime = "StartTime"
            case periodID = "PeriodId"
        }
    }
}
