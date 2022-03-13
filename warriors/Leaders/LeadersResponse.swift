//
//  LeadersResponse.swift
//  warriors
//
//  Created by Eric Ito on 3/12/22.
//

import Foundation

struct LeadersResponse: Decodable {

    let results: [Result]

    private enum CodingKeys: String, CodingKey {
        case results = "Results"
    }

    struct Result: Decodable {
        let teamName: String
        let teamID: Int
        let playerID: Int
        let firstName: String
        let lastName: String
        let fullName: String
        let stats: [Stat]

        private enum CodingKeys: String, CodingKey {
            case teamName = "TeamName"
            case teamID = "TeamId"
            case playerID = "Id"
            case firstName = "FirstName"
            case lastName = "LastName"
            case fullName = "Name"
            case stats = "Stats"
        }

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
