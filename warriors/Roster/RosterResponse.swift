//
//  RosterResponse.swift
//  Warriors
//
//  Created by Eric Ito on 3/13/22.
//

import Foundation

struct RosterResponse: Decodable {

    let playerCategories: [PlayerCategory]

    private enum CodingKeys: String, CodingKey {
        case playerCategories = "PlayersCategories"
    }

    struct PlayerCategory: Decodable {

        let id: Int
        let name: String
        let players: [Player]

        private enum CodingKeys: String, CodingKey {
            case id = "Id"
            case name = "Name"
            case players = "Players"
        }

        struct Player: Decodable {

            let id: Int
            let number: String
            let teamName: String
            let firstName: String
            let lastName: String
            let name: String
            let stats: [Stat]

            private enum CodingKeys: String, CodingKey {
                case id = "Id"
                case number = "Number"
                case teamName = "TeamName"
                case firstName = "FirstName"
                case lastName = "LastName"
                case name = "Name"
                case stats = "Stats"
            }

            /*
             sid 6  ------- 5   GOALS
             sid 7  ------- 4   ASSISTS
             sid 8  ------- 20 2 -- PIM
             sid 9
             sid 10 --- 17
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
             sid 23 --- 23
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
            struct Stat: Decodable {
                let statTypeId: Int
                let value: Int
                let displayValue: String

                private enum CodingKeys: String, CodingKey {
                    case statTypeId = "StatTypeId"
                    case value = "Value"
                    case displayValue = "DisplayValue"
                }
            }
        }
    }
}
