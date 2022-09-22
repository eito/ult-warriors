//
//  API+Shared.swift
//  warriors
//
//  Created by Eric Ito on 9/17/22.
//

import Foundation

enum API {

    // NOTE: Some endpoints are not available but they embed the JSON inside
    // the HTML response. Super flaky, but it'll do for now.
    //
    // https://the-rinks-great-park-ice.kreezee-sports.com/scores/game-340257
    // var __gameDetails__ = '{<json>}';
    //
    static func fetchResponse<T: Decodable>(for request: URLRequest, in jsonVariable: String, decodable: T.Type) async throws -> T {

        let (data, _) = try await URLSession.shared.data(for: request)
        guard let string = String(data: data, encoding: .utf8) else {
            throw NSError(domain: "invalid string data", code: 1, userInfo: nil)
        }

        let allLines = string.components(separatedBy: CharacterSet.newlines)

        guard let gameDetailsString = allLines.first(where:  { $0.contains(jsonVariable) }) else {
            throw NSError(domain: "invalid jsonVariable, not found \(jsonVariable)", code: 1, userInfo: nil)
        }

        guard let firstIndex = gameDetailsString.firstIndex(of: "{") else {
            throw NSError(domain: "invalid jsonVariable, could not find {", code: 1, userInfo: nil)
        }
        guard let lastIndex = gameDetailsString.lastIndex(of: "}") else {
            throw NSError(domain: "invalid jsonVariable, could not find }", code: 1, userInfo: nil)
        }

        let range = firstIndex...lastIndex

        let jsonString = String(gameDetailsString[range])
//        print(jsonString)

        guard let jsonData = jsonString.data(using: .utf8) else {
            throw NSError(domain: "failed to convert \(jsonString) to data", code: 1, userInfo: nil)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Partial)
        return try decoder.decode(decodable.self, from: jsonData)
    }

    static func fetchResponse<T: Decodable>(for request: URLRequest, decodable: T.Type) async throws -> T {
        let (data, _) = try await URLSession.shared.data(for: request)

#if DEBUG
//        if let str = String(data: data, encoding: .utf8) {
//            print("[JSON] - json response \(str)")
//        }
#endif
//        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//            print("bad error code")
//            return
//        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Partial)
        return try decoder.decode(decodable.self, from: data)
    }
    
    static func fetchSchedule(forTeamID teamID: Int, seasonID: Int) async throws -> [ScheduleResponse.Game] {

        let url = URL(string: "https://the-rinks-great-park-ice.kreezee-sports.com/api/v2/solutions/20151/seasons/\(seasonID)/schedule")!
        let request = URLRequest(url: url)

        let allGamesResponses = try await API.fetchResponse(for: request, decodable: [ScheduleResponse.GameResponse].self)

        let allGames = allGamesResponses.compactMap { ScheduleResponse.Game(response: $0) }

        var scheduledGames = [ScheduleResponse.Game]()
        for game in allGames.filter({ ($0.homeTeamID == teamID || $0.awayTeamID == teamID) && !$0.isFinal }) {
//                print("\(game.id)  --- \(game.awayTeamName) @ \(game.homeTeamName)")

            scheduledGames.append(game)
        }

        return scheduledGames
    }

    static func fetchNextGame(forTeamID teamID: Int, seasonID: Int) async throws -> ScheduleResponse.Game? {

        let games = try await fetchSchedule(forTeamID: teamID, seasonID: seasonID)

        return games.first(where: { !$0.isFinal })
    }
}
