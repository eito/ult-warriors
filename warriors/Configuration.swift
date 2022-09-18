//
//  Configuration.swift
//  Warriors
//
//  Created by Eric Ito on 9/17/22.
//

import Foundation

struct Configuration: Decodable {

    let teamID: Int
    let seasonID: Int
    let divisionID: Int

    private enum CodingKeys: String, CodingKey {
        case teamID = "teamId"
        case seasonID = "seasonId"
        case divisionID = "divisionId"
    }
}
