//
//  GameDetailResponse.swift
//  Warriors
//
//  Created by Eric Ito on 3/14/22.
//

import Foundation

struct GameDetailResponse: Decodable {

    let periodID: Int
    let homeTeamID: Int
    let homeTeamName: String
    let homeScore: Int
    let awayTeamID: Int
    let awayTeamName: String
    let awayScore: Int
    let events: [Event]
    let teams: [Team]
    let isFinal: Bool
    let date: Date
    let startTime: String

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

    private enum CodingKeys: String, CodingKey {
        case periodID = "periodId"
        case homeTeamID = "localTeamId"
        case homeTeamName = "localTeamName"
        case homeScore = "localResult"
        case awayTeamID = "visitorTeamId"
        case awayTeamName = "visitorTeamName"
        case awayScore = "visitorResult"

        case events = "eventList"
        case teams = "teamList"
        case isFinal = "final"
        case date
        case startTime
    }

    struct Event: Decodable {
        let id: Int
        let periodID: Int
        let gameID: Int
        let qualifier: Int?
        let stats: [Stat]
        let time: String
        let timeValue: String

        private enum CodingKeys: String, CodingKey {
            case id
            case periodID = "periodId"
            case gameID = "matchId"
            case qualifier
            case stats = "statList"
            case time
            case timeValue
        }

        struct Stat: Decodable {

            let statTypeID: Int
            let playerID: Int
            let value: Int
            let displayValue: String
            let teamID: Int

            private enum CodingKeys: String, CodingKey {
                case statTypeID = "statTypeId"
                case playerID = "playerId"
                case value
                case displayValue
                case teamID = "teamId"
            }
        }
    }

    struct Team: Decodable {

        let id: Int
        let name: String
        let stats: [Stat]
        let players: [Player]
        let playerCategories: [PlayerCategory]

        private enum CodingKeys: String, CodingKey {
            case id
            case name
            case stats
            case players
            case playerCategories = "playersCategories"
        }

        struct Stat: Decodable {

            let statTypeID: Int
            let teamID: Int
            let value: Int
            let displayValue: String

            private enum CodingKeys: String, CodingKey {
                case statTypeID = "statTypeId"
                case teamID = "teamId"
                case value
                case displayValue


            }
        }

        struct Player: Decodable {

            let id: Int
            let stats: [Stat]
            let number: String
            let teamID: Int
            let firstName: String
            let lastName: String
            let name: String

            private enum CodingKeys: String, CodingKey {
                case id
                case stats
                case number
                case teamID = "teamId"
                case firstName
                case lastName
                case name
            }

            struct Stat: Decodable {
                let statTypeID: Int
                let value: Int
                let displayValue: String

                private enum CodingKeys: String, CodingKey {
                    case statTypeID = "statTypeId"
                    case value
                    case displayValue
                }
            }
        }

        struct PlayerCategory: Decodable {
            let id: Int
            let players: [Player]

            private enum CodingKeys: String, CodingKey {
                case id
                case players
            }
        }
    }
}
