//
//  StandingsResponse.swift
//  warriors
//
//  Created by Eric Ito on 3/12/22.
//

import Foundation

struct StandingsResponse: Decodable {

    let results: [Result]
//    private enum CodingKeys: String, CodingKey {
//        case results
//    }

    struct Team: Identifiable {
        var id: String {
            name
        }
        let name: String
        let gp: String
        let w: String
        let l: String
        let t: String
        let otl: String
        let sol: String
        let pts: String
        let gf: String
        let ga: String
        let ppg: String
        let shg: String
        let diff: String
        let pim: String
    }

    struct Result: Decodable {
        let fullName: String
        let name: String
        let stats: [Stat]

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
        struct Stat: Decodable {
            let statTypeId: Int
            let value: Int
            let displayValue: String
        }
    }
}
